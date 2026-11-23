# Validação da previsão de cálculo

O cálculo do Previus foi feito antes do PPP novo chegar, com premissas sobre quais
períodos seriam especiais. O PPP novo pode confirmar, enfraquecer ou ampliar essas
premissas. Esta etapa diz qual dos três aconteceu, cenário por cenário.

**Não recalcula.** O Previus exige login. A skill aponta o que mudar e quem recalcula
é a equipe.

## 1. Onde estão os cálculos

PDFs `Cálculo de <NOME> (<cenário>).pdf` na pasta do cliente, normalmente em
`ANÁLISE INICIAL`, `ANÁLISE PREVIUS` ou `PRÉ ANÁLISE`. São legíveis por texto:

```bash
bash "$BASE/scripts/ler-pdf.sh" "<Cálculo de ... .pdf>" "<pasta de trabalho>"
```

O nome entre parênteses é o cenário (`comum`, `c. especial`, `ap. especial`…).
Havendo mais de um cálculo do mesmo cenário, use o mais recente e diga qual.

## 2. O que extrair de cada cenário

Para cada PDF:

- espécie do benefício e regra aplicada;
- DIB / data de referência adotada;
- tempo de contribuição total e, se houver, tempo especial;
- RMI prevista;
- **a lista de períodos**, e para cada período desta empresa: datas, se foi computado
  como **especial** (fator de conversão, marcação de atividade especial ou contagem
  em aposentadoria especial) ou **comum**.

Mostre o que extraiu, cenário por cenário, antes de concluir. Um período lido errado
no relatório contamina a validação inteira sem dar sinal.

**Cuidado com a data de referência**, como na análise inicial: o mesmo relatório traz
vários marcos (DIB, EC 103/2019, projeção), cada um com um tempo diferente. Diga qual
marco você usou.

## 3. Confronto

Para cada período desta empresa em cada cenário, cruze o que o Previus assumiu com o
grau que a análise do PPP deu ao período:

| Previus assumiu | PPP concluiu | Resultado |
|---|---|---|
| especial | **forte** | premissa **confirmada** |
| especial | **depende de complementação** | premissa **em risco** — cenário depende da complementação |
| especial | **controvertido** ou sem especialidade | premissa **não sustentada** — recalcular sem o período especial (ou com o trecho que se sustenta) |
| comum | **forte** | **ganho não computado** — recalcular incluindo o período especial |
| comum | complementação ou controvertido | sem efeito imediato; registrar o potencial |
| período especial só em parte | PPP sustenta trecho diferente | recalcular com as datas que o PPP sustenta |

Atenção às **datas**, não só à classificação: o PPP novo pode sustentar a
especialidade de 01/02/2000 a 31/12/2015 enquanto o Previus computou até 2020. O
trecho excedente é premissa não sustentada.

## 4. Resultado por cenário

| Cenário | Resultado | O que fazer no Previus |
|---|---|---|
| Ap. especial | **recalcular** | retirar como especial 01/01/2016 a 31/12/2020 (PPP não informa exposição no período) |
| C. especial integral | **em risco** | manter; depende do LTCAT pedido à empresa |
| Comum | **mantido** | — |

- **Mantido** — todas as premissas desta empresa confirmadas, ou o cenário não usa
  tempo especial desta empresa.
- **Em risco** — alguma premissa depende de complementação. O número não muda agora,
  mas não deve ser apresentado ao cliente como certo.
- **Recalcular** — alguma premissa não se sustenta, ou há ganho não computado.

Não estime o novo tempo nem a nova RMI. Quem recalcula é o Previus. Se o cenário que
deixa de se sustentar era o melhor cenário da ficha, diga isso com destaque: muda a
estratégia.

## 5. Sem cálculo na pasta

Escreva na análise: `Não há cálculo do Previus na pasta; validação não realizada.` e
registre a providência `Calcular no Previus considerando a conclusão desta análise`.
Nunca invente números.
