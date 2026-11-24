# Formato do controle

Documento interno da equipe, **um por cliente**, regravado a cada rodada:
`<pasta do cliente>/ANÁLISE INICIAL/PROVA RURAL - <NOME>.docx`

O arquivo é ao mesmo tempo **relatório** (para a equipe ler) e **memória da skill**
(para a próxima rodada saber o que já foi feito). Por isso a estrutura é fixa e o
inventário segue colunas exatas: a próxima rodada lê o arquivo com `ler-docx.ps1` e
reconstrói o estado a partir das linhas `|a|b|c|`.

Linguagem **por extenso**, sem siglas do CNIS. A primeira seção é a situação atual,
porque é a única que muita gente vai ler.

Marcação de entrada a mesma de `gerar-docx.ps1`: `# Título` em negrito, `**trecho**`,
linhas `|a|b|` viram tabela, linha vazia vira parágrafo vazio. Não use `|` dentro do
texto de uma célula.

Na leitura de volta com `ler-docx.ps1`, uma linha inteira em `**negrito**` volta como
`# ` e aparece um parágrafo vazio depois de cada tabela. O conteúdo das tabelas volta
intacto. Ao remontar o texto, normalize: título de ficha em `**...**`, sem linhas
vazias duplicadas.

## Estrutura

```
NOME COMPLETO DO CLIENTE
PROVA RURAL — CONTROLE DE DOCUMENTOS
Última atualização: DD/MM/AAAA — rodada N
Atividade: <agricultura / pesca artesanal / ambas, com os períodos>
Período controvertido: DD/MM/AAAA a DD/MM/AAAA

# 1. Situação atual
# 2. Período controvertido
# 3. Linha do tempo rural
# 4. Enquadramento como segurado especial
# 5. Mapa de cobertura
# 6. Inventário de documentos
# 7. Fichas dos documentos
# 8. Pontos de atenção
# 9. Efeito no cálculo do Previus
# 10. O que falta pedir
# 11. Histórico de atualizações
# 12. Autodeclaração
# 13. Balanço de cobertura
```

Nenhuma seção se omite. Seção sem conteúdo sai com uma linha dizendo por quê.

## 1. Situação atual

No máximo seis linhas, nesta ordem:

```
- 1976 a 1985 (infância e adolescência): depende de mais documentos — nota de produtor do pai de 1980 basta se houver testemunhas; testemunhas não conversadas.
- 1986 a 2004 (vida adulta): forte — 4 documentos (1986, 1991, 1997, 2004), início e fim marcados; certidão de casamento com o cônjuge lavrador.
- 2005 a 2012 (vida adulta): fraco — nenhum documento; vínculo urbano do cônjuge em 2007.
- Nesta rodada: chegaram D07 e D08; 1986–2004 subiu de depende para forte (D08 marca o fim).
- Cálculo: cenário comum em risco (1976–1985); cenário híbrido não sustentado (2005–2012).
- Próximo passo: conversar com o cliente sobre testemunhas de 1976–1985.
```

## 2. Período controvertido

O bloco de `periodo-controvertido.md`, seção 3: período adotado, fonte de cada data,
o que o Previus computa por cenário, o que o INSS reconheceu e não reconheceu, e o
motivo literal do indeferimento.

## 3. Linha do tempo rural

Os itens de `rural.md` (início e término, localidade e imóvel, proprietário ou
possuidor, forma de exploração, cultura ou criação, composição do grupo familiar,
participação do cliente, períodos urbanos concomitantes, mudanças), cada um com o
documento que o sustenta (`D03`) ou `sem documento`. Inclua também afastamentos da
atividade rural e períodos já reconhecidos administrativa ou judicialmente.

**Período na infância** (roteiro, seção 8): para cada trecho em que o cliente era
criança ou adolescente, registre idade, onde residia, com quem, atividade da família,
participação do cliente, documentos da atividade familiar, documentos que vinculam o
cliente ao grupo, períodos urbanos, provas contemporâneas e **pontos que dependem de
prova testemunhal** ou documental complementar.

**Pesca artesanal:** acrescente local da pesca (mar, rio, estuário, lagoa, açude,
represa), espécie pescada, destino (subsistência ou venda), embarcação usada, sua
arqueação bruta e quem é o titular dela, RGP e seguros-defeso recebidos.

**Estado civil em cada fase** — o casamento ou a união estável tira o cliente do
grupo familiar dos pais e forma o grupo próprio (IN 128, art. 109, § 1º).

## 4. Enquadramento como segurado especial

Uma linha por trecho, com o resultado do passo 7 do `SKILL.md`. Cada célula que
afirma regra legal traz o dispositivo, conferido em `segurado-especial.md`.

|Trecho|Atividade e condição|Forma|Grupo familiar|Requisitos da categoria|Causas de descaracterização|Conclusão|
|---|---|---|---|---|---|---|
|03/1976 a 12/1985|agricultura; pais proprietários|economia familiar|pai, mãe, cliente e irmãos solteiros|área anterior a 23/06/2008, limite de módulos não se aplica (IN 128, art. 110, § 8º)|nenhuma no CNIS|segurado especial em economia familiar|
|01/1986 a 12/2004|pesca artesanal em rio, sem embarcação|economia familiar|cliente e cônjuge, a partir do casamento em 1986|profissão habitual (D05, colônia); RGP não exigido antes de 31/03/2015 (IN 128, art. 111, § 1º)|vínculo urbano do cônjuge em 1995, 60 dias — não excede 120 dias no ano (IN 128, art. 112, IX, "d")|segurado especial em economia familiar|
|01/2005 a 12/2012|agricultura; arrendatário|economia familiar|cliente e cônjuge|área do imóvel desconhecida — falta CCIR para conferir 4 módulos fiscais a partir de 23/06/2008|—|enquadramento depende de complementação|

Abaixo da tabela, em bullets:

- cada causa de descaracterização encontrada: de quem é, período, dispositivo e se
  atinge só aquele membro ou o grupo (IN 128, art. 113, parágrafo único);
- dados que faltam para fechar o enquadramento e o documento que os traria;
- se a estratégia for **administrativa**, se a prova cumpre a exigência mínima do
  Ofício 46, item 6.1, para o benefício pretendido.

## 5. Mapa de cobertura

**Uma linha por trecho, não por ano.** Não se exige documento ano a ano; o trecho se
mede pelo critério do escritório de `graduacao.md`, seção 2, que muda conforme a
fase da vida.

|Trecho|Fase|Idade|Documentos contemporâneos|Início e fim marcados|Testemunhas|Contra|Grau|O que falta|
|---|---|---|---|---|---|---|---|---|
|03/1976 a 12/1985|infância e adolescência|12 a 21|D07 (nota de produtor do pai, 1980)|não se aplica|não conversado|—|depende de mais documentos|conversar com o cliente sobre testemunhas — com elas, o trecho fica forte|
|01/1986 a 12/2004|vida adulta|22 a 40|D03 (1986), D05 (1991), D06 (1997), D08 (2004) — em nome do cliente e do cônjuge|sim|não conversado|—|forte|—|
|01/2005 a 12/2012|vida adulta|41 a 48|nenhum|não|não conversado|vínculo urbano do cônjuge, CNIS, 2007|fraco|documentos de 2005 a 2012, principalmente perto do início e do fim; explicação do vínculo de 2007|

- **Testemunhas** — `não conversado`, `confirmadas (<quantas>)` ou `não há`. Só se
  preenche com o que a equipe informou; nunca presuma.
- **Início e fim marcados** — só na vida adulta: há documento perto do começo e perto
  do fim do trecho?
- O grau respeita o **teto do enquadramento** da seção 4: trecho que não se enquadra
  é **fraco**; trecho com enquadramento dependente de complementação não passa de
  **depende de mais documentos**.

Abaixo da tabela, a **conclusão por trecho** na cadeia do roteiro do escritório
(seção 9):

```
03/1976 a 12/1985 → economia familiar, lavoura de feijão e milho → titular: pai →
D07 (nota fiscal de produtor, 1980, contemporânea) → nenhuma inconsistência →
testemunhas a conversar com o cliente → depende de mais documentos (suficiente para
seguir com o processo se houver testemunhas)
```

## 6. Inventário de documentos

**Colunas fixas, nesta ordem** — é o que a próxima rodada lê:

|ID|Documento|Data do documento|Titular|Relação com o cliente|Anos que cobre|Grau|Contrário|Arquivo|Páginas|Tamanho|Modificado em|Situação|
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|D01|Certidão de casamento dos pais|12/05/1974|pai e mãe|filho|1974|forte|não|DOCUMENTOS/certidao casamento pais.pdf|1|482113|2026-09-02 10:14|analisado na rodada 1|
|D07|Nota fiscal de produtor|1980|pai|filho (ligado por D02)|1980|forte|não|DOCS RURAIS/digitalizar0004.pdf|2|1203998|2026-11-20 16:40|novo na rodada 3|

- **ID** — `D01`, `D02`… na ordem em que entraram. **Nunca se renumera**; documento
  que sai da pasta mantém o ID.
- **Arquivo** — caminho relativo à pasta do cliente. Documento que é parte de um
  arquivo maior leva as páginas: `PROCESSO ADMINISTRATIVO/NB 123.pdf, p. 14-15`.
  Vários documentos podem apontar para o mesmo arquivo.
- **Tamanho** em bytes e **Modificado em** como a varredura imprime — é por eles que
  a próxima rodada detecta alteração.
- **Situação** — `analisado na rodada N`, `novo na rodada N`, `reanalisado na rodada
  N (arquivo alterado)`, `não localizado na pasta em DD/MM/AAAA`.

Não transcreva CPF, NIT, RG ou número de benefício em nenhuma coluna.

## 7. Fichas dos documentos

Uma ficha por documento, na ordem dos IDs, estendendo o registro de `rural.md`:

```
**D07 — Nota fiscal de produtor**
Arquivo: DOCS RURAIS/digitalizar0004.pdf (2 páginas, lidas 2)
Data: 14/03/1980 — contemporâneo
Período rural alegado: 1976–1989
Titular: João da Silva, pai do cliente
Relação com o cliente: filho; ligação demonstrada por D02 (certidão de nascimento)
Qualificação / atividade: produtor rural; venda de 40 sacas de feijão
Localidade / imóvel: Linha São Pedro, interior de <município>
Trecho que sustenta: "produtor rural ... Linha São Pedro" (página 1)
Anos que cobre: 1980 diretamente
Relevância: documento contemporâneo que demonstra a exploração rural pelo grupo familiar
Grau: forte — contemporâneo, fiscal, qualificação expressa, titular ligado ao cliente
Contrário: não
Histórico do grau: rodada 3 — forte
```

Em atualização, as fichas já existentes se copiam **sem alteração**, salvo quando o
grau muda — nesse caso acrescente a linha ao `Histórico do grau`
(`rodada 4 — depende → forte: chegou D09, que liga o titular ao cliente`).

## 8. Pontos de atenção

Bullets: documentos **contrário**, vínculos urbanos concomitantes, divergência de
nome, data ou localidade entre documentos, divergência entre Previus e
indeferimento, idade no início do período, documento lido em parte. Cada um com o
ID e a providência.

## 9. Efeito no cálculo do Previus

Conforme `periodo-controvertido.md`, seção 4: o que foi extraído de cada PDF e a
tabela por cenário.

## 10. O que falta pedir

|Trecho|Grau atual|Documento a buscar|Com quem|Por quê|
|---|---|---|---|---|

Ordem: **fraco** primeiro, depois **depende de mais documentos**; dentro de cada
grau, os trechos que o melhor cenário do Previus usa vêm antes. Inclua
`Recalcular no Previus` e `Conferir no acervo` quando couber.

## 11. Histórico de atualizações

Cumulativo. **Nunca se apaga linha.** A linha desta rodada entra no fim:

|Rodada|Data|Documentos novos ou alterados|Mudanças de grau|Observação|
|---|---|---|---|---|
|1|02/09/2026|D01 a D06|—|primeira análise|
|3|24/11/2026|D07, D08|1979–1981: depende → forte|D08 é contrário (vínculo urbano do pai em 1987)|

## 12. Autodeclaração

Conforme `autodeclaracao.md`, seção 6. Primeiro, uma linha sobre os documentos
mínimos para o requerimento:

```
Documentos mínimos para o requerimento: cumpridos para aposentadoria por idade rural — D07 (1980) e D08 (2004), um por metade da carência; enquadramento sem impedimento.
```

ou `não cumpridos — <condição que falhou, trecho>`.

Depois, uma entrada por autodeclaração emitida (cumulativo, nunca se apaga):

```
**Autodeclaração rural — emitida em 24/11/2026 (rodada 3)**
Formulário: Anexo I do Ofício-Circular 46/DIRBEN (acervo)
Arquivo: ANÁLISE INICIAL/AUTODECLARAÇÃO RURAL - <NOME>.pdf
Documentos mínimos: cumpridos
Fonte de cada campo preenchido:
- Nome, nascimento, CPF, RG: RG (D02).
- Período 1, 12/03/1976 a 31/12/1985, economia familiar, condição "proprietário" (dos pais): mapa, trecho 1; D01, D07.
Pendências enviadas ao cliente (9): apelido; dia e mês do início do período 1; área explorada; empregados; outras rendas; cooperativa; IPI; local e data; assinatura.
Situação: aguardando devolução do cliente
```

Quando a autodeclaração voltar assinada, a situação passa a `devolvida em
DD/MM/AAAA — conferida na rodada N`, com as divergências entre o que o cliente
escreveu e os documentos.

Sem autodeclaração emitida: `Não emitida.` e o motivo (documentos mínimos não
cumpridos, ou a equipe decidiu não emitir).

## 13. Balanço de cobertura

Da rodada atual:

|Arquivo|Páginas|Lidas|Situação|
|---|---|---|---|
|DOCS RURAIS/digitalizar0004.pdf|2|2|integral|
|PROCESSO ADMINISTRATIVO/NB 123.pdf|86|12|parcial — só documentos rurais (p. 10-18) e decisão (p. 80-82), por decisão na primeira parada|

E uma linha final com o acumulado: `Documentos já analisados em rodadas anteriores e
não relidos nesta: D01 a D06.`
