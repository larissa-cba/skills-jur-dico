---
name: analise-ppp
description: Análise de PPP que chega no decorrer do processo do cliente. Confere o PPP novo pelo roteiro do escritório, localiza outros PPPs da mesma empresa e período na pasta, compara as versões (o que foi corrigido, o que persiste, o que piorou), diz qual usar e qual desconsiderar, avalia o potencial de tempo especial, valida os cálculos do Previus e, quando cabe, redige a minuta de pedido de retificação à empresa.
disable-model-invocation: true
---

# Análise de PPP

Analisa **um PPP que acabou de chegar** à pasta do cliente — seja o primeiro daquela
empresa, seja a versão retificada de um PPP já analisado — e responde:

1. Este PPP está correto e completo?
2. Há outros PPPs da mesma empresa e do mesmo período na pasta? Qual vale, qual se
   desconsidera, e o PPP novo corrigiu os equívocos do anterior?
3. O período tem capacidade de ser reconhecido como especial?
4. A previsão de cálculo feita no Previus continua de pé?
5. Cabe pedir retificação à empresa? Se cabe, o quê, item por item?

**Não faz** a análise inicial inteira (isso é `/analise-inicial`) nem recalcula no
Previus (exige login em sistema externo). Diz o que mudou e o que precisa ser
recalculado.

## Invocação

```
/analise-ppp <caminho da pasta do cliente>
/analise-ppp <caminho da pasta do cliente> <arquivo do PPP novo>
```

Se a pasta não foi informada, peça-a antes de qualquer outra coisa. Não tente
adivinhar o cliente a partir do nome mencionado na conversa.

## Material compartilhado

Scripts e doutrina de leitura ficam em `../previdenciario-base/`. O roteiro de PPP do
escritório está consolidado em `$BASE/references/ppp.md` — é a base desta skill e
**deve ser lido antes de analisar qualquer PPP**. Havendo qualquer agente químico no
PPP, leia também `$BASE/references/agentes-quimicos.md` — régua por período, mapa dos
Decretos 53.831/64 e 83.080/79, NR-15, NR-16 e LINACH. Aqui ficam só o que é próprio desta
skill: comparação de versões, validação do cálculo, formato da saída e minuta de
retificação.

> **Todo caminho neste arquivo é relativo à pasta desta skill**, informada como
> "Base directory for this skill" quando a skill carrega — **não** ao diretório de
> trabalho da sessão. Antes do primeiro comando:
>
> ```bash
> SKILL="<base directory desta skill>"
> BASE="$SKILL/../previdenciario-base"
> ```

## Fluxo

### 1. Varredura e identificação dos PPPs

```bash
bash "$BASE/scripts/varrer-pasta.sh" "<pasta do cliente>"
```

Localize **todos** os PPPs da pasta, inclusive os que estão dentro de processo
administrativo, processo judicial ou pasta de documentos da empresa. Classifique
pelo conteúdo, não pelo nome: PPP costuma vir chamado `DOC EMPRESA.pdf`,
`digitalizar0012.pdf` ou embutido nas páginas de um processo.

Localize também, porque serão usados adiante:

- **cálculos do Previus** (`Cálculo de <NOME> (...).pdf`);
- **ficha da análise inicial** (`ANÁLISE INICIAL/<NOME>.docx`) e documento de trabalho;
- **análises de PPP anteriores** e **pedidos de retificação** já gerados por esta
  skill (`ANÁLISE INICIAL/ANÁLISE DE PPP - *.docx`, `PEDIDO DE RETIFICAÇÃO DE PPP - *.docx`);
- **LTCAT, laudos, PPRA/PGR, CNIS e CTPS** — para o confronto da seção 10 do roteiro.

Se o arquivo do PPP novo não foi informado, indique como candidato o de emissão mais
recente (ou o de modificação mais recente no disco, se a emissão não estiver
legível) e confirme.

### 2. Primeira parada — confirmação

Apresente, numa só mensagem, e **pare** com `AskUserQuestion`:

- qual arquivo você está tratando como PPP novo;
- os demais PPPs encontrados, **agrupados por empresa** (CNPJ e razão social) com
  período e data de emissão de cada um — e quais você considera da mesma empresa e
  período que o novo;
- se encontrou cálculo do Previus, ficha, análise anterior ou pedido de retificação;
- o que vai ler para o confronto (LTCAT, CNIS, CTPS) e quantas páginas escaneadas
  isso custa.

Regras de agrupamento em `$SKILL/references/comparacao.md`.

### 3. Leitura

```bash
bash "$BASE/scripts/ler-pdf.sh" "<arquivo.pdf>" "<pasta de trabalho>"
```

Pasta de trabalho no diretório temporário da sessão, nunca na pasta do cliente.

**Todo PPP do grupo é lido por inteiro** — o novo e os anteriores da mesma empresa e
período. PPP nunca entra em triagem. A comparação só vale se os dois lados foram
lidos campo a campo.

A ficha e o documento de trabalho existentes se leem com:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/ler-docx.ps1" -Origem "<arquivo.docx>"
```

### 4. Análise do PPP novo

Aplique o roteiro inteiro de `$BASE/references/ppp.md`, seções 1 a 13, ao PPP novo:
conferência inicial, função e atividades, agentes, período e habitualidade,
quantitativos, químicos e biológicos, responsável técnico, EPI/EPC, regularidade
formal, confronto com outras provas, inconsistências, classificação e conclusão.

**Agente químico: produto não é agente.** Para cada agente químico, identifique o
**composto** e compare com a **letra da norma do período** (decreto até 05/03/1997;
Anexo IV e NR-15 depois; LINACH para cancerígenos a partir de 08/10/2014), conforme
`$BASE/references/agentes-quimicos.md`. "Óleo mineral", "óleo diesel", "graxa",
"solvente", "produtos químicos" sem composição não sustentam grau **forte**: no
máximo **depende de complementação**, com a FISPQ, o LTCAT ou a retificação como
providência. Abra o decreto ou o anexo e leia o código — os decretos de 1964 e 1979
são escaneados; renderize só as páginas do mapa.

Monte a **lista de verificação** campo a campo (modelo em
`$SKILL/references/formato-analise.md`): cada item sai como **correto**,
**incompleto**, **incorreto** ou **ausente**, com a evidência — página e campo do PPP.

### 5. Comparação com os PPPs anteriores

Só quando há outro PPP da mesma empresa e período. Procedimento completo em
`$SKILL/references/comparacao.md`. Em resumo:

- quadro comparativo campo a campo entre as versões;
- para cada equívoco do anterior: **corrigido**, **persiste** ou **corrigido em
  parte**; e, para o novo, **novo problema** ou **piorou** (informação favorável que
  sumiu);
- se houve pedido de retificação anterior, confira **item por item** se o que foi
  pedido foi atendido;
- veredito por PPP: **usar**, **usar em conjunto** ou **desconsiderar**, com o motivo.

> **Mais recente não é sinônimo de melhor.** Um PPP retificado que tirou um agente
> nocivo, trocou "habitual e permanente" por "eventual" ou passou a informar EPI
> eficaz *piorou* para o segurado. Isso é achado grave: destaque, não descarte o
> anterior, e leve à Larissa.

### 6. Capacidade de reconhecimento como especial

Para cada período do PPP (e, havendo comparação, com base na versão ou conjunto de
versões que se vai usar), aplique a classificação do roteiro com o grau:

| Grau | Significado |
|---|---|
| **Forte** | documentação consistente sustenta a especialidade |
| **Depende de complementação** | há indício, faltam provas ou esclarecimentos |
| **Controvertido** | inconsistência relevante ou obstáculo ao reconhecimento |

E responda às três perguntas finais do roteiro: houve exposição? a documentação
basta? quais períodos têm potencial e quais exigem complementação ou discussão?

### 7. Validação da previsão de cálculo

Procedimento em `$SKILL/references/validacao-calculo.md`. Leia os PDFs do Previus,
identifique em cada cenário quais períodos desta empresa foram computados como
especiais e confronte com a conclusão do passo 6. Cada cenário sai como **mantido**,
**em risco** ou **recalcular**, dizendo exatamente o que mudar no Previus.

Sem PDF do Previus na pasta: diga isso, não invente números, e registre a
providência.

### 8. Segunda parada — dúvidas e decisões

Reúna **todas** as dúvidas num bloco só e pergunte de uma vez. Obrigatórias:

1. **Retificação** — se a análise apontou erro ou lacuna que a empresa pode corrigir,
   mostre a lista do que pedir e pergunte se gera a minuta.
2. **Ficha da análise inicial** — mostre o bloco `PPP` e a `Conclusão` como estão e
   como ficariam, e pergunte se atualiza. Se a ficha não foi gerada por
   `gerar-docx.ps1` (formatação que a marcação não representa: cores, recuos,
   imagens), avise que regravar perde essa formatação e ofereça entregar só o texto
   novo para colar à mão.
3. Tudo que ficou **controvertido**.

### 9. Gravação

Gere os arquivos (seção **Saída**).

### 10. Resumo para o sistema interno

Por último, escreva **na própria conversa** — não em arquivo — o resumo da análise e
dos próximos passos, pronto para copiar e colar no sistema interno do escritório.
Entregue dentro de um bloco de código (` ``` `), para que a cópia saia limpa.

Texto corrido e listas simples; **sem tabela, sem markdown, sem negrito** — o
sistema interno recebe texto puro. Linguagem por extenso, sem siglas do CNIS.

```
ANÁLISE DE PPP — <RAZÃO SOCIAL> — <DD/MM/AAAA>
Cliente: <NOME>

PPP analisado: emitido em <data>, período de <início> a <fim>, cargo <cargo>.
Situação do PPP: <regular | com N itens a corrigir — quais, em uma linha>.
Outros PPPs da mesma empresa: <não há | PPP de <data>: usar / usar em conjunto / desconsiderar, e por quê>.
Correções em relação ao anterior: <N de M corrigidas; o que persiste; o que piorou>.
Tempo especial: <período> — <forte | depende de complementação | controvertido>, porque <motivo em uma linha>.
Cálculo do Previus: <cenário: mantido | em risco | recalcular — o que mudar>.

Próximos passos:
1. <providência> — <documento ou destinatário>.
2. ...

Documentos gerados: <nomes dos arquivos gravados na pasta do cliente>.
```

Cada próximo passo é uma ação executável por alguém da equipe ("enviar a minuta de
retificação à empresa", "pedir ao cliente a FISPQ do óleo usado", "recalcular o
cenário de aposentadoria especial no Previus sem o período 2016–2020"), não uma
observação. Nada que esteja **controvertido** aparece como certo.

## Saída

Monte cada documento como `.txt` UTF-8 na marcação de `gerar-docx.ps1` e converta:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/gerar-docx.ps1" -Origem "<entrada.txt>" -Destino "<saida.docx>"
```

| Documento | Destino | Formato |
|---|---|---|
| **Análise do PPP** — sempre | `<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE DE PPP - <EMPRESA> - <DD.MM.AAAA>.docx` | `$SKILL/references/formato-analise.md` |
| **Minuta de pedido de retificação** — se aprovada na parada | `<pasta do cliente>/ANÁLISE INICIAL/PEDIDO DE RETIFICAÇÃO DE PPP - <EMPRESA> - <DD.MM.AAAA>.docx` e `.pdf` | `$SKILL/references/retificacao.md` — **no papel timbrado**, com `aplicar-timbrado.ps1`, não com `gerar-docx.ps1`; assinada por Cristhiane Constantino Barreto (OAB/SC 20.738) e Larissa Marghoti dos Santos (OAB/SC 63.521) |
| **Ficha da análise inicial** — se aprovada na parada | os dois lugares onde ela já está: `<pasta do cliente>/ANÁLISE INICIAL/<NOME>.docx` e `H:/Drives compartilhados/CBA/EQUIPE/LARISSA - JURIDICO/2 - ANÁLISES INICIAIS/<NOME>.docx` | `../analise-inicial/references/formato-ficha.md` |

`<EMPRESA>` é o nome curto da empresa em maiúsculas, sem barra nem caractere que o
Windows recuse em nome de arquivo. `<DD.MM.AAAA>` é a data da análise — a pasta vai
acumular uma análise por PPP recebido, e a data é o que as distingue.

Se a subpasta `ANÁLISE INICIAL` não existir, crie-a com esse nome exato, acentuado.

**Nunca sobrescreva** ficha, análise anterior ou pedido anterior sem antes mostrar o
que muda. Na ficha, altere **só** o bloco `PPP`, a `Conclusão` e, se o cálculo mudar,
uma nota em `Expectativa futura` (`*Recalcular no Previus: <motivo>`); o resto fica
exatamente como estava. Os números da `Expectativa futura` **não** se alteram à mão:
só mudam quando houver novo cálculo do Previus.

## Regras que não se negociam

**Agente nocivo no PPP não é tempo especial.** A conclusão vem do conjunto, nunca do
nome do agente. Ver `$BASE/references/ppp.md`.

**Produto químico não é agente químico.** Entendimento do escritório: o agente só é
aceito se o PPP o traz **exatamente como está na NR-15 ou na LINACH** (mesmo produto,
mesma atividade ou qualificação) **ou** se traz o **composto**. Fora disso, não
sustenta grau **forte** — semelhança com a norma não basta. Ver
`$BASE/references/agentes-quimicos.md`.

**Nunca afirme uma regra legal de memória.** Limite de ruído por época, metodologia
exigida por período, efeito do EPI, agentes cancerígenos, conversão de tempo especial,
fundamento do pedido de retificação — tudo se consulta em
`$BASE/references/legislacao.md` e no acervo do escritório, citando o dispositivo.
Sem ter lido o texto, escreva que depende de conferência legal.

**Nunca declare lido o que não foi lido.** `ler-pdf.sh` sai com código 4 e imprime
`!!! RENDERIZACAO INCOMPLETA` quando renderiza menos páginas do que o PDF tem. Leitura
parcial de um dos PPPs invalida a comparação daquele campo: registre e não compare.

**Não descarte PPP sem dizer por quê.** "Desconsiderar" sempre vem com o motivo e com
a confirmação de que nada favorável do descartado se perde.

**Toda conclusão sai etiquetada** com o grau. O que for **controvertido** vira
pergunta, não afirmação.

**Toda análise termina com o balanço de cobertura**, na própria análise do PPP: cada
arquivo lido, páginas, quanto foi lido e a situação.

**Dados do cliente nunca entram neste repositório.** Os documentos gerados vão só
para a pasta do cliente no Drive.

## Ambiente

Ferramentas, caminhos e limitações da máquina em `$BASE/references/ambiente.md`.
