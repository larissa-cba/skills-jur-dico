# Contrato, fase e perícia

A mesma pilha de documentos médicos vale coisas diferentes conforme o que foi
contratado e o momento do processo. Um prontuário de dez anos é ouro antes do
protocolo de uma aposentadoria PcD e quase nada num recurso de auxílio por
incapacidade temporária cuja DII é de três meses atrás. Por isso esta etapa vem
antes da leitura.

## 1. Contrato

### No Advbox

O **tipo** do processo é o serviço contratado. Grupos que interessam a esta skill:

| Grupo no Advbox | Tipos (exemplos) | Benefício a testar |
|---|---|---|
| `2.2 - BENEFÍCIO POR INCAPACIDADE` | `2.2.01 – BENEFÍCIO POR INCAPACIDADE TEMPORÁRIA`, `2.2.04 – … PERMANENTE`, `2.2.05 – BI PERM. + ACRÉSCIMO 25%`, `2.2.06 – BI TEMP. – ATESTMED`, `2.2.07 – PRORROGAÇÃO…`, `2.2.12 - BI TEMP. ACIDENTÁRIO` | incapacidade (seção 2 de `beneficios.md`) |
| `2.2` com auxílio-acidente | `2.2.03 – BI TEMP. + AUXÍLIO-ACIDENTE`, `2.2.08 – BI TEMP. + AA + NOMOS` | incapacidade **e** auxílio-acidente |
| `2.3 - AUXÍLIO ACIDENTE` | `2.3.01 – AUXÍLIO-ACIDENTE`, `2.3.02 – … + NOMOS` | auxílio-acidente (seção 4) |
| `2.4 - BENEFÍCIOS ASSISTENCIAIS` | `2.4.01 – BPC/LOAS IDOSO/DEFICIÊNCIA` | BPC da pessoa com deficiência (seção 3) — se for BPC **idoso**, não há o que provar com documento médico: diga isso e pare |
| `2.1 - APOSENTADORIAS` | `2.1.09 – APOSENTADORIA PCD POR IDADE`, `2.1.10 – … POR TEMPO DE CONTRIBUIÇÃO`, `2.1.11` e `2.1.12` (`+ NOMOS`), `2.16--PCD + NOMOS` | aposentadoria PcD (seção 5) |
| `2.8 - PREVIDENCIÁRIO - RPPS` | `2.8.09 - AP PCD` | aposentadoria PcD em regime próprio — avise que o acervo não tem a norma do ente; a análise médica vale, a conferência legal fica pendente |
| `4 - PARCERIA - SHANASIS` | `4.01 - A.A`, `4.07 - B.I`, `4.08 - BPC - LOAS`, `4.12 - INVALIDEZ`, `4.15 - PCD` | conforme o tipo |

`+ NOMOS` no tipo indica atuação de assistente técnico em perícia (há também a
tarefa `SOLICITAR ATUAÇÃO DA NOMOS PERÍCIAS`). Registre: muda quem precisa receber
os documentos antes da perícia.

Tipos `PRÉ ANÁLISE`, `ANÁLISE INICIAL` e `1º ATENDIMENTO` ainda não são o serviço
final: o contrato pode não estar fechado. Diga isso e use o benefício que a ficha da
análise inicial ou as anotações apontam, perguntando na primeira parada.

### As anotações do processo

O campo de anotações do processo (`-Acao processo`) costuma trazer a **análise
inicial** inteira colada — benefícios anteriores, NBs, DII, o que a perícia do INSS
disse — e o retorno do atendimento. Leia: é contexto, mas não é prova.

### Na pasta

Procure o **contrato de honorários** (costuma estar em `DOCUMENTOS PESSOAIS`,
`CONTRATO` ou solto na raiz, às vezes junto da procuração). Leia a cláusula do
**objeto**. Registre:

- objeto do contrato, em uma linha;
- se confere com o tipo do Advbox;
- se o contrato prevê **mais de um benefício** (ex.: incapacidade e, sucessivamente,
  auxílio-acidente) — então a análise testa os dois.

Contrato não encontrado: registre `contrato não localizado na pasta` e siga com o
Advbox. Não transcreva valores de honorários na análise.

## 2. Fase

`-Acao processos` e `-Acao processo` devolvem **etapa** (`step`) e **fase**
(`stage`). As etapas do escritório e o que significam para a prova médica:

| Etapa | Fases típicas | Momento da prova |
|---|---|---|
| `NEGOCIAÇÃO` | contato inicial, proposta, contrato em elaboração ou pendente de assinatura, levantamento de documentos para análise | **pré-contratação** — a prova serve para decidir se o caso é viável |
| `CONSULTORIA` | levantamento de documentos para análise ou para processo, peça em elaboração, para protocolo | **pré-protocolo** — "basta para dar sequência?" |
| `ADMINISTRATIVO` antes da decisão | `PARA PROTOCOLO`, `TRIAGEM PARA INÍCIO`, `PEDIDO INICIAL INSS - EM ANÁLISE`, `EM EXIGÊNCIA`, `AVALIAÇÃO AGENDADA` | **prova útil** — principalmente antes da perícia do INSS |
| `ADMINISTRATIVO` depois da decisão | `RESULTADO RECEBIDO`, `TRIAGEM PARA ANALISAR RESULTADO DO PROCESSO`, `PARA REABERTURA DE PROCESSO` | a prova serve para o **próximo passo** (recurso, judicial, novo requerimento) |
| `ADMINISTRATIVO` em recurso | `RECURSO ADM EM ANÁLISE` | **recursal** — só muito forte |
| `JUDICIAL` antes da perícia | `TRIAGEM PARA DAR ENTRADA NO PROCESSO`, `PEÇA EM PRODUÇÃO`, `PARA PROTOCOLO`, `AGUARDANDO ANÁLISE DO JUIZO`, `AVALIAÇÃO/AUDIÊNCIA AGENDADA` | **prova útil** — juntar antes da perícia para o perito ver |
| `JUDICIAL` depois da perícia | `AGUARDANDO LIBERAÇÃO DE LAUDO`, laudo juntado, `ANALISAR SENTENÇA` | **restrita** — só o que enfrenta o laudo em ponto decisivo |
| `RECURSAL` | `AGURDANDO ANÁLISE DO RECURSO`, `AGUARDANDO PAUTA DE JULGAMENTO`, `PEÇA EM ELABORAÇÃO` | **recursal** — só muito forte |
| `EXECUÇÃO/COBRANÇA` | atrasados, RPV, baixa | **encerrada a fase de prova** |
| `ARQUIVAMENTO` | arquivamento definitivo, desistência, futuro/resgate, serviço finalizado | **sem processo em curso** — avaliar novo requerimento |

A lista completa e atual sai de `-Acao configuracoes`. Fase nova que não está aqui:
classifique pela lógica da tabela e diga que classificou.

**"AGUARDANDO ANÁLISE DO JUIZO" não diz se já houve perícia.** Confirme com a ação
`pericia` e com as movimentações antes de enquadrar.

Leia também as **últimas movimentações** (`-Acao movimentos`): as do tribunal
(`header` = TRF04, TJSC…) mostram distribuição, perícia designada, laudo juntado,
sentença; as manuais trazem retornos de atendimento. E as **publicações**
(`-Acao publicacoes`) — intimação para manifestar sobre laudo, por exemplo, abre
prazo em que um documento novo pode entrar com a manifestação.

## 3. Perícia

A ação `pericia` devolve só o que menciona perícia, perito, laudo, avaliação social,
audiência ou assistente técnico, de cinco fontes: fase atual, histórico, tarefas
pendentes, movimentações e publicações. Tarefas do escritório que indicam perícia:

| Tarefa | Indica |
|---|---|
| `AGENDAR PERÍCIA`, `AGENDAR AVALIAÇÃO` | perícia ainda a marcar |
| `AVISAR CLIENTE DA PERÍCIA - ADM` / `- JUD` | perícia **agendada** (data na tarefa) |
| `AVISAR CLIENTE DA AVALIAÇÃO SOCIAL - ADM` / `- JUD`, `REPASSAR ORIENTAÇÕES AV. SOCIAL` | avaliação social agendada (BPC, PcD) |
| `ACOMPANHAR CUMP. DE PRAZO DE PERITO` | perícia **realizada**, laudo pendente |
| `ANALISAR LAUDO PERICIAL`, `EMITIR RESULTADO DE PERÍCIA`, `INFORMAR RESULTADO DE AVALIAÇÃO` | **laudo disponível** |
| `SOLICITAR ATUAÇÃO DA NOMOS PERÍCIAS` | assistente técnico acionado |

Registre uma de quatro situações, com a data e a fonte:

- **não houve perícia** neste processo;
- **perícia agendada** em DD/MM/AAAA (administrativa ou judicial);
- **perícia realizada, laudo pendente**;
- **laudo disponível** — procure-o na pasta (`PROCESSO JUDICIAL/`, `PROCESSO ADM/`,
  ou entre os PDFs do processo) e **leia por inteiro**. Se não estiver na pasta,
  vira o primeiro pedido: `baixar o laudo pericial do processo <número>`.

Perícia agendada muda a urgência: os documentos que faltam precisam chegar **antes
da data**, e o cliente precisa levá-los. Diga quantos dias faltam.

## 4. Régua de juntada

| Momento (seção 2) | Conjunto suficiente | Conjunto com ressalvas | Conjunto insuficiente |
|---|---|---|---|
| pré-contratação / pré-protocolo | **dar sequência** | **dar sequência** e pedir o que falta em paralelo | **não dar sequência ainda** — pedir antes |
| prova útil (adm. ou judicial antes da perícia ou decisão) | **juntar** | **juntar** e pedir o que falta | **juntar** o que acrescenta e pedir com urgência; diga o risco |
| depois da decisão administrativa | levar para o próximo passo (recurso, judicial, novo requerimento) — diga qual | idem | diga se o próximo passo é viável com esta prova |
| depois da perícia judicial | **juntar só se muito forte** e se enfrenta o laudo em ponto decisivo | idem | **não juntar** |
| recursal (administrativo ou judicial) | **juntar só se muito forte** | **juntar só se muito forte** | **não juntar** |
| execução / arquivamento | **não juntar** — diga se cabe **novo requerimento** (agravamento, fato novo) | idem | idem |

A recomendação é **do documento novo**, não do conjunto inteiro: num processo em
curso, o que interessa é se **o que chegou agora** acrescenta ao que já está nos
autos. Documento que repete o que já foi juntado não se junta, em fase nenhuma.

Esta régua é **critério do escritório**, não regra processual. Quando a admissão de
documento numa fase depender de regra processual (CPC, Lei 10.259, regimento de
Turma Recursal), consulte o acervo — a Lei 10.259/2001 está nele; o CPC não — e, sem
o texto, escreva que depende de conferência.

## 5. Documentação muito forte

Para fase recursal ou laudo contrário. Um documento novo é **muito forte** quando
reúne **todos**:

1. **atinge o ponto exato** em que a decisão ou o laudo negou — DII, incapacidade,
   consolidação, nexo, grau ou data de início da deficiência;
2. é **objetivo** ou **de especialista com achados descritos** — exame (imagem,
   eletroneuromiografia, audiometria, campimetria, teste neuropsicológico), laudo de
   especialista com exame físico detalhado, prontuário hospitalar, CAT;
3. é **contemporâneo** ao período discutido, ou documenta fato que não existia antes
   (agravamento, cirurgia, internação);
4. **não estava nos autos** e não repete o que estava.

Falta um: **não é muito forte**. Diga qual faltou. Agravamento posterior à decisão é
quase sempre melhor como **novo requerimento** do que como documento no recurso —
diga isso quando for o caso.
