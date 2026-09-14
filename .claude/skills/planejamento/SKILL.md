---
name: planejamento
description: Planejamento previdenciário nos três níveis do escritório, a partir dos documentos e cálculos da pasta PLANEJAMENTO PREVIDENCIÁRIO do cliente. Gera uma apresentação para a chamada com a cliente e um relatório narrativo para ela reler depois, no padrão visual da marca CBA, mais um documento de trabalho interno.
disable-model-invocation: true
---

# Planejamento previdenciário

Lê a pasta do cliente e monta dois documentos voltados à cliente — uma
**apresentação** (para a chamada de devolutiva) e um **relatório narrativo**
(para ela reler depois, em segunda pessoa) — mais um documento de trabalho
interno. Os dois primeiros saem como PDF, no padrão visual da marca CBA, e são
construídos como HTML/CSS antes de virar PDF (ver "Montagem" abaixo) — não são
`.pptx`/`.docx` nativos.

## Invocação

```
/planejamento <caminho da pasta do cliente> --nivel 1|2|3
```

Se o caminho não vier, peça. Não adivinhe o cliente pelo nome citado na conversa.

Se o nível não vier, pergunte. **O nível é decisão comercial, não técnica** — reflete
o que o cliente contratou, e isso a pasta não diz. Mas se o material indicar outro
nível, avise: PPP, documento rural ou CTC na pasta sugerem nível 3, e pedir nível 1
com esse material significa deixar direito reconhecível de fora.

## Material compartilhado

Scripts e doutrina de leitura ficam em `previdenciario-base`, ao lado desta skill, e
são os mesmos da `analise-inicial`. Leia o `README.md` de lá antes de começar: as
regras sobre custo, cobertura e legislação valem aqui integralmente.

Aqui ficam só os três níveis e os formatos de saída desta skill. O
`html-para-pdf.ps1` usado na montagem também mora em `$BASE/scripts/`.

> **Todo caminho neste arquivo é relativo à pasta desta skill**, informada como
> "Base directory for this skill" quando a skill carrega — **não** ao diretório de
> trabalho da sessão. Antes do primeiro comando, guarde essa pasta numa variável e
> use-a em tudo:
>
> ```bash
> SKILL="<base directory desta skill>"
> BASE="$SKILL/../previdenciario-base"
> ```
>
> Os exemplos abaixo usam `$BASE` e `$SKILL` nesse sentido.

## Fluxo

### 1. Varredura

```bash
bash "$BASE/scripts/varrer-pasta.sh" "<caminho da pasta do cliente>"
```

Varra a pasta raiz do cliente, não só a subpasta de planejamento — CTPS costuma
estar em `DOCUMENTOS PESSOAIS` e documentos médicos em `DOCUMENTOS MEDICOS`.

**Não leia a ficha de análise inicial**, mesmo que exista. A análise é feita do zero,
por decisão do escritório: partir da ficha propagaria qualquer erro dela para o
planejamento sem ninguém perceber.

### 2. Primeira parada — inventário

Mostre o que encontrou e **pare**. Some as páginas escaneadas e diga quantas são.

**Se não houver nenhum cálculo do Previus, pare aqui e diga o que falta.** Todo o
relatório gira em torno dos cenários, e cada cenário vem de um cálculo. Relatório
com cenário em branco é pior que relatório nenhum. Não siga adiante.

### 3. Leitura

```bash
bash "$BASE/scripts/ler-pdf.sh" "<arquivo.pdf>" "<pasta de trabalho>"
```

Doutrina por tipo de documento em `$BASE/references/`: `cnis.md`,
`ppp.md`, `rural.md`, `medicos.md`, `dtc-ctc.md`, `pedidos-administrativos.md`.
Carregue só o que o caso pedir.

Os cálculos do Previus são de leitura obrigatória e são a fonte dos cenários. Ver
`$SKILL/references/cenarios.md` para o que extrair de cada um.

### 4. Segunda parada — mapeamento dos cenários

Esta parada não existe na `analise-inicial` e existe aqui porque o mapeamento define
a estrutura do documento inteiro. Descobrir na entrega que o cenário 3 era outra
coisa significa refazer o relatório.

Apresente uma tabela: qual arquivo de cálculo vira qual cenário, com que nome, e os
números que você extraiu de cada um. **Pare e confirme.**

Diga também, aqui, o que você **não** conseguiu extrair — tipicamente valor investido
e payback, que podem ser conta feita à parte e não sair dos PDFs. Pergunte esses
números em vez de calculá-los: errar payback é errar a recomendação.

### 5. Montagem

Três arquivos, nesta ordem. **Leia `$SKILL/references/design-sistema.md` antes de
escrever a primeira linha de HTML** — é lá que estão as cores, as fontes e o
catálogo de blocos de layout. Não invente classe nova sem necessidade: os dois
documentos de referência do escritório usam um vocabulário pequeno e repetido.

**a) Fontes.** Copie os dois arquivos do Drive para uma pasta `fonts/` ao lado
de onde os HTML vão ser escritos — eles não ficam no repositório (ver o porquê
em `design-sistema.md`, seção Licença):

```bash
mkdir -p "<pasta de trabalho>/fonts"
cp "H:/Drives compartilhados/CBA/MARKETING/0 - ID VISUAL ESCRITÓRIO/FONTES/AlbraTRIAL/AlbraTRIAL-Regular.otf" "<pasta de trabalho>/fonts/Albra-Regular.otf"
cp "H:/Drives compartilhados/CBA/MARKETING/0 - ID VISUAL ESCRITÓRIO/FONTES/AlbraTRIAL/AlbraTRIAL-Regular-Italic.otf" "<pasta de trabalho>/fonts/Albra-RegularItalic.otf"
cp "$SKILL/assets/style.css" "<pasta de trabalho>/style.css"
```

**b) HTML.** Copie `$SKILL/assets/modelo-apresentacao.html` e
`$SKILL/assets/modelo-relatorio.html` para a pasta de trabalho e preencha os
dois — o mapeamento de cenários da parada anterior vira os slides/páginas de
cenário, um bloco por cenário ou por simulação, conforme `niveis.md` mandar
para o nível do caso. Remova os blocos de exemplo que não se aplicam (o
catálogo em `design-sistema.md` diz qual bloco serve para qual conteúdo);
não deixe bloco de exemplo sobrando por preguiça de apagar.

Antes de renderizar, confira que não sobrou nenhum `[ALGO ENTRE COLCHETES]`:

```bash
grep -no '\[[^]]*\]' "<pasta de trabalho>/apresentacao.html" "<pasta de trabalho>/relatorio.html"
```

Qualquer ocorrência é bloqueio, não observação — preencha antes de seguir.

**c) PDF.**

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/html-para-pdf.ps1" -Origem "<pasta de trabalho>/apresentacao.html"
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/html-para-pdf.ps1" -Origem "<pasta de trabalho>/relatorio.html"
```

Abra os PDFs gerados e confira visualmente: nenhuma tabela ou cartão pode
"vazar" para fora do slide, e nenhuma página do relatório pode ter texto
sobrepondo o rodapé — ambos são sinal de que um bloco precisa ser encurtado
ou movido para o próximo slide/página (ver "Paginação" em `design-sistema.md`).
Ajuste o HTML e rode `html-para-pdf.ps1` de novo até fechar limpo.

### 6. Terceira parada — resultado

Entregue os três arquivos e reúna as dúvidas restantes num bloco só.

## Saída

**A apresentação** — `<pasta do cliente>/PLANEJAMENTO PREVIDENCIÁRIO/APRESENTAÇÃO PLANEJAMENTO PREVIDENCIÁRIO - <NOME DO CLIENTE>.pdf`, mais o `.html` de mesmo nome (é o fonte editável — quem abrir depois edita o HTML e roda `html-para-pdf.ps1` de novo, não mexe direto no PDF).

**O relatório** — mesma pasta, `RELATÓRIO PLANEJAMENTO PREVIDENCIÁRIO - <NOME DO CLIENTE>.pdf` e `.html`.

Se a subpasta `PLANEJAMENTO PREVIDENCIÁRIO` não existir, crie com esse nome
exato, acentuado. Não copie a pasta `fonts/` nem `style.css` para dentro da
pasta do cliente — eles são insumo de geração, o PDF já leva a fonte embutida.

**O documento de trabalho** — mesma pasta, sufixo ` - TRABALHO.docx`, gerado com
`gerar-docx.ps1`. Formato em `$SKILL/references/formato-trabalho.md`. Esse
continua `.docx`: é uso interno da equipe, não vai para a cliente, e não precisa
do padrão visual da marca.

Nunca sobrescreva apresentação, relatório ou documento de trabalho existentes
sem antes mostrar o que muda.

## Regras que não se negociam

**Nenhum comentário de autoria nem bloco de exemplo chega ao cliente.** Os
`modelo-*.html` têm comentários HTML (`<!-- ... -->`) marcando cada bloco —
eles não aparecem em navegador nem em PDF, mas apague os blocos de exemplo
que você não usou. Um bloco de exemplo esquecido no meio do documento real
aparece no PDF, porque HTML renderiza o que existe, comentário ou não.

**Nenhum campo entre colchetes chega ao cliente.** Ver o `grep` da montagem,
passo (b). Trate qualquer ocorrência como bloqueio.

**Use as escalas já estabelecidas, não as suas.** Os documentos vão para a
cliente e as escalas foram escolhidas para esse leitor: `viabilidade
baixa/média/alta`, pendências `leves/relevantes/críticas`, `custo-benefício
bom/regular/baixo`, `segurança jurídica alta/média/baixa`. As etiquetas
`forte / depende de complementação / controvertido` ficam só no documento de
trabalho.

**O código GPS entra na linha de detalhe da simulação**, junto da alíquota —
por exemplo `Alíquota: 20% — R$ 1.296,80 (GPS 1007)`, como no catálogo de
blocos. Não crie seção separada de instruções de pagamento.

**Caso com RPPS fica pela metade, e isso precisa ser dito.** A apresentação e
o relatório, como os dois documentos de referência, tratam só do RGPS.
Havendo CTC, ficha financeira, mapa de tempo de serviço ou cálculo de regime
próprio na pasta, monte o RGPS e **avise com todas as letras**, no documento
de trabalho e na entrega, que os cenários do RPPS ficaram de fora e que o
caso precisa de tratamento manual até existir um padrão para regime próprio.

**Nunca afirme regra legal de memória** — carência, regra de transição, pedágio,
pontuação, alíquota. Consulte `$BASE/references/legislacao.md`.

**Balanço de cobertura obrigatório** no documento de trabalho, uma linha por arquivo
da pasta.
