# Os três níveis

Os três níveis não mudaram de conteúdo com a troca de formato — continuam
sendo profundidade de análise, decisão comercial, não técnica (ver
`SKILL.md`). O que muda é como cada nível vira slides e páginas: os dois
documentos de referência do escritório (a apresentação e o relatório da
Marilda) são um caso de **nível 3 completo**, com todas as seções condicionais
presentes. Este arquivo descreve o que entra e o que sai em cada nível, em
termos do catálogo de blocos de `design-sistema.md`.

**Leia o catálogo de blocos antes deste arquivo.** Aqui só se diz *quais*
blocos aparecem em cada nível — a doutrina de cada bloco (classe CSS, quando
usar) está em `design-sistema.md`.

---

## Nível 1 — Diagnóstico

Retrato da situação atual. **Não contempla estratégia de contribuição
futura** — não prometa simulação de cenário com contribuição projetada
neste nível.

**Apresentação**: capa · situação de hoje (`.linha-stats`) · situação
previdenciária atual (par de cartões `.cartao`, tempo de contribuição e
carência) · plano de correção do CNIS, se houver pendência (`.grade.col3`
ou tabela `table.dados`) · cenário(s) de aposentadoria **com o que já
existe**, sem nova contribuição — um `.numerado4` ou um slide por cenário
com `.simulacoes` contendo só a base atual · encerramento (disclaimer +
assinatura).

**Relatório**: mesma ordem, em prosa. Sem a seção "Os N caminhos possíveis"
com múltiplas bases de contribuição — o relatório do nível 1 descreve um
único caminho, o que já existe.

---

## Nível 2 — Completo

Acrescenta ao nível 1:

**Documentos analisados e pendentes** — bloco de duas colunas (uma clara,
uma escura) listando o que foi analisado e o que falta, espelhando o
balanço de cobertura do documento de trabalho.

**Síntese da vida contributiva** — `table.dados`/`table.relatorio` com
`Período · Empresa/Atividade · Categoria · Situação no CNIS`, uma linha por
vínculo, com `tr.realce` nos vínculos com pendência.

**Pendências por gravidade** — bloco de duas colunas classificando em
`leves` (monitorar), `relevantes` (alteram tempo, carência, RMI ou data) e,
se houver, `críticas` (podem gerar indeferimento ou exigir ação
administrativa ou judicial). Se o caso tiver pendência crítica, dê a ela um
bloco próprio (`.cartao verde` ou `.destaque-caixa`) em vez de escondê-la na
lista — é o que o exemplo do escritório faz com o vínculo ausente do CNIS.

**Cenários com simulação de contribuição futura** — um slide por cenário
(`.simulacoes`), cada um com uma ou mais simulações (S1.1, S1.2...). Por
simulação: base salarial, alíquota e código GPS, RMI, valor investido,
retorno projetado e payback. No nível 2 os cenários são **regras
alternativas** — cada um é um caminho diferente de aposentadoria, não uma
camada incremental sobre o anterior.

**Comparativo financeiro** (`table.dados`/`table.relatorio`) e
**comparativo final** com a linha `tr.recomendado` — mesma lógica dos dois
documentos de referência.

**Recomendação técnica** (`.rec-tecnica`) e **providências de cada parte**
(`.grade.col2`, cartão claro + cartão verde).

---

## Nível 3 — Completo com reconhecimento de direitos

Parte do nível 2 e acrescenta reconhecimento de direitos específicos —
exatamente o que os dois documentos de referência do escritório mostram.

**Documentos analisados** fica granular quando o caso pedir: previdenciários
e trabalhistas · atividade especial · rurais · PCD · indenização de
contribuições em atraso · não apresentados. Só entram as subseções que o
caso tiver — não force uma coluna vazia.

**Reconhecimento de direitos específicos**, um bloco de duas colunas
(`.col2`, texto + `.cartao cinza` de "serviço indicado") por direito
aplicável:

| Direito | O bloco traz |
|---|---|
| Atividade especial | período/agente/documento, viabilidade, serviço indicado |
| Período rural | período, início de prova material, viabilidade, serviço indicado |
| PCD | indícios de impedimento de longo prazo, documentos médicos, condição para compensar |
| Indenização de contribuições em atraso | período, valor estimado (`.grade.col2` com 2 cartões de valor + 2 cartões de explicação, como no exemplo), efeito no coeficiente |

**Cenários incrementais.** Aqui os cenários não são regras alternativas, são
**camadas**: sem reconhecimentos · com um reconhecimento · com mais de um ·
via alternativa (ex.: PCD). Cada `.numerado4`/`.simulacoes` mostra o efeito
de uma camada a mais sobre data e valor — não misture com a lógica de
"regras alternativas" do nível 2.

**Comparativo final entre todos os cenários** e **serviços jurídicos
indicados** (`table.dados`/`table.relatorio` com motivo, urgência e
benefício esperado por serviço) — última seção de conteúdo antes de
providências e encerramento.

---

## Quando a atividade rural não vira seção própria

O período rural só ocupa um bloco de "reconhecimento de direito" quando se
trata de **acréscimo** de tempo não registrado. Quando os vínculos rurais
já constam do CNIS, o que se discute é **conversão de tempo comum em
especial por enquadramento de categoria profissional** — isso entra na
tabela de atividade especial, com o agente informado como "enquadramento
por categoria", não em bloco próprio. Ver
`../previdenciario-base/references/rural.md`, que distingue os dois usos.

## Quando há RPPS

Havendo CTC, ficha financeira, mapa de tempo de serviço ou cálculo de
regime próprio, o caso tem RPPS. A apresentação e o relatório, como os
documentos de referência, só tratam do RGPS.

Monte o RGPS normalmente e **registre a limitação** no documento de trabalho
e na entrega: quais arquivos de RPPS existem, o que eles indicariam, e que
os cenários do regime próprio ficaram de fora. Não force um bloco de RPPS
no meio dos slides — o documento passaria a contradizer a própria abertura
("segurada vinculada ao RGPS").
