# Formato da ficha

A ficha é documento interno de leitura rápida. É **telegráfica** — a equipe lê
dezenas por mês e reconhece o padrão de relance. Não a torne mais explicativa: quem
precisa de explicação lê o documento de trabalho.

## Marcação de entrada

Escreva um `.txt` UTF-8 e converta com `scripts/gerar-docx.ps1`. A marcação aceita:

| Marcação | Resultado |
|---|---|
| `# Texto` | parágrafo em negrito (título de bloco) |
| `**trecho**` | negrito dentro da linha |
| `\|a\|b\|c\|` | linha de tabela (linhas seguidas viram uma tabela) |
| linha vazia | parágrafo vazio |
| qualquer outra | parágrafo normal |

Saída em Times New Roman 11pt, A4, margens do `PADRAO ANÁLISE INICIAL.docx`.

## Estrutura

```
NOME COMPLETO DO CLIENTE
ANÁLISE INICIAL LARI
Possui QS

# Possui:
- 32 anos, 10 meses e 06 dias de TC;
- 400 contribuições;
- 56 anos, 04 meses e 20 dias de idade.

# Expectativa futura:
1) Comum, por pontos em 11/06/2032, provável RMI R$ 5.073,35
2) C. especial integral, com direito ao TA50%, provável RMI R$ 3.789,49
3) Ap. especial, por pontos em 31/01/2025, provável RMI R$ 3.932,11

# Análise CNIS
- Seq. 04 - PEXT. s/ CTPS
- Seq. 06 - PREM-FVIN s/ CTPS
- Seq. 12 - s/ remuneração 09/2016. 08/2022 abaixo do mínimo (em BI).

# Documentos médicos:
Não há

# Benefício concedido:
NB 639.842.883-1 - acidentário - DII 23/06/2022 - ...

# Benefício indeferido:
Não há

# Processo judicial:
Não há

# Documentos rurais:
Não há

# DTC/CTC:
Não há

# PPP:
Carteiro de 01/02/2000 a 30/06/2008
- Responsável pelos registros ambientais iniciou em 19/06/2000, depois do
  início do vínculo dele.

# Conclusão:
Cliente com possibilidade de aposentadoria imediata, seja comum com conversão em
especial ou aposentadoria especial propriamente dita. PPP emitido regularmente,
documento válido para comprovar a atividade especial.
```

## Regras

**Segunda linha** — **não tem padrão fixo. Pergunte.** As fichas do escritório usam,
entre outras: `ANÁLISE INICIAL LARI`, `ANÁLISE INICIAL – LARI`, `ANÁLISE INICIAL`
(sem nome), `PRÉ-ANÁLISE – LARI`, `PRÉ-ANÁLISE PAGA`, `ATUALIZAÇÃO 2025`,
`ATUALIZAÇÃO PREVIUS 2025`, `ANÁLISE INICIAL – RPPS – LARI`, `Feito por Carolina`.

Pergunte na parada final qual o tipo de análise e quem assina. Se houver ficha
anterior do mesmo cliente na pasta, use o cabeçalho dela como padrão sugerido.

**Terceira linha** — situação da qualidade de segurado, sempre presente: `Possui QS`,
`Não possui QS`, ou com o detalhe quando houver (`Possui qualidade de segurado / Com
BI ativo até 2025`, `Sem qualidade de segurada, última contribuição em 03/2021`).

**Data de referência** — o bloco `Possui` tem que dizer *em que data*. Um mesmo
relatório do Previus traz vários marcos (DIB informada, data da EC 103, data de
projeção) e cada um dá um tempo de contribuição diferente. Escolha a data que a
análise adota, use a mesma para tempo, contribuições e idade, e **confirme com a
Larissa qual é**. Trocar a data muda os três números de uma vez, em silêncio.

**Blocos vazios** — escreva `Não há`. Nunca omita. Isso distingue *não existe* de
*ninguém olhou*.

**Nomes dos blocos variam** entre as fichas do escritório: `BI` com subtítulos
`DEFERIDO`/`INDEFERIDO`, ou `BI concedido` e `BI negado`, ou `Benefício concedido` e
`Benefício indeferido`. Se houver ficha anterior do cliente, siga o vocabulário dela;
caso contrário use `Benefício concedido` / `Benefício indeferido`.

**Blocos presentes** — só inclua `Documentos rurais` e `DTC/CTC` se houver documento
ou se o caso os tornar pertinentes; do contrário saem com `Não há`. `Análise CNIS`,
`Possui` e `Expectativa futura` são obrigatórios em toda ficha.

**Economia — a regra mais importante do formato.** A ficha traz só o que muda a
estratégia do caso. O registro completo vai para o documento de trabalho.

Uma comparação real: numa cliente com aposentadoria distante e o caso centrado em
benefício por incapacidade, a analista registrou quatro linhas no `Análise CNIS` —
vínculo sem data-fim e três indicadores. Havia também remunerações abaixo do mínimo,
uma pendência `PSC-MEN-SM-EC103` e quatro lacunas contributivas, tudo verdadeiro e
tudo irrelevante para aquela estratégia. Listar os treze achados teria enterrado os
quatro que importavam.

Antes de escrever cada linha, pergunte: **isso muda alguma decisão neste caso?** Se
não muda, vai para o documento de trabalho, não para a ficha.

**Cenários da expectativa futura** incluem o benefício em curso, quando houver:

```
1) transição por idade: em 10/01/2036. RMI 1 SM
2) bi perm: em 25/09/2024. RMI SM
3) bi temp: NB 651.623.351-2 finda em 04/11/24
```

**Notas sobre o que o cliente entregou** aparecem soltas, marcadas com asterisco:
`*Enviou 1 CTPS`. Use quando a documentação recebida explica uma lacuna da análise.

**Conclusão** — dois a quatro períodos. Diz qual é o melhor cenário, o que sustenta a
conclusão e o que falta. Nada que esteja etiquetado como **controvertido** entra aqui
como afirmação: ou vira pergunta na parada final, ou aparece com a ressalva expressa.

Nem toda ficha do escritório tem bloco de conclusão — em caso simples, a expectativa
futura já diz tudo. Não force um parágrafo que não acrescenta.

**Números do Previus** — se não houver cálculo na pasta e a Larissa não tiver
informado, escreva `Expectativa futura: pendente de cálculo no Previus` em vez de
deixar em branco.

## Siglas

Use como o escritório usa. Não expanda na ficha; expanda no documento de trabalho.

| Sigla | Significado |
|---|---|
| QS | qualidade de segurado |
| TC | tempo de contribuição |
| BI | benefício por incapacidade |
| NB | número do benefício |
| DER | data de entrada do requerimento |
| DIB | data de início do benefício |
| DIP | data de início do pagamento |
| DII | data de início da incapacidade |
| RMI | renda mensal inicial |
| PG | período de graça |
| 1 SM | um salário mínimo |
| C. especial | conversão de tempo especial em comum |
| Ap. especial | aposentadoria especial |
| CAT | comunicação de acidente de trabalho |
| SABI | perícia médica administrativa do INSS |
| ATESTMED | análise documental de atestado, sem perícia presencial |
| CTC / DTC | certidão / declaração de tempo de contribuição |
| PPP | perfil profissiográfico previdenciário |
| LTCAT | laudo técnico de condições ambientais do trabalho |
| RPPS / RGPS | regime próprio / regime geral |

`TA50%` e `TA100%` aparecem nas fichas designando as regras de transição com
pedágio. **Reproduza a notação como está e não a expanda por conta própria** — se
precisar explicar no documento de trabalho, confirme antes com a Larissa.

Indicadores do CNIS (`PEXT`, `IEAN`, `PREM-BLOQ-EC103`…) são reproduzidos como
aparecem no extrato. Ver `cnis.md` antes de afirmar o efeito de qualquer um.

## Onde salvar

- `<pasta do cliente>/ANÁLISE INICIAL/<NOME DO CLIENTE>.docx`
- `H:/Drives compartilhados/CBA/EQUIPE/LARISSA MARGHOTI DOS SANTOS/2 - ANÁLISES INICIAIS/<NOME DO CLIENTE>.docx`

O nome do arquivo é o nome completo do cliente em maiúsculas, como nas fichas
existentes. Se já houver ficha com esse nome, mostre o que vai mudar antes de
sobrescrever.
