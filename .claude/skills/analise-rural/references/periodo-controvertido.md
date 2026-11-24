# Período controvertido

> **Período rural** aqui inclui o período de **pesca artesanal** e qualquer outro de
> segurado especial. Tudo o que vale para um vale para o outro.

Antes de perguntar "o que este documento prova?", responda "**qual período rural
precisamos provar?**". Esse período vem de duas fontes, que se confrontam: o que o
cálculo do Previus usa e o que o INSS recusou.

## 1. Cálculo do Previus

PDFs `Cálculo de <NOME> (<cenário>).pdf` na pasta do cliente, normalmente em
`ANÁLISE INICIAL`, `ANÁLISE PREVIUS` ou `PRÉ ANÁLISE`. Têm texto:

```bash
bash "$BASE/scripts/ler-pdf.sh" "<Cálculo de ... .pdf>" "<pasta de trabalho>"
```

O nome entre parênteses é o cenário. Havendo mais de um cálculo do mesmo cenário, use
o mais recente e diga qual.

De cada cenário extraia:

- espécie do benefício, regra e data de referência (DIB, EC 103/2019, projeção — diga
  qual marco usou);
- **cada período rural computado**: datas de início e fim, como aparece identificado
  (atividade rural, segurado especial, período a averbar…);
- se o cenário **depende** do tempo rural para fechar o requisito — compare o tempo
  total com o exigido. Cenário que fecha só com o rural é o que mais importa.

Mostre o que extraiu, cenário por cenário, antes de concluir. Um período lido errado
no relatório contamina o mapa de cobertura inteiro sem dar sinal.

Período rural **já presente no CNIS** (vínculo rural registrado, período já
averbado) não é controvertido: registre e exclua.

## 2. Indeferimento e processo administrativo

Leitura conforme `$BASE/references/pedidos-administrativos.md`. Para o tempo rural,
extraia:

- período rural **requerido** pelo cliente (autodeclaração, requerimento);
- período rural **reconhecido** pelo INSS, se algum;
- período rural **não reconhecido**, e o **motivo** literal — ausência de início de
  prova material, documento extemporâneo, documento em nome de terceiro, vínculo
  urbano do grupo familiar, idade, área acima de 4 módulos fiscais, entrevista rural
  desfavorável…;
- se a autodeclaração foi **ratificada**, total ou parcialmente, e por qual base ou
  documento (despacho conclusivo, pesquisa às bases governamentais — Ofício 46,
  itens 3 a 5);
- a **data de entrada do requerimento (DER)** — decide as regras do Ofício 46 que se
  aplicaram (declaração de sindicato até 17/01/2019, entrevista rural até
  08/08/2017; ver `$BASE/references/segurado-especial.md`, seção 6);
- documentos rurais apresentados no processo — eles também entram no inventário;
- resultado de justificação administrativa, se houve.

O motivo do indeferimento diz **onde a prova precisa ser mais forte**. Registre-o no
controle ao lado do trecho a que se refere.

Sem processo administrativo na pasta: diga isso e use só o Previus.

## 3. Confronto e período adotado

| Previus usa | INSS | Resultado |
|---|---|---|
| período rural | não reconheceu | **controvertido** — é o alvo principal |
| período rural | reconheceu | já reconhecido — fora do mapa, mas registrado |
| período rural | não houve requerimento | **controvertido** — prova ainda não testada |
| não usa | cliente requereu e foi negado | registrar como **potencial**; perguntar se entra no mapa |

Divergência de datas entre as fontes (o Previus computa de 1975 a 1990, o
requerimento pedia de 1972 a 1990) vai para a primeira parada. Não escolha sozinho.

O **período adotado** sai no controle com a fonte de cada data:

```
Período controvertido: 12/03/1976 a 31/12/1989
Início: data em que o cliente completou <idade> anos, adotada no Previus cenário "comum"
Fim: véspera do primeiro vínculo urbano no CNIS (01/01/1990)
Indeferimento de 14/05/2025: período não reconhecido por "ausência de início de prova material contemporâneo"
```

A idade que marca o início de um período na infância é questão legal: confira no
acervo antes de aceitar a data do Previus como correta.

## 4. Efeito no cálculo

Depois do mapa de cobertura, cruze cada cenário com o grau dos trechos que ele usa:

| Previus computa o trecho | Grau do trecho | Premissa |
|---|---|---|
| sim | **forte** | **sustentada** |
| sim | **depende de mais documentos** | **em risco** — o número não muda agora, mas não deve ser apresentado ao cliente como certo |
| sim | **fraco** | **não sustentada** — recalcular sem o trecho, ou buscar prova antes de usar |
| não | **forte** | **ganho não computado** — recalcular incluindo o trecho |

Tabela final, por cenário:

| Cenário | Premissa rural | O que fazer no Previus |
|---|---|---|
| Comum | em risco | manter; 1976–1979 depende da certidão de casamento dos pais |
| Híbrida | não sustentada | recalcular sem 1980–1982 até chegar documento do período |

Se o cenário que deixa de se sustentar era o melhor da ficha, diga isso com
destaque: muda a estratégia. **Não estime tempo nem RMI.** Quem recalcula é o
Previus.

Sem cálculo do Previus na pasta: `Não há cálculo do Previus na pasta; efeito no
cálculo não avaliado.` — e a providência `Calcular no Previus considerando o mapa de
cobertura`.
