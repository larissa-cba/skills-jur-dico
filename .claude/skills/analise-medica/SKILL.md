---
name: analise-medica
description: Análise dos documentos médicos do cliente em benefício por incapacidade (temporária ou permanente), BPC/LOAS da pessoa com deficiência, auxílio-acidente e aposentadoria da pessoa com deficiência. Identifica no Advbox o que foi contratado e em que fase está o processo (inclusive perícia agendada ou laudo pendente); lê a pasta do cliente pelo roteiro de análise de documentos médicos do escritório; resume cada documento e diz o papel dele na prova (atestado, relatório, exame, receituário, prontuário); no auxílio-acidente confere acidente, lesões, nexo, natureza acidentária ou previdenciária e consolidação; na aposentadoria PcD confere o histórico da deficiência contra a data de início e o grau do cálculo do Previus; conclui se a documentação basta para seguir ou se vale juntar ao processo em andamento conforme a fase; diz o que mais pedir ao cliente; e entrega a conclusão e um resumo pronto para o sistema interno.
disable-model-invocation: true
---

# Análise médica — suficiência e oportunidade da prova

Chegaram documentos médicos de um cliente — na contratação, para dar entrada, ou no
meio de um processo já em curso. Esta skill responde, a cada rodada:

1. **O que foi contratado** com o cliente, e portanto que benefício a prova precisa
   sustentar? (Advbox + contrato na pasta.)
2. **Em que fase** está o processo, e há **perícia** ou avaliação social agendada,
   realizada ou com laudo pendente?
3. **O que diz cada documento**, em resumo objetivo, e que **papel** ele cumpre na
   prova daquele benefício?
4. O **conjunto** sustenta o que o benefício exige?
5. **Vale juntar agora?** Antes do protocolo, a pergunta é se basta para dar
   sequência; com processo em curso, depende da fase — em fase recursal, só
   documentação muito forte.
6. **O que mais pedir** ao cliente, e por quê.

O resultado fica num **arquivo vivo**, um por cliente, regravado a cada rodada:
`<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE MÉDICA - <NOME>.docx`. Ao final, um
**resumo para o sistema interno** vai na própria conversa, pronto para colar.

**Não faz:** análise inicial completa (`/analise-inicial`), recálculo no Previus
(exige login), petição, quesitos, impugnação de laudo, nem qualquer escrita no
Advbox — a consulta ao Advbox é **somente leitura**.

**Não altera a ficha da análise inicial** — ela é lida para contexto e mais nada.

## Invocação

```
/analise-medica <caminho da pasta do cliente>
/analise-medica <caminho da pasta do cliente> --refazer
```

- **Sem flag** — se o arquivo `ANÁLISE MÉDICA - *.docx` existe, é **atualização**: só
  os documentos novos ou alterados são lidos; contrato, fase, perícia, conclusão e
  pedidos são sempre refeitos inteiros. Se não existe, é a **primeira rodada**.
- **`--refazer`** — relê todos os documentos. Use quando o benefício contratado mudou
  ou a análise anterior está em dúvida. O histórico é preservado.

Se a pasta não foi informada, peça-a antes de qualquer outra coisa. Não adivinhe o
cliente pelo nome citado na conversa.

## Material compartilhado

Scripts e doutrina de leitura ficam em `../previdenciario-base/`. **Leia antes de
analisar qualquer documento:**

| Referência da base | Cobre |
|---|---|
| `$BASE/references/medicos.md` | o **roteiro de análise de documentos médicos do escritório**: triagem, o que extrair, confronto, resumo, divergências, incapacidade, PcD, conclusão |
| `$BASE/references/advbox.md` | a API do Advbox: o script, o que cada campo significa, etapas e fases do escritório, tarefas que indicam perícia |
| `$BASE/references/legislacao.md` | o acervo e a regra de **nunca afirmar lei de memória** |

Próprias desta skill:

| Referência desta skill | Cobre |
|---|---|
| `$SKILL/references/contrato-e-fase.md` | identificar o contrato, a fase e a perícia; a régua de **juntar / não juntar** por fase; o que é documentação **muito forte** |
| `$SKILL/references/beneficios.md` | o que a prova precisa mostrar em cada benefício, o **papel de cada tipo de documento**, e o mapa dos dispositivos no acervo |
| `$SKILL/references/formato-analise.md` | estrutura do arquivo vivo, resumo por documento, conclusão, pedidos, histórico e o resumo para o sistema |

> **Todo caminho neste arquivo é relativo à pasta desta skill**, informada como
> "Base directory for this skill" quando a skill carrega — **não** ao diretório de
> trabalho da sessão. Antes do primeiro comando:
>
> ```bash
> SKILL="<base directory desta skill>"
> BASE="$SKILL/../previdenciario-base"
> ```

## Fluxo

### 1. Análise existente

Procure `<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE MÉDICA - *.docx`. Se existir:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/ler-docx.ps1" -Origem "<ANÁLISE MÉDICA - NOME.docx>" -Destino "<pasta de trabalho>/analise-anterior.txt"
```

Dela saem: benefício contratado, fase na rodada anterior, **inventário** dos
documentos já analisados (identificador, arquivo, tamanho, data de modificação,
grau), conclusão anterior, pedidos em aberto e histórico. Ver
`$SKILL/references/formato-analise.md`.

Pasta de trabalho sempre no diretório temporário da sessão, nunca na pasta do
cliente.

### 2. Contrato, fase e perícia — Advbox

Procedimento completo em `$SKILL/references/contrato-e-fase.md`. Em resumo:

```bash
ADV="$BASE/scripts/advbox.ps1"
powershell -ExecutionPolicy Bypass -File "$ADV" -Acao cliente -Nome "<NOME DO CLIENTE>"
powershell -ExecutionPolicy Bypass -File "$ADV" -Acao processos -ClienteId <id>
powershell -ExecutionPolicy Bypass -File "$ADV" -Acao processo  -ProcessoId <id>
powershell -ExecutionPolicy Bypass -File "$ADV" -Acao pericia   -ProcessoId <id>
```

O nome do cliente vem da pasta (é o nome dela). Mais de um cliente com o mesmo nome:
confirme pelo CPF de um documento da pasta (`-Cpf`), sem transcrevê-lo em lugar
nenhum.

- **Contrato** — o **tipo** do processo no Advbox (`2.2.01 – BENEFÍCIO POR
  INCAPACIDADE TEMPORÁRIA`, `2.1.10 – APOSENTADORIA PCD POR TEMPO DE CONTRIBUIÇÃO`,
  `2.3.01 – AUXÍLIO-ACIDENTE`, `2.4.01 – BPC/LOAS IDOSO/DEFICIÊNCIA`…), conferido com
  o **contrato de honorários** da pasta quando houver. Divergência entre os dois é
  ponto de atenção.
- **Fase** — **etapa** (`NEGOCIAÇÃO`, `CONSULTORIA`, `ADMINISTRATIVO`, `JUDICIAL`,
  `RECURSAL`, `EXECUÇÃO/COBRANÇA`, `ARQUIVAMENTO`) e **fase** dentro dela, mais as
  últimas movimentações.
- **Perícia** — a ação `pericia` junta fase, histórico, tarefas, movimentações e
  publicações e devolve só o que fala de perícia, avaliação social, laudo ou
  audiência. Diga se a perícia **não houve**, **está agendada (data)**, **foi
  realizada e o laudo está pendente** ou **tem laudo** — e, havendo laudo, procure-o
  na pasta e leia-o: ele é o documento mais importante da rodada.

Se o Advbox falhar (sem token, erro HTTP, cliente não localizado), diga isso, siga
com a pasta, e pergunte na primeira parada o contrato e a fase. **Nunca presuma a
fase.**

O cliente pode ter vários processos no Advbox. Considere os do grupo previdenciário
ligado a esta análise (incapacidade, auxílio-acidente, assistenciais, aposentadorias
PcD, `2.8.09 - AP PCD` no RPPS) e pergunte quando houver mais de um em curso.

### 3. Varredura

```bash
bash "$BASE/scripts/varrer-pasta.sh" "<pasta do cliente>"
find "<pasta do cliente>" -type f -printf '%s\t%TY-%Tm-%Td %TH:%TM\t%P\n'
```

Localize, **pelo conteúdo e não pelo nome**:

- **documentos médicos** — atestados, relatórios e laudos, exames de imagem e
  laboratoriais, receituários, prontuários, relatórios de fisioterapia e terapia,
  internação e alta, CAT, perícias do INSS (laudo SABI), perícias judiciais,
  avaliações sociais;
- **contrato de honorários** e procuração — o objeto do contrato;
- **cálculos do Previus** (`Cálculo de <NOME> (...).pdf`) — na aposentadoria PcD são
  de leitura obrigatória (data de início e grau da deficiência assumidos);
- **processo administrativo e judicial** — comunicação de decisão, laudo pericial,
  sentença, acórdão: é o que foi negado e por quê;
- **CNIS e CTPS** — atividade habitual, períodos de benefício, vínculo na data do
  acidente;
- **ficha da análise inicial** — leitura só, para contexto.

Em atualização, compare com o inventário: **novo**, **alterado**, **já analisado**,
**sumiu**, **renomeado provável** — mesma regra de `analise-rural`: nada se apaga,
documento que sumiu fica marcado `não localizado na pasta em DD/MM/AAAA`.

### 4. Primeira parada — confirmação

Apresente numa só mensagem e **pare** com `AskUserQuestion`:

- o **contrato** (tipo no Advbox e objeto do contrato da pasta) e o benefício que a
  análise vai testar;
- a **etapa e a fase**, a situação da **perícia** e as últimas movimentações
  relevantes;
- a pergunta desta rodada, conforme a fase: **"basta para dar sequência?"** ou
  **"vale juntar ao processo em curso?"**;
- os documentos **novos, alterados, sumidos, renomeados prováveis** (ou todos, na
  primeira rodada), com a triagem de `medicos.md` e **quantas páginas escaneadas**
  isso custa;
- documentos que você suspeita serem de terceiro.

Custo nunca justifica pular documento: é motivo para perguntar.

### 5. Leitura

```bash
bash "$BASE/scripts/ler-pdf.sh" "<arquivo.pdf>" "<pasta de trabalho>"
```

Documento médico é quase sempre escaneado: leia como imagem, com atenção a data,
médico e especialidade (CRM), CID, achados objetivos, conclusão, afastamento e
**página** onde está cada achado. Manuscrito ilegível: tente 300 dpi; persistindo,
registre o que não foi lido.

Na aposentadoria PcD, procure ativamente o **documento mais antigo** da condição —
ele decide se a data de início do Previus se sustenta.

### 6. Resumo e papel de cada documento

Para cada documento novo ou alterado, preencha a ficha de
`$SKILL/references/formato-analise.md`: resumo objetivo no padrão do roteiro (tipo,
data, profissional, quadro, achados, conclusão, afastamento, CID, página), o
**papel na prova** e o **grau**:

| Papel (beneficios.md, seção 1) | Em uma linha |
|---|---|
| **afirma** | atestado, relatório, laudo do assistente — diz o diagnóstico, a limitação, o afastamento |
| **comprova** | exame — demonstra objetivamente o que o atestado afirma |
| **mostra tratamento** | receituário, fisioterapia — continuidade e seriedade do tratamento |
| **registra o histórico** | prontuário, internação e alta — evolução, datas, queixas ao longo do tempo |
| **decide** | perícia do INSS, perícia judicial, avaliação social — o que foi concluído contra ou a favor |

| Grau | Em uma linha |
|---|---|
| **forte** | sozinho prova um ponto que o benefício exige (beneficios.md) |
| **depende de mais documentos** | aponta na direção certa, mas precisa de outro que o confirme |
| **fraco** | pouco ou nada acrescenta ao que o benefício exige |

Documento que **prejudica** a tese (alta sem limitação, exame normal, data que
derruba a DII ou o início da deficiência, atividade incompatível) recebe também a
marca **contrário** e vai para os pontos de atenção.

Identificador estável (`M01`, `M02`…), que **nunca se renumera** entre rodadas.

### 7. Análise do conjunto, por benefício

Refeita **inteira a cada rodada**, com todos os documentos. Aplique a seção do
benefício contratado em `$SKILL/references/beneficios.md`:

- **Incapacidade (temporária ou permanente)** — condição clínica + limitação
  funcional + **atividade habitual** + período de incapacidade (DII). Os atestados e
  relatórios afirmam; há exame que comprove? receituário que mostre tratamento?
  prontuário que mostre a evolução? há documentação contemporânea à DII alegada?
- **BPC da pessoa com deficiência** — impedimento de longo prazo e barreiras à
  participação; a mesma pergunta sobre o papel de cada documento; duração do
  impedimento.
- **Auxílio-acidente** — comprova o **acidente**? as **lesões**? o **nexo** entre os
  dois? é **acidentário** (do trabalho) ou **previdenciário** (de qualquer natureza)?
  comprova a **consolidação** das lesões e a **sequela** que reduz a capacidade para
  a atividade habitual?
- **Aposentadoria PcD** — o **histórico** da deficiência ou da doença; o **documento
  mais antigo** e se confere com a **data de início da deficiência do Previus**; a
  **manutenção** da limitação ao longo do tempo (há buracos?); o **grau** assumido no
  Previus é compatível com o que os documentos descrevem; **como a condição limita a
  pessoa no dia a dia**.

Confronte sempre (roteiro, seção 2) e registre **divergências** expressamente —
principalmente documento particular × perícia do INSS × perícia judicial.

Conclusão do conjunto, uma de três:

| Conclusão | Quando |
|---|---|
| **suficiente** | todos os pontos que o benefício exige têm prova forte, sem contrário sem resposta |
| **suficiente com ressalvas** | dá para seguir, mas há ponto que só depende de mais documentos — e o pedido já sai nesta rodada |
| **insuficiente** | algum ponto essencial está fraco, sem prova, ou derrubado por documento contrário |

### 8. Vale juntar? — régua da fase

Conforme `$SKILL/references/contrato-e-fase.md`, seção 4, uma de quatro:

| Recomendação | Quando |
|---|---|
| **dar sequência** | antes do protocolo, conjunto suficiente (com ou sem ressalvas) |
| **juntar** | processo em curso, fase em que a prova ainda é útil (antes da decisão ou da perícia) e o documento acrescenta |
| **juntar só se muito forte** | fase recursal, ou perícia já feita com laudo contrário — e diga se este documento **é** muito forte, pelo critério da seção 5 |
| **não juntar** | não acrescenta, fase em que não cabe, ou processo encerrado — e diga se cabe **novo requerimento** |

Na aposentadoria PcD com Previus, diga ainda se a premissa do cálculo (data de
início e grau) está **sustentada**, **em risco** ou **não sustentada**. Não estime
tempo nem RMI.

### 9. Pedido de documentos

**Sempre** diga se vale pedir novos ou outros documentos — mesmo quando a conclusão é
**suficiente** (diga então "não é necessário pedir mais", e por quê). Cada pedido diz
**o quê**, **de que período**, **de quem** (médico assistente, hospital, UBS,
empresa, INSS) e **qual ponto prova**. Ver `beneficios.md`, seção 6.

### 10. Segunda parada — dúvidas e decisões

Reúna **todas** as dúvidas num bloco só e pergunte de uma vez. Obrigatórias:

1. **O que mudou** desde a rodada anterior — conclusão ou recomendação que mudou, e
   por causa de qual documento.
2. **Divergências** entre documentos, especialmente com perícia do INSS ou judicial.
3. **Documentos contrários.**
4. A **recomendação de juntada** quando ela for **juntar só se muito forte** — a
   decisão é da equipe.
5. Na aposentadoria PcD, **data de início ou grau do Previus em risco**.

### 11. Gravação

Monte a análise inteira como `.txt` UTF-8 na marcação de `gerar-docx.ps1`, conforme
`$SKILL/references/formato-analise.md`, e converta:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/gerar-docx.ps1" -Origem "<analise.txt>" -Destino "<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE MÉDICA - <NOME>.docx"
```

Antes de regravar: copie a versão anterior para a pasta de trabalho temporária;
confira que **todas** as fichas e linhas do histórico anteriores estão no texto novo;
acrescente a linha desta rodada ao histórico. `<NOME>` em maiúsculas, como na ficha
da análise inicial. Se `ANÁLISE INICIAL` não existir, crie-a com esse nome exato.

### 12. Resumo para o sistema interno

Por último, **na própria conversa** — não em arquivo —, dentro de um bloco de código,
texto puro, **sem tabela, sem markdown, sem negrito**, sem siglas que não sejam de
uso corrente na equipe. Modelo em `$SKILL/references/formato-analise.md`, seção 9.

## Regras que não se negociam

**Diagnóstico não é incapacidade, e CID não é deficiência.** O que se prova é a
limitação e como ela repercute na atividade habitual ou no dia a dia. Ver
`$BASE/references/medicos.md`.

**Atestado afirma, exame comprova.** Atestado ou relatório sem exame, receituário ou
prontuário que o sustente não passa de **depende de mais documentos** — salvo
relatório de especialista detalhado com achados objetivos descritos.

**Nunca conclua por um documento isolado.** O grau vem do conjunto e do confronto.

**Nunca presuma a fase nem o contrato.** Vêm do Advbox e da pasta; se não vierem,
pergunte.

**Em fase recursal, só documentação muito forte** — pelo critério de
`contrato-e-fase.md`, seção 5. Na dúvida, a recomendação é **juntar só se muito
forte**, e a decisão vai para a segunda parada.

**Nunca afirme uma regra legal de memória.** O mapa dos dispositivos está em
`beneficios.md`, seção 7, e se confere no acervo antes de citar. O acervo **não
tem** a LC 142/2013 nem a Lei 13.146/2015: na aposentadoria PcD, use o Decreto 3.048
(arts. 70-A a 70-I) e a IN 128 (arts. 303 a 315); o que só a LC 142 resolve fica
como **depende de conferência legal**.

**Nunca declare lido o que não foi lido.** `ler-pdf.sh` sai com código 4 e imprime
`!!! RENDERIZACAO INCOMPLETA` quando renderiza menos páginas do que o PDF tem.
Documento lido em parte não recebe grau **forte**.

**Advbox é só leitura.** O script só faz GET; nenhuma tarefa, movimentação ou
anotação é criada por esta skill. O resumo para o sistema é colado pela equipe.

**O token do Advbox nunca entra no repositório** nem em arquivo da pasta do
cliente. Fica em `ADVBOX_TOKEN` ou em `%USERPROFILE%\.advbox\token`.

**Nunca apague o que veio antes.** Ficha, linha de histórico e documento que sumiu
permanecem. Grau só muda com o motivo registrado.

**Toda rodada termina com o balanço de cobertura**, no próprio arquivo.

**Dados do cliente nunca entram neste repositório.** A análise vai só para a pasta
do cliente no Drive.

## Ambiente

Ferramentas, caminhos e limitações da máquina em `$BASE/references/ambiente.md`.
