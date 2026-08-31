# Os três níveis

Os templates ficam em:

```
H:/Drives compartilhados/CBA/EQUIPE/LARISSA MARGHOTI DOS SANTOS/2 - ANÁLISES INICIAIS/planejamento previdenciário - modelo/
├── Template_Nivel1_Diagnostico.docx
├── Template_Nivel2_Completo.docx
└── Template_Nivel3_Completo_Averbacao.docx
```

**Leia o template antes de montar as diretivas.** Ele é o instrumento de trabalho do
escritório e pode ter mudado desde que esta referência foi escrita. O que está aqui
descreve o que cada nível cobre e onde estão as armadilhas — não substitui abrir o
arquivo e ver os campos que existem hoje.

---

## Nível 1 — Diagnóstico

Retrato da situação atual. **Não contempla estratégia de contribuição futura** — o
próprio texto do template diz isso, e prometer simulação aqui contradiz o documento.

Seções: identificação · objetivo · análise e plano de correção do CNIS, com uma
tabela de pendências · cenários de aposentadoria **com o que já existe**, sem novas
contribuições · considerações finais.

A tabela de pendências tem quatro colunas: `Sequencial / Empresa`, `O que consta`,
`Consequência`, `Correção`. Uma linha por pendência — duplique com `DUP_LINHA`.

Cada cenário traz data prevista, RMI estimada, requisito faltante e observação.

---

## Nível 2 — Completo

Acrescenta ao nível 1:

**Documentos analisados**, em três blocos: previdenciários, trabalhistas, e os **não
apresentados** — este último é onde entra o que faltou, e ele espelha o balanço de
cobertura do documento de trabalho.

**Síntese da vida contributiva**, com tabela de `Período · Empresa/Atividade ·
Categoria · Situação no CNIS`. Uma linha por vínculo.

**Classificação das pendências** em três grupos, antes da tabela detalhada:
`leves` (monitorar), `relevantes` (alteram tempo, carência, RMI ou data) e `críticas`
(podem gerar indeferimento ou exigir ação administrativa ou judicial).

**Tempo de contribuição e carência**, com o tempo faltante e a data provável.

**Cenários com simulação de contribuição futura.** Cada cenário tem uma ou mais
simulações (S1.1, S1.2…) e um quadro-resumo. Por simulação: base salarial,
coeficiente, alíquota, modalidade e código GPS, RMI, IRRF quando aplicável, valor
investido, retorno projetado e payback em meses.

**Análise financeira** comparando cenários por RMI, investimento até a DIB, payback e
custo-benefício.

**Conclusão técnica**, com providências separadas entre cliente e escritório.

---

## Nível 3 — Completo com averbação

Parte do nível 2 e muda três coisas.

**Documentos analisados** vira granular: previdenciários e trabalhistas · atividade
especial · rurais · PCD · indenização de contribuições em atraso · não apresentados.
As subseções 3.2 a 3.5 **só entram quando aplicáveis** — a nota interna diz isso.

**Seção 5 — Reconhecimento de direitos específicos**, que não existe nos outros
níveis. Quatro subseções, também condicionais:

| Subseção | Traz |
|---|---|
| 5.1 Atividade especial | tabela empresa/cargo/período/agente/documento, mais conclusão com viabilidade e serviço indicado |
| 5.2 Período rural | período, início de prova material, viabilidade, serviço indicado |
| 5.3 PCD | indícios de impedimento de longo prazo, documentos, viabilidade |
| 5.4 Indenização em atraso | período, valor estimado, impacto, viabilidade |

**Cenários incrementais.** Aqui os cenários não são regras alternativas, são camadas:
sem reconhecimentos · com atividade especial · com especial e rural · aposentadoria
especial. O quadro de cada um é `Data prevista · Idade na data · RMI estimada` — sem
as colunas de payback do nível 2, que migram para a análise financeira.

Acrescenta ainda **comparativo final** entre todos os cenários e **serviços jurídicos
indicados**, com motivo, urgência e benefício esperado por serviço.

---

## As notas internas

Os templates 2 e 3 contêm parágrafos começando por `Nota interna:`. Eles instruem
quem monta o documento e **nunca podem chegar ao cliente**. Remova todos com
`DEL_PARA`, e remova as subseções que eles mandam remover com `DEL_ATE`.

Um exemplo do nível 3, na seção 3:

> Nota interna: as subseções 3.2, 3.3, 3.4 e 3.5 devem constar no planejamento
> apenas quando aplicáveis ao caso concreto. Ex.: se o caso envolve apenas
> reconhecimento de atividade especial, remova as subseções 3.3 (rural), 3.4 (PCD)
> e 3.5 (indenização) antes de enviar ao cliente.

Registre no documento de trabalho cada remoção e o motivo. É o que permite conferir
depois que a subseção saiu porque não se aplicava, e não por descuido.

---

## Ordem das diretivas, na prática

O script `preencher-template.ps1` explica a mecânica. O que importa aqui:

1. **Duplique primeiro** todas as linhas de tabela e blocos de cenário.
2. **Depois preencha e apague na ordem do documento**, de cima para baixo.

O erro que essa ordem evita: se o Cenário 2 vai ser removido e ele contém `[DATA]`,
apagá-lo só no fim faz o `SET` do `[DATA]` do rodapé acertar o cenário condenado, e
o rodapé fica em branco. Apague a seção ao chegar nela.

Ao terminar, o script lista os campos entre colchetes que sobraram. **Nenhum pode
sobrar.** Campo em colchetes chegando ao cliente é erro visível na primeira leitura.
