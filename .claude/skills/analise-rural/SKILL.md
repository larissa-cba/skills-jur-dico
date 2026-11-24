---
name: analise-rural
description: Controle vivo da prova do tempo de segurado especial do cliente — atividade rural ou pesca artesanal. Verifica se a atividade se enquadra como segurado especial, individualmente ou em regime de economia familiar, pela Lei 8.213, pela IN 128 e pelo Ofício-Circular 46/DIRBEN; delimita o período controvertido a partir do cálculo do Previus e do indeferimento do INSS; varre a pasta atrás de todo documento que comprove a atividade; gradua cada documento e cada trecho do período (infância e adolescência, vida adulta) como forte, fraco ou depende de mais documentos; e mantém um único arquivo de controle, atualizado a cada rodada, analisando só o que chegou de novo.
disable-model-invocation: true
---

# Análise rural e pesqueira — controle da prova

Acompanha a **prova do tempo de segurado especial sem registro** de um cliente ao
longo do processo — **agricultor** ou **pescador artesanal**, individualmente ou em
**regime de economia familiar**. Os documentos chegam aos poucos — certidão de um
cartório, nota de produtor achada pela família, ficha da colônia de pescadores,
histórico escolar — e cada chegada muda o quadro. Esta skill responde, a cada
rodada:

1. A atividade do cliente **se enquadra como segurado especial**? Individualmente ou
   em economia familiar? Há algo que descaracterize?
2. Qual é o período controvertido que precisamos provar?
3. Quais documentos da pasta servem para isso, e quanto vale cada um?
4. Cada trecho do período — infância e adolescência, vida adulta — está sustentado
   pelo critério do escritório? O que falta, inclusive testemunhas?
5. O que chegou desde a última rodada, e o que mudou por causa disso?
6. O que ainda falta pedir ao cliente, e para cobrir qual trecho?

O resultado fica num **arquivo vivo**, um só por cliente, regravado a cada rodada:
`<pasta do cliente>/ANÁLISE INICIAL/PROVA RURAL - <NOME>.docx`. O nome do arquivo é o
mesmo para pesca artesanal.

**Quando já há documentos mínimos para o requerimento**, oferece emitir a
**autodeclaração de segurado especial** (rural ou pescador) preenchida com os dados
da pasta, mais a lista do que o cliente precisa completar.

**Não faz:** análise inicial completa (`/analise-inicial`), recálculo no Previus
(exige login), petição, rol de testemunhas, assinatura ou protocolo da
autodeclaração.
**Não altera a ficha da análise inicial** — por decisão do escritório, a ficha fica
como está; o controle é um documento separado.

**Vínculo rural assinado na CTPS não é objeto desta skill.** Ele já conta; o que se
discute é enquadramento como especial, que é PPP/categoria profissional. Ver a
primeira seção de `$BASE/references/rural.md`. Se todo o tempo rural do caso estiver
registrado, diga isso e pare. O mesmo vale para o pescador **empregado** de
embarcação (vínculo registrado): não é segurado especial.

## Invocação

```
/analise-rural <caminho da pasta do cliente>
/analise-rural <caminho da pasta do cliente> --refazer
```

- **Sem flag** — se o arquivo de controle existe, é uma **atualização**: só os
  documentos novos ou alterados são lidos; o enquadramento e o mapa de cobertura são
  sempre refeitos inteiros. Se não existe, é a **primeira rodada**.
- **`--refazer`** — relê e regradua todos os documentos, inclusive os já analisados.
  Use quando o período controvertido mudou ou quando a graduação anterior está em
  dúvida. O histórico de atualizações é preservado mesmo assim.

Se a pasta não foi informada, peça-a antes de qualquer outra coisa. Não tente
adivinhar o cliente a partir do nome mencionado na conversa.

## Material compartilhado

Scripts e doutrina de leitura ficam em `../previdenciario-base/`. **Duas referências
da base devem ser lidas antes de analisar qualquer documento:**

| Referência da base | Cobre |
|---|---|
| `$BASE/references/rural.md` | o **roteiro de análise de documentos rurais do escritório**: linha do tempo, documentos do cliente, dos pais, escolares, certidões, contemporaneidade, confronto com o CNIS, infância, e o critério de quantos documentos bastam |
| `$BASE/references/segurado-especial.md` | o **enquadramento legal**: quem é segurado especial, economia familiar, grupo familiar, pescador artesanal, o que descaracteriza, como o INSS comprova (Ofício-Circular 46/DIRBEN, IN 128, autodeclarações) e as súmulas do acervo |

Aqui ficam só o que é próprio desta skill:

| Referência desta skill | Cobre |
|---|---|
| `$SKILL/references/periodo-controvertido.md` | extrair o período do Previus e do indeferimento, confrontar os dois, efeito no cálculo |
| `$SKILL/references/graduacao.md` | quando um documento e quando um trecho são **forte**, **fraco** ou **depende de mais documentos** |
| `$SKILL/references/formato-controle.md` | estrutura do arquivo vivo, inventário, identificadores estáveis, histórico |
| `$SKILL/references/autodeclaracao.md` | quando há documentos mínimos para o requerimento, e como preencher a autodeclaração para o cliente |

> **Todo caminho neste arquivo é relativo à pasta desta skill**, informada como
> "Base directory for this skill" quando a skill carrega — **não** ao diretório de
> trabalho da sessão. Antes do primeiro comando:
>
> ```bash
> SKILL="<base directory desta skill>"
> BASE="$SKILL/../previdenciario-base"
> ```

## Fluxo

### 1. Controle existente

Procure `<pasta do cliente>/ANÁLISE INICIAL/PROVA RURAL - *.docx`. Se existir, leia:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/ler-docx.ps1" -Origem "<PROVA RURAL - NOME.docx>" -Destino "<pasta de trabalho>/controle-anterior.txt"
```

Dele saem, para esta rodada: a atividade (rural, pesca ou ambas), o período
controvertido adotado, o enquadramento anterior, o **inventário** dos documentos já
analisados (identificador, arquivo, tamanho, data de modificação, grau), o mapa de
cobertura anterior, o que se sabe das testemunhas e o histórico. Ver
`$SKILL/references/formato-controle.md`.

Se o controle não foi gerado por esta skill (formatação que a marcação não
representa, estrutura diferente), avise que regravar perde essa formatação e
pergunte antes de seguir.

Pasta de trabalho sempre no diretório temporário da sessão, nunca na pasta do
cliente.

### 2. Varredura

```bash
bash "$BASE/scripts/varrer-pasta.sh" "<pasta do cliente>"
find "<pasta do cliente>" -type f -printf '%s\t%TY-%Tm-%Td %TH:%TM\t%P\n'
```

A primeira diz o que é texto e o que é escaneado; a segunda dá tamanho e data de
modificação de cada arquivo — é o que permite saber, na próxima rodada, o que é novo.

Localize **todos** os documentos com potencial de prova, **pelo conteúdo e não pelo
nome**: costumam chegar como `digitalizar0003.pdf`, `WhatsApp Image ...jpeg` ou
embutidos nas páginas de um processo administrativo. O que procurar:

- documentos rurais de `$BASE/references/rural.md` (em nome do cliente, dos pais, do
  cônjuge, escolares, certidões) e a lista do art. 116 da IN 128 em
  `$BASE/references/segurado-especial.md`, seção 6;
- **documentos da pesca** (`segurado-especial.md`, seção 4): RGP, carteira de
  pescador, seguro-defeso, ficha e recibos da colônia ou associação de pescadores,
  notas de entreposto de pescado, registro da embarcação na Capitania, licença de
  pesca;
- **documentos do imóvel** que dizem área e módulos fiscais: CCIR, ITR, matrícula,
  contrato de arrendamento, parceria ou comodato; e DAP ou CAF;
- **autodeclaração** de segurado especial já preenchida — fonte das alegações do
  cliente, não prova material;
- **cálculos do Previus** (`Cálculo de <NOME> (...).pdf`);
- **processo administrativo**: carta de indeferimento, despacho conclusivo,
  pesquisa às bases governamentais, entrevista rural, justificação administrativa;
- **CNIS, CTPS e dados cadastrais** — do cliente e, quando houver, dos integrantes do
  grupo familiar — para vínculos urbanos e outras causas de descaracterização;
- **processos judiciais anteriores** (`PROCESSO JUDICIAL/`) — documentos já juntados e
  períodos já reconhecidos ou negados em juízo;
- **ficha da análise inicial** e documento de trabalho — leitura só, para contexto
  (linha do tempo, grupo familiar). Nunca regravados por esta skill.

Em atualização, compare com o inventário e separe os arquivos em:

| Situação | Critério | O que fazer |
|---|---|---|
| **novo** | caminho não está no inventário | ler e analisar |
| **alterado** | mesmo caminho, tamanho ou data diferentes | reler e reanalisar; diga o que mudou |
| **já analisado** | mesmo caminho, tamanho e data | não reler; usar a ficha do controle |
| **sumiu** | está no inventário, não está na pasta | manter no controle marcado como `não localizado na pasta em DD/MM/AAAA`; nunca apagar a ficha |
| **renomeado provável** | arquivo novo com mesmo tamanho de um que sumiu | confirmar antes de tratar como o mesmo documento |

### 3. Período controvertido e linha do tempo

Procedimento completo em `$SKILL/references/periodo-controvertido.md`. Em resumo:

- dos **PDFs do Previus**, cada período rural ou de pesca computado, por cenário,
  com datas;
- do **indeferimento / processo administrativo**, o período requerido, o que o INSS
  reconheceu, o que não reconheceu e o **motivo**;
- o **período controvertido** é o que o cálculo precisa e que não está reconhecido.
  Mostre de onde veio cada data.

Em atualização, só refaça este passo se chegou cálculo novo do Previus, documento
novo do processo administrativo, ou com `--refazer`. Do contrário, use o período do
controle.

Com o período fixado, monte a **linha do tempo** de `rural.md` — com a idade do
cliente, o **estado civil** em cada fase (casamento muda o grupo familiar) e, na
pesca, o local da pesca e a embarcação. Ela é a moldura de todo o resto.

### 4. Primeira parada — confirmação

Apresente, numa só mensagem, e **pare** com `AskUserQuestion`:

- a atividade — rural, pesca artesanal ou as duas, e em que períodos;
- o período controvertido, com a fonte de cada data, e qualquer divergência entre
  Previus e indeferimento;
- em atualização: os documentos **novos**, **alterados**, **sumidos** e
  **renomeados prováveis**; na primeira rodada: todos os candidatos;
- o que vai ler e **quantas páginas escaneadas** isso custa;
- documentos que você suspeita serem de prova mas não tem certeza.

Custo nunca justifica pular documento: é motivo para perguntar.

### 5. Leitura

```bash
bash "$BASE/scripts/ler-pdf.sh" "<arquivo.pdf>" "<pasta de trabalho>"
```

Imagens (`.jpg`, `.png`) se abrem direto com a ferramenta de leitura de imagem.
Documento rural é quase sempre antigo e escaneado: leia como imagem, com atenção a
datas, **profissão declarada**, nomes, localidade, **área do imóvel** e, na pesca,
**embarcação e arqueação bruta** — e transcreva o trecho que sustenta a conclusão.

**Todo documento de prova é lido por inteiro.** Num processo administrativo longo,
localize e leia por inteiro as páginas dos documentos de prova, da pesquisa às bases
governamentais e da decisão; diga quais páginas ficaram de fora e por quê.

### 6. Ficha de cada documento

Para cada documento novo ou alterado, preencha a ficha de
`$SKILL/references/formato-controle.md` (que estende o registro de `rural.md`) e dê o
**grau do documento** conforme `$SKILL/references/graduacao.md`:

| Grau | Em uma linha |
|---|---|
| **Forte** | sozinho já é início de prova material do trecho que cobre |
| **Depende de mais documentos** | indício real, mas só vale somado a outro (vínculo com o grupo familiar, prova da exploração, data, profissão) |
| **Fraco** | pouco ou nenhum valor como prova material; no máximo reforça o conjunto |

Documento que **prejudica** a tese (profissão urbana declarada no período, endereço
urbano, vínculo urbano, área acima do limite, empregado permanente, embarcação de
porte industrial) recebe também a marca **contrário** — não se esconde, vai para os
pontos de atenção.

Cada documento recebe um identificador estável (`D01`, `D02`…) que **nunca se
renumera** entre rodadas.

### 7. Enquadramento como segurado especial

Refeito **inteiro a cada rodada**. Para cada trecho do período, aplique
`$BASE/references/segurado-especial.md` e responda, citando o dispositivo:

1. **Atividade e condição** — produtor rural (proprietário, possuidor, parceiro,
   meeiro, arrendatário, comodatário…), pescador artesanal (sem embarcação ou com
   embarcação de pequeno porte), assemelhado à pesca, extrativista? Lei 8.213, art.
   11, VII; IN 128, arts. 110 e 111.
2. **Requisitos da categoria** — residência no imóvel ou no mesmo município ou
   município contíguo; **área até 4 módulos fiscais a partir de 23/06/2008**, somando
   todas as propriedades; na pesca, **profissão habitual ou principal meio de vida**
   e RGP a partir de 31/03/2015 (cuja falta não descaracteriza sozinha).
3. **Forma de exercício** — individual ou **regime de economia familiar**. Para
   economia familiar, confira os elementos do conceito (Lei 8.213, art. 11, § 1º;
   IN 128, art. 109, § 1º): trabalho da família indispensável à subsistência e ao
   desenvolvimento do núcleo, mútua dependência e colaboração, **sem empregados
   permanentes**.
4. **Grupo familiar** — quem compõe o grupo em cada fase, pela regra da IN 128, art.
   109, § 1º: o cliente **solteiro** integra o grupo dos pais; ao **casar ou viver em
   união estável, passa a formar o próprio grupo** com o cônjuge. Isso decide de quem
   os documentos podem ser usados em cada trecho. Idade de ingresso no grupo: ver
   seção 3 de `segurado-especial.md` e Súmula 5 da TNU.
5. **Descaracterização** — percorra o checklist da seção 5 de `segurado-especial.md`
   contra o CNIS e os documentos: vínculo urbano acima de 120 dias no ano civil,
   contribuinte individual ou MEI, servidor público, benefício acima do salário
   mínimo, empregados além do limite, arrendador da terra ou da embarcação,
   sociedade empresária. Diga **de quem** é o fato e **se atinge só aquele membro ou
   o grupo inteiro** (IN 128, art. 113, parágrafo único).

Conclusão por trecho, uma de quatro:

| Conclusão | Quando |
|---|---|
| **segurado especial em economia familiar** | atividade, requisitos e grupo familiar demonstrados, sem causa de descaracterização |
| **segurado especial individual** | atividade e requisitos demonstrados, exercida sozinho |
| **enquadramento depende de complementação** | falta dado decisivo — área em módulos fiscais, porte da embarcação, composição do grupo, explicação de um vínculo urbano |
| **não se enquadra** | causa de descaracterização demonstrada, com o dispositivo |

Enquadramento que **não se enquadra** torna o trecho **fraco**, seja qual for a
prova; enquadramento que **depende de complementação** limita o trecho a **depende
de mais documentos**.

Na estratégia **administrativa**, confira também a exigência mínima do INSS por
benefício (Ofício 46, item 6.1 — `segurado-especial.md`, seção 6) e diga se a prova
atual a cumpre.

### 8. Mapa de cobertura

Recalculado **inteiro a cada rodada**, com todos os documentos — novos e antigos.

**Não se exige documento ano a ano.** O período se divide em **trechos** pela fase da
vida — **infância e adolescência** de um lado, **vida adulta** de outro — e, dentro
de cada fase, por mudança real de situação (imóvel, localidade, casamento, atividade
rural para pesca, vínculo urbano no meio). Para cada trecho:

- fase da vida e idade do cliente no início e no fim;
- enquadramento do passo 7;
- documentos contemporâneos que o sustentam, com a data de cada um — na vida adulta,
  quantos são e se marcam o **início** e o **fim**;
- titular de cada documento (cliente, pais, cônjuge) e a relação demonstrada;
- testemunhas: **não conversado**, **confirmadas** ou **não há**;
- vínculo urbano concomitante, mudança de residência, documento contrário;
- **grau do trecho** e o que falta para subir de grau.

Critério do escritório, que decide o grau (detalhado em
`$SKILL/references/graduacao.md` e registrado em `$BASE/references/rural.md`):

- **infância e adolescência** — um documento contemporâneo que demonstre a atividade
  rural ou pesqueira dos pais basta para seguir com o processo, **desde que haja
  testemunhas**, e isso se conversa com o cliente;
- **vida adulta** — o documento pode estar em nome do cônjuge; o ideal é mais de um,
  principalmente marcando início e fim, e quanto mais longo o trecho, mais documentos.

**Testemunhas são assunto com o cliente.** Todo trecho da infância ou adolescência
cujas testemunhas ainda não foram conversadas gera a providência `conversar com o
cliente sobre testemunhas do período <início> a <fim>`. Quando a resposta vier (de
você, numa parada, ou registrada no controle), anote no trecho.

### 9. Efeito no cálculo

Conforme `$SKILL/references/periodo-controvertido.md`, seção 4: para cada cenário do
Previus que computa tempo rural ou de pesca, diga se a premissa está
**sustentada**, **em risco** ou **não sustentada**, com as datas. Não estime tempo
nem RMI.

### 10. Segunda parada — dúvidas e decisões

Reúna **todas** as dúvidas num bloco só e pergunte de uma vez. Obrigatórias:

1. **O que mudou** — em atualização, mostre os trechos que **subiram** ou **desceram**
   de grau ou mudaram de enquadramento desde a rodada anterior, e por causa de qual
   documento. Descida é achado grave: destaque.
2. **Enquadramento** — todo trecho que **não se enquadra** ou cujo enquadramento
   **depende de complementação**, com o motivo e o dispositivo.
3. **Documentos contrários** e vínculos urbanos concomitantes sem explicação.
4. Tudo o que ficou **fraco** num trecho que o melhor cenário do Previus usa.
5. Documento em nome de terceiro cuja relação com o cliente você não conseguiu
   confirmar, ou de pessoa que **não integra o grupo familiar** pela IN 128.
6. **Autodeclaração** — verifique se já há os **documentos mínimos para o
   requerimento**, pela régua de `$SKILL/references/autodeclaracao.md`, seção 1.
   - Se há: diga isso em uma linha, com o benefício e os trechos considerados, e
     pergunte **se deseja emitir a autodeclaração para envio ao cliente** (rural,
     pescador ou as duas, conforme a atividade).
   - Se não há: diga qual condição falhou e para qual trecho, e não ofereça.

### 11. Gravação

Monte o controle inteiro como `.txt` UTF-8 na marcação de `gerar-docx.ps1`, conforme
`$SKILL/references/formato-controle.md`, e converta:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/gerar-docx.ps1" -Origem "<controle.txt>" -Destino "<pasta do cliente>/ANÁLISE INICIAL/PROVA RURAL - <NOME>.docx"
```

Antes de regravar um controle existente:

- copie a versão anterior para a pasta de trabalho temporária (nunca para a pasta do
  cliente);
- confira que **todas** as fichas e **todas** as linhas do histórico da versão
  anterior estão no texto novo — o controle só cresce; nada sai dele sem decisão
  expressa na parada;
- acrescente a linha desta rodada ao **histórico de atualizações**.

`<NOME>` é o nome do cliente em maiúsculas, como na ficha da análise inicial. Se a
subpasta `ANÁLISE INICIAL` não existir, crie-a com esse nome exato, acentuado.

### 12. Autodeclaração — só se aprovada na segunda parada

Procedimento completo em `$SKILL/references/autodeclaracao.md`; mapa dos campos dos
formulários em `$BASE/references/autodeclaracao-campos.md`. Em resumo:

1. Copie o formulário do acervo (rural, pescador ou os dois) para a pasta de trabalho.
2. Monte o JSON só com o que os documentos da pasta dizem — **na dúvida, em
   branco**; sim/não sobre fatos que só o cliente conhece fica em branco; local,
   data, assinatura e polegar sempre em branco.
3. Preencha com `preencher-pdf-form.ps1`, renderize e **confira página por página**.
4. Grave na pasta do cliente o PDF preenchido e a **lista de pendências** em
   linguagem para o cliente (`.docx`), sem sobrescrever autodeclaração já existente.
5. Registre no controle a seção **Autodeclaração**, com a fonte de cada campo
   preenchido, e regrave o controle (passo 11).

Mostre na conversa, ao final, a lista dos campos que ficaram em branco e por quê.

### 13. Resumo para o sistema interno

Por último, escreva **na própria conversa** — não em arquivo — o resumo da rodada e
dos próximos passos, pronto para copiar e colar no sistema interno do escritório,
dentro de um bloco de código (` ``` `). Texto puro: **sem tabela, sem markdown, sem
negrito**, sem siglas.

```
PROVA RURAL — ATUALIZAÇÃO DE <DD/MM/AAAA> (rodada <N>)
Cliente: <NOME>

Atividade: <agricultura | pesca artesanal | ambas — períodos de cada>.
Período controvertido: <início> a <fim> (<fonte: cálculo do Previus / indeferimento de DD/MM/AAAA>).
Enquadramento:
- <início> a <fim>: <segurado especial em economia familiar | individual | depende de complementação | não se enquadra> — <motivo em uma linha, com o dispositivo>.
Documentos novos nesta rodada: <quantos — quais, em uma linha cada, com o grau>.
Situação do período:
- <início> a <fim>: forte — <base documental em uma linha>.
- <início> a <fim>: depende de mais documentos — <o que falta>.
- <início> a <fim>: fraco — <por quê>.
Testemunhas: <conversado com o cliente e confirmadas | ainda não conversado — trechos que dependem disso>.
O que mudou desde a última rodada: <trechos que subiram ou desceram de grau ou mudaram de enquadramento, e por quê | primeira rodada>.
Pontos de atenção: <documento contrário, vínculo urbano concomitante, causa de descaracterização | nenhum>.
Cálculo do Previus: <cenário: sustentado | em risco | não sustentado — datas>.
Documentos mínimos para o requerimento: <sim — benefício | não — o que falta>.
Autodeclaração: <emitida em DD/MM/AAAA — <n> itens para o cliente completar | não emitida>.

Próximos passos:
1. <documento a pedir ou providência> — <para cobrir qual trecho> — <a quem pedir>.
2. ...

Documentos gravados: PROVA RURAL - <NOME>.docx<, AUTODECLARAÇÃO RURAL - <NOME>.pdf, AUTODECLARAÇÃO - PENDÊNCIAS - <NOME>.docx>
```

Quando a autodeclaração foi emitida, o primeiro próximo passo é
`enviar ao cliente a autodeclaração e a lista de pendências; pedir que confira,
complete, assine todas as páginas e devolva`.

Cada próximo passo é ação executável por alguém da equipe ("pedir ao cliente a
certidão de casamento dos pais, para cobrir 1978–1982", "pedir à colônia de
pescadores de <cidade> a ficha de inscrição do pai", "pedir o CCIR do sítio para
conferir os módulos fiscais"), não observação. Nada **fraco** aparece como certo.

## Regras que não se negociam

**Documento rural não é tempo rural.** O grau do trecho vem do conjunto — documentos,
testemunhas, enquadramento, vínculo do cliente com o grupo familiar, idade, ausência
de causa de descaracterização —, nunca da existência isolada de um papel. Ver
`$BASE/references/rural.md`.

**Prova sem enquadramento não basta.** Documento forte de um trecho em que a
atividade não se enquadra como segurado especial não salva o trecho. Ver
`$BASE/references/segurado-especial.md`.

**Não se exige documento ano a ano.** Ano sem documento dentro de um trecho não é
lacuna. Na infância, um documento contemporâneo dos pais mais testemunhas basta; na
vida adulta, conta o número de documentos e se marcam início e fim.

**Documento em nome de terceiro não é imprestável**, mas só vale com a relação do
cliente com o titular demonstrada e com o titular dentro do grupo familiar daquele
trecho. Sem isso, no máximo **depende de mais documentos**.

**Nunca afirme uma regra legal de memória.** Módulos fiscais, idade de ingresso no
grupo familiar, limites de 120 dias, porte da embarcação, RGP, valor da declaração de
sindicato e da autodeclaração, prova exclusivamente testemunhal — tudo está mapeado
em `$BASE/references/segurado-especial.md` com o dispositivo, e se confere no acervo
(`$BASE/references/legislacao.md`) antes de citar. Sem ter lido o texto, escreva que
depende de conferência legal.

**Nunca declare lido o que não foi lido.** `ler-pdf.sh` sai com código 4 e imprime
`!!! RENDERIZACAO INCOMPLETA` quando renderiza menos páginas do que o PDF tem.
Documento lido em parte não recebe grau **forte**; registre a lacuna.

**Nunca apague o que veio antes.** Ficha de documento, linha do histórico e
documento que sumiu da pasta permanecem no controle. Grau só muda com o motivo
registrado.

**Nunca altere a ficha da análise inicial.** Ela é lida para contexto e mais nada.

**Autodeclaração só com dado de documento.** Ela é assinada pelo cliente sob as
penas do art. 299 do Código Penal. Nada é deduzido, arredondado ou presumido; o que
não está num documento fica em branco e vai para a lista de pendências.

**Toda rodada termina com o balanço de cobertura**, no próprio controle: o que foi
lido nesta rodada, por inteiro ou em parte, e o que ficou de fora e por quê.

**Dados do cliente nunca entram neste repositório.** O controle vai só para a pasta
do cliente no Drive.

## Ambiente

Ferramentas, caminhos e limitações da máquina em `$BASE/references/ambiente.md`.
