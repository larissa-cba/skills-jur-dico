# Sistema de design — apresentação e relatório

A apresentação (`.pptx`/PDF, para a chamada com a cliente) e o relatório
narrativo (PDF, para a cliente reler depois) são gerados como HTML/CSS e
convertidos para PDF com o Chromium do Edge — não como `.pptx`/`.docx`
nativos. Ver o porquê e o mecanismo no `SKILL.md`, seção "Montagem".

Este arquivo é a doutrina visual: cores, fontes, e um catálogo dos blocos de
layout já usados nos dois documentos de referência do escritório. **Não
existe motor de templates aqui** — você copia o bloco do `modelo-*.html` que
corresponde ao conteúdo do caso e preenche, do jeito que já faz com o texto
das fichas de análise inicial. `assets/style.css` tem as classes prontas.

## Cores (Manual de Marca CBA 2025)

| Variável CSS | Hex | Uso |
|---|---|---|
| `--verde` | `#28443F` | fundo de slide escuro, títulos, cabeçalho de tabela, cartão de destaque |
| `--bege` | `#A7947E` | rótulos em versalete (`.overline`), realces pontuais |
| `--taupe` | `#B3ADA8` | uso secundário, quase não aparece nestes dois documentos |
| `--off-white` | `#F2F2F2` | fundo de slide claro alternado, cartão sobre slide branco |
| `--branco` | `#FFFFFF` | fundo de slide branco alternado, cartão sobre slide `--off-white` |
| `--bege-tint` | `#EFE8DE` | linha de tabela em realce (aproximação de `--bege` a ~18% sobre branco) |

**Alternância clara/escura dos slides**: cada slide da apresentação é
`--branco`, `--off-white` ou `--verde` (nunca mais que isso). Um cartão
sobre slide `--branco` usa fundo `--off-white`, e vice-versa — é esse
contraste sutil que dá a sensação de profundidade nos slides de cartões.
O relatório narrativo não tem páginas escuras: é sempre `--branco`, com um
`.destaque-caixa` (verde) só na recomendação final.

## Tipografia — atenção a uma divergência

O manual de marca (texto) diz "STARA (medium) para os títulos, ALBRA
(regular italic) para detalhes e ênfases". **Isso não bate com os dois
documentos de referência nem com o próprio exemplo visual do manual.**
Testando os arquivos de fonte reais:

- `Stara-Medium.otf` é uma fonte **sans-serif** geométrica arredondada — não
  aparece em nenhum título dos dois documentos de referência.
- Os títulos de ambos os documentos (`Planejamento previdenciário`, `A
  situação de hoje`, os números `13`, `26`, `154`...) usam a fonte serifada
  com algarismos old-style que só bate com **`Albra` no estilo normal**
  (`AlbraTRIAL-Regular.otf`), não com Stara.
- O itálico de ênfase (`história`, `missão`, as frases em itálico dentro dos
  slides) bate com **`Albra` itálico** (`AlbraTRIAL-Regular-Italic.otf`),
  que é o que o manual pede — nisso o manual acerta.

Este sistema de design segue o que os dois documentos de referência
realmente usam: **Albra normal para títulos, Albra itálico para ênfase**.
Isso é uma decisão tomada para bater com o padrão pedido pela Larissa, não
uma correção silenciosa do manual — **vale confirmar com quem mantém o
manual se o exemplo visual dele é que está desatualizado, ou se o "STARA"
do texto é que está errado.**

**Licença**: os arquivos encontrados ficam em
`H:/Drives compartilhados/CBA/MARKETING/0 - ID VISUAL ESCRITÓRIO/FONTES/`,
dentro de uma pasta `AlbraTRIAL` — o nome sugere fonte de avaliação, não
licença comercial plena. Vale confirmar com o escritório se há licença de
uso comercial da Albra antes de manter este padrão em produção continuada.
Por isso as fontes **não são copiadas para este repositório**: o passo de
montagem do `SKILL.md` copia os dois arquivos `.otf` do Drive para uma
pasta `fonts/` ao lado do HTML gerado, a cada execução, e o PDF final leva
a fonte embutida — nada de fonte fica versionado em git.

```
Origem (Drive, não git):
H:/Drives compartilhados/CBA/MARKETING/0 - ID VISUAL ESCRITÓRIO/FONTES/AlbraTRIAL/AlbraTRIAL-Regular.otf
H:/Drives compartilhados/CBA/MARKETING/0 - ID VISUAL ESCRITÓRIO/FONTES/AlbraTRIAL/AlbraTRIAL-Regular-Italic.otf

Destino (pasta de trabalho, ao lado do HTML):
fonts/Albra-Regular.otf
fonts/Albra-RegularItalic.otf
```

Corpo de texto: `SF Pro` (fonte da Apple, sem arquivo redistribuível). Uso o
empilhamento `-apple-system, 'SF Pro Text', 'Segoe UI', Arial, sans-serif` —
nesta máquina Windows renderiza como Segoe UI, visualmente equivalente para
texto corrido e rótulos.

## Catálogo de blocos

Cada bloco abaixo tem um exemplo completo em `assets/modelo-apresentacao.html`
ou `assets/modelo-relatorio.html`, com dados fictícios. Copie o `<section>`
ou `<div>` correspondente e preencha.

### Apresentação (slides 16:9, `1000px` × `562px`)

| Bloco | Classe | Quando usar |
|---|---|---|
| Capa | `.capa` | sempre, slide 1 |
| Linha de estatísticas simples | `.linha-stats` | dados cadastrais, 2–4 itens curtos |
| Par de cartões com número grande | `.grade.col2` + `.cartao` | tempo de contribuição / carência |
| Número hero em slide escuro | `.hero-num` | "o que falta" — um número grande dominando o slide |
| Bullets com barra lateral | `.bullets3` | lista do que o planejamento analisou |
| Tabela de dados | `table.dados` | síntese contributiva, pendências, comparativos |
| Linha `tr.realce` / `tr.recomendado` | — | destaca a linha vencedora sem quebrar o padrão da tabela |
| Três cartões (2 escuros + 1 claro) | `.grade.col3` + `.cartao.verde` | plano de correção do CNIS |
| Duas colunas com caixa lateral | `.col2` | pendências por gravidade, direitos específicos (PCD) |
| Números 01–04 | `.numerado4` | visão geral dos cenários antes do detalhe |
| Cartões de simulação (S1.1, S1.2...) | `.simulacoes` + `.sim` | um slide por cenário, 1 card por simulação |
| Slide de recomendação técnica | `.rec-tecnica` (fundo `.dark`) | penúltimo bloco, antes de serviços/providências |
| Slide de encerramento | — | disclaimer + assinatura, último slide |

### Relatório (páginas A4, `210mm` × `297mm`)

| Bloco | Classe | Quando usar |
|---|---|---|
| Página de abertura | primeira `.pagina`, sem `.cabecalho` | título + byline + "onde você está hoje" |
| Cabeçalho corrido | `.cabecalho` | toda página a partir da 2ª |
| Rodapé corrido | `.rodape` | toda página, inclusive a 1ª |
| Caixa de definição | `.definicao` | explicar um termo técnico (carência, tempo de contribuição...) |
| Tabela de relatório | `table.relatorio` | mesma lógica das tabelas da apresentação, em escala menor |
| Caixa de destaque (recomendação) | `.destaque-caixa` | "o que recomendamos", uma vez por relatório |
| Bloco de assinatura | `.assinatura-final` | última página |

## Paginação

Nenhum dos dois documentos usa cabeçalho/rodapé "fixos" do navegador —
**cada página é uma `<section>` de tamanho exato** (`page-break-after:
always`), com o cabeçalho e o rodapé escritos dentro dela. Testado: o
Chromium não repete de forma confiável elementos `position: fixed` em
impressão para PDF com múltiplas páginas (alguns removem, alguns
duplicam). Por isso o cabeçalho/rodapé do relatório é HTML repetido em
cada `.pagina`, não CSS de página corrida.

Isso significa que **você decide onde cada página quebra**, como decide
onde um cenário quebra no `.docx` de outros relatórios. Depois de escrever,
renderize e confira se algum bloco ultrapassou a altura da página (o texto
"vaza" visualmente sobre o rodapé — é o sinal de que precisa mover
conteúdo para a página seguinte).

## Convenção de nomes de classe

As classes estão em português (`.cartao`, `.grade`, `.regra`) de propósito:
é o mesmo generated content que a equipe eventualmente vai abrir e ajustar
à mão, e nome em português casa com o resto da skill.
