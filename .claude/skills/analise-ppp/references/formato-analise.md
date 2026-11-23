# Formato da análise do PPP

Documento interno da equipe, uma por PPP recebido. Fica em:
`<pasta do cliente>/ANÁLISE INICIAL/ANÁLISE DE PPP - <EMPRESA> - <DD.MM.AAAA>.docx`

Linguagem **por extenso**, como no documento de trabalho da análise inicial — quem
lê pode não dominar as siglas. A primeira seção é o resumo, porque é a única que
muita gente vai ler.

Marcação de entrada a mesma de `gerar-docx.ps1`: `# Título` em negrito, `**trecho**`,
linhas `|a|b|` viram tabela, linha vazia vira parágrafo vazio.

## Estrutura

```
NOME COMPLETO DO CLIENTE
ANÁLISE DE PPP — <RAZÃO SOCIAL DA EMPRESA>
Data da análise: DD/MM/AAAA
PPP analisado: emitido em DD/MM/AAAA, arquivo <nome do arquivo>

# 1. Resumo
# 2. Conferência do PPP
# 3. Agentes nocivos e período de exposição
# 4. Comparação com PPPs anteriores
# 5. Capacidade de reconhecimento como especial
# 6. Validação da previsão de cálculo
# 7. Retificação
# 8. Providências
# 9. Balanço de cobertura
```

Nenhuma seção se omite. Seção sem conteúdo sai com uma linha dizendo por quê
(`Não há outro PPP da mesma empresa e período na pasta.`).

## 1. Resumo

Cinco linhas, no máximo, nesta ordem:

```
- PPP a utilizar: emitido em 15/08/2024 (o de 10/03/2021 fica desconsiderado — substituído sem perda).
- Período 01/02/2000 a 31/12/2020: potencial de reconhecimento como especial — grau forte.
- Correções do PPP anterior: 5 de 6 corrigidas; responsável técnico continua a partir de 19/06/2000.
- Cálculo: cenário Ap. especial mantido; C. especial em risco até chegar o LTCAT.
- Próximo passo: pedir LTCAT de 2000 à empresa.
```

## 2. Conferência do PPP

Uma linha por item da conferência inicial do roteiro (seção 1 de `ppp.md`), mais
os itens de regularidade formal (seção 9):

| Item | Situação | Evidência |
|---|---|---|
| Nome e CPF do segurado | correto | página 1, campos 5 e 6 |
| Razão social e CNPJ | correto | página 1, campos 1 e 2 |
| Período trabalhado | correto | confere com CNIS Seq. 03 |
| Cargo/função | incompleto | só o cargo; sem CBO |
| Descrição das atividades | incorreto | descreve função administrativa; CTPS registra operador de prensa |
| Metodologia do ruído | ausente | campo 15.5 em branco |
| Responsável pelos registros ambientais | incompleto | a partir de 19/06/2000; vínculo desde 01/02/2000 |
| Assinatura e identificação do signatário | correto | representante legal com NIT |

Situações: **correto**, **incompleto**, **incorreto**, **ausente**. Evidência sempre
com página e campo — é o que permite à equipe conferir sem reler o PPP inteiro.

Dados identificadores aparecem só como situação; não transcreva CPF, NIT ou número
de benefício.

Feche a seção com uma linha: `PPP formalmente regular` ou `PPP com <n> itens a
corrigir`, e o grau.

## 3. Agentes nocivos e período de exposição

Uma linha por agente, com a cadeia do roteiro:

| Agente | Período | Intensidade | Metodologia | Habitual e permanente | EPI/EPC | Possível enquadramento |
|---|---|---|---|---|---|---|
| Ruído | 01/02/2000 a 31/12/2020 | 87 dB(A) | NEN-HO 01 | sim | protetor auricular, CA 12345, eficaz "S" | depende de conferência do limite por época |

**Agentes químicos ganham tabela própria**, logo abaixo, separando o que o PPP diz
do composto identificado — modelo e regras em
`../../previdenciario-base/references/agentes-quimicos.md`, seção 5:

| Agente no PPP | Composto identificado | Norma do período e código | Atividade exigida pela norma | O PPP descreve essa atividade? | Grau |
|---|---|---|---|---|---|

"Composto identificado: não informado" leva o agente a, no máximo, **depende de
complementação**.

Abaixo das tabelas, em bullets, o que o roteiro manda destacar: exposição contínua,
mudança de setor ou função nas observações do PPP, agente potencialmente
cancerígeno, EPI eficaz sobre agente com tratamento jurídico específico, divergência
com CNIS, CTPS ou LTCAT.

Todo limite legal citado vem com o dispositivo (`legislacao.md`). Sem ter conferido:
`enquadramento pendente de conferência legal`.

## 4. Comparação com PPPs anteriores

Conforme `comparacao.md`:

1. lista das versões do grupo, com data de emissão e origem;
2. quadro comparativo campo a campo com a coluna **Situação**;
3. conferência item a item do pedido de retificação anterior, se houver;
4. veredito por PPP — **usar**, **usar em conjunto** ou **desconsiderar** — com o motivo.

Qualquer **piorou** vai também para o resumo.

## 5. Capacidade de reconhecimento como especial

Por período, a cadeia de conclusão do roteiro:

```
Empresa → função → período → agente → intensidade → metodologia →
habitualidade/permanência → EPI/EPC → inconsistências → documentação complementar →
conclusão preliminar (grau)
```

E as três respostas finais do roteiro, uma linha cada:

```
1. Exposição efetiva: ...
2. Documentação suficiente: ...
3. Potencial de reconhecimento: ...
```

## 6. Validação da previsão de cálculo

Conforme `validacao-calculo.md`: o que foi extraído de cada PDF do Previus (cenário,
data de referência, períodos desta empresa e como foram computados) e a tabela de
resultado por cenário.

## 7. Retificação

- **Cabe retificação**: lista numerada do que pedir, um item por defeito, com o
  campo e o que deveria constar. Diga se a minuta foi gerada e o nome do arquivo.
- **Não cabe**: `PPP sem defeito que justifique pedido de retificação.`
- **Já pedida antes e não atendida**: diga quais itens e proponha o próximo passo
  (reiterar, buscar LTCAT, discutir em juízo).

## 8. Providências

Mesmo formato da análise inicial:

| Período | Problema | Documento disponível | Providência | Grau |
|---|---|---|---|---|

Ordem: **controvertido**, depois **depende de complementação**, depois **forte**.
Inclua "Recalcular no Previus" quando a validação pedir.

## 9. Balanço de cobertura

| Arquivo | Páginas | Lidas | Situação |
|---|---|---|---|
| PPP 2024.pdf | 3 | 3 | integral |
| PPP 2021.pdf | 2 | 2 | integral |
| LTCAT 2019.pdf | 48 | 6 | parcial — só setor de prensas, por decisão na primeira parada |

Tudo que não foi lido, ou foi lido em parte, aparece aqui com o motivo.
