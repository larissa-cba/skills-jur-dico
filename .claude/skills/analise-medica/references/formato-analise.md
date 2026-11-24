# Formato da análise

Documento interno da equipe, **um por cliente**, regravado a cada rodada:
`<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE MÉDICA - <NOME>.docx`

É ao mesmo tempo **relatório** (para a equipe ler) e **memória da skill** (para a
próxima rodada saber o que já foi lido). Por isso a estrutura é fixa e o inventário
tem colunas exatas: a próxima rodada lê o arquivo com `ler-docx.ps1` e reconstrói o
estado a partir das linhas `|a|b|c|`.

Marcação de `gerar-docx.ps1`: `# Título` em negrito, `**trecho**`, linhas `|a|b|`
viram tabela, linha vazia vira parágrafo vazio. Não use `|` dentro de célula. Na
leitura de volta, linha inteira em negrito volta como `# ` e aparece parágrafo vazio
depois de cada tabela — normalize ao remontar.

Linguagem por extenso. Siglas só as de uso corrente na equipe (CID, DII, INSS, BPC,
PcD, CAT). Não transcreva CPF, NIT, RG, número de benefício nem valor de honorários.

## Estrutura

```
NOME COMPLETO DO CLIENTE
ANÁLISE MÉDICA
Última atualização: DD/MM/AAAA — rodada N
Benefício: <benefício testado> — contrato: <tipo no Advbox>
Fase: <etapa> — <fase> — perícia: <situação>

# 1. Conclusão
# 2. Contrato, fase e perícia
# 3. Resumo de cada documento
# 4. Análise do conjunto
# 5. Divergências e pontos de atenção
# 6. Efeito no cálculo do Previus
# 7. Documentos a pedir
# 8. Inventário de documentos
# 9. Histórico de atualizações
# 10. Balanço de cobertura
```

Nenhuma seção se omite. Seção sem conteúdo sai com uma linha dizendo por quê
(`Não se aplica: benefício por incapacidade, sem cálculo do Previus.`).

## 1. Conclusão

Primeiro, porque é o que todos vão ler. A síntese encadeada do roteiro (seção 7) e
as duas respostas da skill:

```
Diagnóstico → evolução → limitações funcionais → período → documentação → divergências → repercussão previdenciária:
<um parágrafo seguindo essa cadeia, sem reproduzir laudo>

Conjunto: suficiente | suficiente com ressalvas | insuficiente — <motivo em uma linha>.
Recomendação: dar sequência | juntar | juntar só se muito forte | não juntar — <motivo em uma linha, ligado à fase>.
Pedir novos documentos: sim — <quais, em uma linha> | não é necessário — <por quê>.
Nesta rodada: <o que chegou e o que mudou | primeira rodada>.
```

## 2. Contrato, fase e perícia

```
Contrato no Advbox: <tipo> (processo <id do Advbox>, responsável <nome>)
Contrato na pasta: <objeto em uma linha | não localizado na pasta>
Confere: sim | não — <divergência>
Etapa e fase: <etapa> — <fase>, consultado em DD/MM/AAAA
Número do processo: <número judicial ou protocolo administrativo | não há>
Últimas movimentações relevantes: <data — movimentação, até cinco>
Perícia: não houve | agendada em DD/MM/AAAA (<adm. | jud.>, faltam N dias) | realizada, laudo pendente | laudo disponível — <M0x>
Assistente técnico (Nomos): sim | não
Pergunta desta rodada: basta para dar sequência? | vale juntar ao processo em curso?
```

## 3. Resumo de cada documento

Uma ficha por documento, **do mais recente ao mais antigo** (padrão das fichas do
escritório), cada uma com o identificador estável:

```
**M04 — Relatório médico — 15/03/2026**
Arquivo: DOCUMENTOS MEDICOS/digitalizar0007.pdf (2 páginas, lidas 2)
Profissional: ortopedista, CRM legível
Resumo: relata fratura do tornozelo esquerdo em 02/02/2026, tratada com cirurgia; mantém limitação de mobilidade e dor ao apoio; recomenda afastamento por 60 dias com reavaliação. CID S82.6 (p. 1).
Papel na prova: afirma — com achados do exame físico descritos.
Ponto que prova: limitação funcional e período de afastamento de 15/03 a 14/05/2026.
Grau: forte — especialista, achados objetivos, contemporâneo, prazo definido.
Contrário: não
Histórico do grau: rodada 1 — forte
```

O **resumo** é o do roteiro: o que outra pessoa precisa para entender a relevância
sem reabrir o arquivo — tipo, data, quadro, conclusão, afastamento, CID e a
**página** do achado. Reproduzir o laudo não é resumo.

Perícia do INSS ou judicial: o resumo diz a conclusão, a DII e a DID fixadas, o que
o perito considerou e o que ignorou.

Em atualização, as fichas já existentes se copiam **sem alteração**, salvo mudança de
grau — acrescente a linha ao `Histórico do grau` com o motivo.

## 4. Análise do conjunto

Conforme a seção do benefício em `beneficios.md`.

**Incapacidade e BPC** — tabela dos pontos que o benefício exige:

|Ponto|Afirmado por|Comprovado por (exame)|Tratamento|Histórico (prontuário)|Situação|
|---|---|---|---|---|---|
|condição clínica|M04, M02|M03 (tomografia)|M05|—|comprovado|
|limitação para a atividade habitual (pedreiro: carregar peso, agachar)|M04|—|M06 (fisioterapia)|—|depende de mais documentos|
|DII em 02/02/2026|M01 (atendimento de urgência)|M03|—|M01|comprovado|

**Auxílio-acidente** — as cinco perguntas (acidente, lesões, nexo, natureza,
consolidação e sequela), cada uma `comprova / depende de mais documentos / não
comprova`, com os documentos.

**Aposentadoria PcD**:

- linha do tempo da condição, do mais antigo ao mais recente, com o identificador;
- documento mais antigo × data de início do Previus;
- buracos na manutenção;
- grau do Previus: sustentado / não sustentado / não permite avaliar;
- como a condição limita a pessoa no dia a dia, em linguagem concreta.

Depois, em uma linha cada: **conjunto** e **recomendação** (as mesmas da seção 1),
com o motivo detalhado — na recomendação **juntar só se muito forte**, os quatro
critérios de `contrato-e-fase.md`, seção 5, um a um.

## 5. Divergências e pontos de atenção

As divergências no formato do roteiro, com o ponto a esclarecer:

```
M04 (relatório do ortopedista, 15/03/2026): recomenda afastamento por 60 dias.
M07 (perícia do INSS, 28/03/2026): conclui pela capacidade laboral.
A esclarecer: o perito não teve acesso à tomografia M03; juntar antes do recurso ou levar à perícia judicial.
```

E em bullets: documentos **contrário**, divergência entre contrato e Advbox,
documento lido em parte, documento de terceiro, manuscrito ilegível.

## 6. Efeito no cálculo do Previus

Só aposentadoria PcD. O que foi extraído de cada PDF e:

|Cenário|Início da deficiência assumido|Grau assumido|Documento mais antigo|Resultado|
|---|---|---|---|---|
|PcD por idade|03/2000|leve|M09, prontuário de 06/2003|em risco — 2000 a 2003 sem documento|

Sem Previus: `Não há cálculo do Previus na pasta; premissas não testadas.` e a
providência na seção 7.

## 7. Documentos a pedir

|Documento|Período|Com quem|Para provar|Urgência|
|---|---|---|---|---|
|laudo da tomografia de 02/2026|02/2026|clínica de imagem / cliente|que a fratura está comprovada por exame|antes da perícia de 10/12/2026|

Ordem: o que destrava a conclusão primeiro; o que tem prazo (perícia) primeiro dentro
disso. Sem pedidos: `Não é necessário pedir novos documentos: <motivo>.`

## 8. Inventário de documentos

**Colunas fixas, nesta ordem:**

|ID|Documento|Data do documento|Papel|Grau|Contrário|Arquivo|Páginas|Tamanho|Modificado em|Situação|
|---|---|---|---|---|---|---|---|---|---|---|
|M01|Ficha de atendimento de urgência|02/02/2026|registra o histórico|forte|não|DOCUMENTOS MEDICOS/WhatsApp Image 2026-02-03.jpeg|1|184223|2026-11-20 16:40|analisado na rodada 1|

- **ID** — `M01`, `M02`… na ordem de entrada. **Nunca se renumera.**
- **Arquivo** — caminho relativo à pasta do cliente; parte de arquivo maior leva as
  páginas (`PROCESSO JUDICIAL/autos.pdf, p. 40-47`).
- **Tamanho** em bytes e **Modificado em** como a varredura imprime.
- **Situação** — `analisado na rodada N`, `novo na rodada N`, `reanalisado na rodada
  N (arquivo alterado)`, `não localizado na pasta em DD/MM/AAAA`.

## 9. Histórico de atualizações

Cumulativo; nunca se apaga linha:

|Rodada|Data|Fase no Advbox|Documentos novos ou alterados|Conclusão|Recomendação|
|---|---|---|---|---|---|
|1|24/11/2026|CONSULTORIA — para protocolo|M01 a M06|suficiente com ressalvas|dar sequência|

## 10. Balanço de cobertura

|Arquivo|Páginas|Lidas|Situação|
|---|---|---|---|
|DOCUMENTOS MEDICOS/prontuario.pdf|38|38|integral|

E a linha final: `Já analisados em rodadas anteriores e não relidos nesta: M01 a M06.`

## Resumo para o sistema interno

Na conversa, dentro de bloco de código, texto puro — sem tabela, markdown ou
negrito:

```
ANÁLISE MÉDICA — DD/MM/AAAA (rodada N)
Cliente: <NOME>
Contrato: <tipo no Advbox>.
Fase: <etapa — fase>. Perícia: <situação e data>.

Documentos analisados nesta rodada:
- <tipo, data>: <resumo em uma linha> — <papel> — <grau>.
- ...

Conclusão: <cadeia diagnóstico → evolução → limitação → período → documentação → divergências → repercussão, em duas a quatro linhas>.
Conjunto: <suficiente | suficiente com ressalvas | insuficiente> — <motivo>.
Recomendação: <dar sequência | juntar | juntar só se muito forte | não juntar> — <motivo ligado à fase>.
<Aposentadoria PcD: Previus — início da deficiência <sustentado | em risco | não sustentado>; grau <sustentado | não sustentado | não permite avaliar>.>
Divergências: <documento × perícia, em uma linha cada | nenhuma>.

Pedir ao cliente:
1. <documento> — <período> — <para provar o quê> — <prazo, se houver perícia>.
2. ...
<ou: Não é necessário pedir novos documentos — <motivo>.>

Arquivo gravado: ANÁLISE MÉDICA - <NOME>.docx
```

Cada pedido é ação executável por alguém da equipe ("pedir ao cliente o laudo da
ressonância de 2019 do joelho direito, para comprovar a lesão afirmada no relatório
de 03/2026"), não observação.
