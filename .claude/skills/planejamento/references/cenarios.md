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

Duplique o bloco do cenário no template com `DUP_BLOCO`, tantas vezes quantos forem
os cenários, e as linhas dos quadros com `DUP_LINHA`. Depois preencha na ordem do
documento.

No nível 2, os cenários são **regras alternativas** — cada um é um caminho diferente
de aposentadoria. No nível 3, são **camadas incrementais**: sem reconhecimentos, com
especial, com especial e rural, aposentadoria especial. Cada camada mostra o efeito
de um reconhecimento a mais sobre data e valor. Não misture as duas lógicas.

## Quando há RPPS

Havendo CTC, ficha financeira, mapa de tempo de serviço ou cálculo de regime próprio,
o caso tem RPPS. Os templates só tratam do RGPS e afirmam isso na abertura.

Monte o RGPS normalmente e **registre a limitação** no documento de trabalho e na
entrega: quais arquivos de RPPS existem, o que eles indicariam, e que os cenários do
regime próprio ficaram de fora. Não enxerte um bloco de RPPS no template — o
documento passaria a contradizer a própria identificação.
