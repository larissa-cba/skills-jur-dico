# Cenários: dos cálculos para o relatório

Cada cálculo do Previus na pasta vira um cenário do relatório. Esse mapeamento é a
decisão estrutural do documento — por isso ele tem parada própria.

## Como os arquivos se chamam

O escritório numera e descreve os cálculos no próprio nome, e o texto entre
parênteses diz o que aquele cenário representa. Exemplos reais:

```
1) Cálculo de AZELINO RODRIGUES.pdf
2) Cálculo de AZELINO RODRIGUES (hibrida).pdf
4) Cálculo de AZELINO RODRIGUES (PCD diabetes + esp.).pdf
6) Cálculo de AZELINO RODRIGUES (PCD 1BI + esp. + roça).pdf
Cálculo de ELIO JOSE DIAS (previus inicial- MEI).pdf
Cenário RPPS - CTC- Cálculo de CARINE ADAMES PACHECO (RPPS).pdf
```

Use o número para ordenar e o parêntese para nomear. Mas **confirme abrindo o
arquivo**: o nome é pista, não fonte. A espécie do benefício e a DIB estão dentro do
PDF, e é o conteúdo que decide.

Pode haver subpasta `PROJEÇÕES INICIAIS` com simulações da mesma regra em
periodicidades diferentes — `(mensal)`, `(2 meses)`, `(6 meses)`. Essas são as
**simulações internas** de um cenário (S1.1, S1.2…), não cenários separados.

## O que extrair de cada cálculo

Os relatórios do Previus são legíveis por texto. Procure:

| Campo | Onde costuma estar |
|---|---|
| Espécie do benefício | cabeçalho, com o código (41, 32, 46…) |
| DIB informada | cabeçalho |
| Tempo de contribuição na DIB | bloco "Tempo de Contribuição" |
| Nº de contribuições | mesmo bloco, ao lado |
| Idade na DIB | bloco "Idade" |
| Regra aplicável e requisitos | "Análise das Regras de Transição — EC 103/2019" |
| Salário de benefício, coeficiente, RMI | bloco de cálculo da RMI |
| Investimento mensal e projeção | quando o cálculo traz projeção futura |

**Cuidado com a data de referência.** Um mesmo relatório traz vários marcos — DIB
informada, data da Lei 9.876/99, data da EC 103/2019, data de projeção — e cada um
produz tempo, contribuições e idade diferentes. Escolha a data que o relatório vai
adotar, use a mesma em tudo, preencha `[DATA-BASE DO CÁLCULO]` com ela e confirme na
parada do mapeamento.

## Campos com regra própria do escritório

**Modalidade de recolhimento.** Não se inventa o código: ele se deduz de como as
contribuições atuais aparecem no CNIS.

| Como aparece no CNIS | O que significa | O que escrever |
|---|---|---|
| `AGRUPAMENTO DE CONTRATANTES/COOPERATIVAS` | prestador de serviço ou retirada de pró-labore | prestador de serviço ou pró-labore, **sem código GPS** |
| `RECOLHIMENTO` no sequencial ativo ou no último recolhido | pagamento por carnê | contribuinte individual ou facultativo, com o código abaixo |

Havendo carnê, o código depende de duas coisas — se há trabalho remunerado, e o que
a projeção assume:

| | projeção de 1 salário mínimo e aposentadoria por idade | contribuição acima de 1 salário mínimo, ou projeção por tempo de contribuição |
|---|---|---|
| **contribuinte individual** (com trabalho remunerado) | **1163** | **1007** |
| **facultativo** (demais casos) | **1473** | **1406** |

**IRRF.** Traga o valor **apenas quando o Previus indicar**. Quando não indicar,
escreva `não aplicável`. Não estime, não escreva "a apurar".

**Retorno pelo investimento projetado.** Use o resultado da **subtração** que o
Previus apresenta em `Retorno sobre o investimento:` — a linha no formato
`R$ recebido − R$ investido = R$ resultado`. Use o resultado, não o total líquido
recebido, que é a primeira parcela da conta.

## O que provavelmente não está lá

Os níveis 2 e 3 pedem, por simulação: **valor investido até a DIB**, **retorno
projetado** e **payback em meses**. No relatório real da Carine esses números
aparecem assim:

> Valor investido em 18 anos e 10 meses (226 meses): R$ 59.664,00
> Retorno pelo investimento (272 meses): R$ 299.376,00
> Números de benefícios recebidos para retornar o investimento: 46 meses, com 65
> anos e 10 meses

Pode ser que o Previus forneça, pode ser conta feita à parte. **Verifique no PDF
antes de assumir qualquer coisa.** Se não estiver lá, pergunte — não calcule.

Errar payback é errar a recomendação financeira inteira, e é um erro que passa
despercebido porque o número parece plausível. Perguntar custa uma linha; recalcular
por conta própria custa a confiança no relatório.

## Como montar

Cada cenário vira um bloco `.simulacoes` (um slide na apresentação, uma
tabela `table.relatorio` no relatório) — copie o bloco do
`modelo-apresentacao.html`/`modelo-relatorio.html` uma vez por cenário e
preencha. Ver `design-sistema.md` para a classe de cada peça.

No nível 2, os cenários são **regras alternativas** — cada um é um caminho diferente
de aposentadoria. No nível 3, são **camadas incrementais**: sem reconhecimentos, com
especial, com especial e rural, aposentadoria especial. Cada camada mostra o efeito
de um reconhecimento a mais sobre data e valor. Não misture as duas lógicas — ver
`niveis.md`.

## Quando há RPPS

Havendo CTC, ficha financeira, mapa de tempo de serviço ou cálculo de regime próprio,
o caso tem RPPS. Os templates só tratam do RGPS e afirmam isso na abertura.

Monte o RGPS normalmente e **registre a limitação** no documento de trabalho e na
entrega: quais arquivos de RPPS existem, o que eles indicariam, e que os cenários do
regime próprio ficaram de fora. Não enxerte um bloco de RPPS no template — o
documento passaria a contradizer a própria identificação.
