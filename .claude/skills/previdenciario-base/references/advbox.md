# Advbox

Sistema de gestão do escritório. A API é usada **somente para leitura**: saber o
que foi contratado, em que etapa e fase está o processo, se houve perícia, e o que
diz o histórico. Nenhuma skill cria, altera ou apaga nada no Advbox.

## Acesso

- Base: `https://app.advbox.com.br/api/v1`
- Autenticação: `Authorization: Bearer <token>`
- Documentação: `https://api.softwareadvbox.com.br/docs/referencia`
- Limite: **30 GETs por minuto** por conta (HTTP 429 acima disso). Uma análise
  consome de 4 a 8 chamadas; não faça varreduras em massa.

**Token** — nunca no repositório, nunca na pasta do cliente, nunca impresso. O
script procura, nesta ordem:

1. variável de ambiente `ADVBOX_TOKEN`;
2. arquivo `%USERPROFILE%\.advbox\token` (uma linha).

Sem token, o script sai com código 3. Diga isso e siga sem o Advbox, perguntando
contrato e fase.

## Script

`scripts/advbox.ps1`, somente GET:

| Ação | Parâmetro | Devolve |
|---|---|---|
| `cliente` | `-Nome` ou `-Cpf` | clientes encontrados, com id, nascimento, profissão e processos |
| `processos` | `-ClienteId` | uma linha por processo: tipo, grupo, etapa, fase, número, protocolo, pasta, responsável |
| `processo` | `-ProcessoId` | a linha do processo, os clientes e as **anotações** (costumam trazer a análise inicial colada) |
| `historico` | `-ProcessoId` | tarefas e comentários do processo, do mais recente ao mais antigo |
| `movimentos` | `-ProcessoId` | movimentações do tribunal (`header` = tribunal) e manuais |
| `publicacoes` | `-ProcessoId` | intimações e publicações, com prazo |
| `tarefas` | `-ProcessoId` | tarefas **pendentes** do processo |
| `pericia` | `-ProcessoId` | só o que menciona perícia, perito, laudo, avaliação social, audiência ou assistente técnico, de todas as fontes acima |
| `configuracoes` | — | etapas e fases, tipos de processo, tarefas ligadas a perícia |

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/advbox.ps1" -Acao cliente -Nome "MARIA DA SILVA"
```

Busca por nome é parcial e sem distinção de maiúsculas. Homônimos: confirme por CPF
(`-Cpf`, com ou sem pontuação), lido de um documento da pasta — sem transcrevê-lo
na análise.

## O que cada campo significa no escritório

| Campo | Significado |
|---|---|
| `type` (tipo) | o **serviço contratado** — `2.2.01 – BENEFÍCIO POR INCAPACIDADE TEMPORÁRIA` |
| `group` (grupo) | a área — `2.2 - BENEFÍCIO POR INCAPACIDADE` |
| `step` (etapa) | `NEGOCIAÇÃO`, `CONSULTORIA`, `ADMINISTRATIVO`, `JUDICIAL`, `RECURSAL`, `EXECUÇÃO/COBRANÇA`, `ARQUIVAMENTO` |
| `stage` (fase) | a fase dentro da etapa — `AVALIAÇÃO AGENDADA`, `AGUARDANDO ANÁLISE DO JUIZO`… |
| `process_number` | número judicial |
| `protocol_number` | protocolo do requerimento administrativo |
| `folder` | nome da pasta/assunto dado pela equipe |
| `notes` | anotações livres: análise inicial, retorno de atendimento |
| `status_closure` | data de encerramento de uma etapa anterior — não significa processo encerrado; olhe a etapa |

O mesmo nome de fase existe em várias etapas (`PARA PROTOCOLO`, `EM ANÁLISE
INTERNA`, `PEÇA EM ELABORAÇÃO`): leia sempre **etapa + fase** juntas.

Um cliente pode ter vários processos (um por serviço). Pergunte quando houver mais
de um em curso no mesmo grupo.

## Limitações conhecidas

- O filtro `stage` de `/lawsuits` não aceitou o nome da fase com acento nos testes;
  filtre por cliente ou por tipo e leia a fase no resultado.
- `/history` e `/movements` com id inexistente devolvem vazio ou 401, não 404.
- `/posts` com `lawsuit_id` devolve só tarefas **pendentes**; as concluídas aparecem
  em `/history`.
- O tribunal não vem no processo; aparece no `header` das movimentações e no campo
  `court` das publicações.
- Não há endpoint de contrato; o objeto do contrato se lê no PDF da pasta. O
  financeiro (`/transactions`) não é usado pelas skills.

Verificado contra a conta do escritório em 24/11/2026.
