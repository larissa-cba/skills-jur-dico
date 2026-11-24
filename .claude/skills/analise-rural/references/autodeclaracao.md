# Autodeclaração para envio ao cliente

Quando a análise conclui que **já temos os documentos mínimos para o requerimento**,
a skill pergunta se deve emitir a autodeclaração de segurado especial. Se a resposta
for sim, preenche o formulário oficial com o que a pasta comprova e lista, campo a
campo, o que ficou em branco por falta de informação precisa.

O formulário vai **ao cliente**, que confere, completa, assina em todas as páginas e
devolve. A skill **não assina, não data e não protocola**.

## 1. Documentos mínimos — quando oferecer

O requerimento é **administrativo**, então a régua é a do INSS
(`$BASE/references/segurado-especial.md`, seção 6), somada ao enquadramento. Há
documentos mínimos quando **todas** as condições valem para os trechos que o
benefício pretendido usa (o melhor cenário do Previus, ou o que a equipe indicar na
parada):

1. **Enquadramento** — nenhum desses trechos está como **não se enquadra**.
2. **Exigência do Ofício 46, item 6.1, para o benefício:**
   - aposentadoria por idade rural: ao menos **um instrumento contemporâneo para cada
     metade da carência**;
   - aposentadoria híbrida, por tempo de contribuição ou CTC: ao menos **um instrumento
     contemporâneo para cada período** a ser computado;
   - demais benefícios: ao menos **um instrumento anterior ao fato gerador**.
   "Instrumento" é documento de grau **forte**, ou dois **depende de mais documentos**
   que se completam, conforme `graduacao.md`.
3. **Retorno ao rural** — se houve urbano intercalado acima de 120 dias no ano civil,
   há instrumento para **cada retorno** (IN 128, art. 116, § 2º, V).
4. **Titular do documento** era segurado especial na data dele (art. 116, § 2º, IV).

**Testemunhas não entram nesta régua.** No INSS não há mais entrevista rural nem
depoimento de vizinhos (Ofício 46, item 2.5). Trecho que está **depende de mais
documentos** só por falta de conversa sobre testemunhas cumpre a régua
administrativa; a conversa continua sendo providência para a eventual fase judicial.

Se faltar algo, **não ofereça** a autodeclaração: diga na segunda parada qual
condição falhou, para qual trecho, e o que falta pedir. Se a equipe pedir mesmo
assim, emita e registre que foi emitida **sem os documentos mínimos**.

Atividade rural e pesca no mesmo caso: um formulário para cada, cada um com os
períodos da sua atividade.

## 2. Qual formulário

Os formulários do acervo — Anexo I (rural) e Anexo II (pescador) do Ofício-Circular
46/DIRBEN — são os que a skill preenche; o mapa dos campos está em
`$BASE/references/autodeclaracao-campos.md`.

As versões vigentes estão na IN 128 (Anexos VIII e IX), em texto, sem campos
preenchíveis no acervo. O conteúdo é o mesmo. Registre no controle qual versão foi
usada; se o INSS exigir a da IN 128, a equipe transcreve o que a skill preencheu.

## 3. De onde vem cada dado

Preencha **só com o que um documento da pasta diz**. Cada valor gravado tem uma
fonte, que vai para a lista de conferência (seção 5).

| Bloco | Fontes |
|---|---|
| Dados do segurado | documento de identidade, CNH, CNIS (nome, nascimento), certidão de nascimento (local de nascimento), comprovante de residência recente, ficha da análise inicial |
| Períodos | trechos do mapa de cobertura **que se enquadram** — datas exatas do início e do fim; condição no imóvel ou na embarcação pelo passo de enquadramento |
| Individual × economia familiar | conclusão do enquadramento do trecho |
| Titular × componente na data do requerimento | só se o grupo atual e o responsável pela exploração estiverem claros nos documentos (DAP/CAF, notas em nome de quem, contrato) |
| Grupo familiar | certidões de nascimento e casamento, documentos dos membros, CNIS dos membros, autodeclaração ou DAP anteriores — membros do grupo **atual**, pela IN 128, art. 109, § 1º |
| Cessão da terra | contratos de arrendamento, parceria, meação ou comodato **em que o cliente é o cedente** |
| Dados das terras | CCIR, ITR/DIAC/DIAT, matrícula, escritura, contrato — número do ITR, nome do imóvel, município, área total |
| Atividade e destinação | notas de produtor, notas de entrada, DAP, declarações de IR com renda rural |
| Embarcação (pesca) | registro na Capitania, título de inscrição, contrato, RGP — condição, arqueação bruta, titular |
| IPI, empregados, outras rendas, cooperativa | CNIS do cliente e do grupo (vínculos, contribuições, benefícios), notas fiscais, fichas de cooperativa |

## 4. Regras de preenchimento

**Na dúvida, em branco.** Valor errado numa declaração assinada sob as penas do
art. 299 do Código Penal é pior do que campo vazio. Cada campo em branco vira uma
pergunta para o cliente.

- **Datas** no formato `DD/MM/AAAA`. Se o documento só dá o ano ou o mês, **não
  complete com dia ou mês inventado**: deixe em branco e leve para a lista o que se
  sabe ("documentos indicam início em 1976").
- **Períodos** só dos trechos que se enquadram. Trecho **fraco** ou que **não se
  enquadra** não entra na autodeclaração — diga isso na lista, para a equipe decidir.
- **Perguntas de sim/não** sobre fatos que só o cliente conhece (empregados, outras
  rendas, turismo, artesanato, cooperativa, IPI): marque **sim** quando um documento
  mostrar o fato, e preencha a linha da tabela. **Não marque "não"** só porque a
  pasta não mostra nada — deixe as duas caixas em branco e pergunte. Exceção: se o
  cliente já respondeu por escrito (autodeclaração anterior, ficha de atendimento),
  use a resposta e cite a fonte.
- **Vínculos do CNIS** que caem nos períodos declarados vão para "outra atividade ou
  renda", com local e período, **mesmo quando não descaracterizam** — o INSS vai ver
  no CNIS de qualquer forma, e a omissão pesa contra o cliente.
- **Grupo familiar**: só quem integra o grupo pela IN 128 na data do requerimento.
  CPF de membro só se estiver em documento da pasta.
- **Área explorada pelo requerente** quase nunca está em documento: deixe em branco.
- **Local e data** do fecho, **assinatura** e **polegar**: sempre em branco.
- Não escreva observação, ressalva ou texto fora dos campos.

## 5. Gravação

1. Monte o JSON com os nomes técnicos de `autodeclaracao-campos.md` na pasta de
   trabalho temporária, nunca na pasta do cliente.
2. Preencha:

   ```bash
   powershell -ExecutionPolicy Bypass -File "$BASE/scripts/preencher-pdf-form.ps1" -Origem "<formulário do acervo>" -Valores "<pasta de trabalho>/autodeclaracao.json" -Destino "<destino.pdf>"
   ```

3. **Confira o resultado**: renderize as páginas com `pdftoppm` e olhe cada uma.
   Valor no campo errado não dá erro — só aparece na imagem. (O poppler desta máquina
   não desenha o "x" das caixas de seleção, por falta da fonte ZapfDingbats; confira
   as caixas pelo `listar-campos-pdf.ps1`, coluna `valor`.)
4. Gere a **lista de pendências para o cliente** como `.docx` (`gerar-docx.ps1`).

| Arquivo | Destino |
|---|---|
| Formulário rural | `<pasta do cliente>/ANÁLISE INICIAL/AUTODECLARAÇÃO RURAL - <NOME>.pdf` |
| Formulário do pescador | `<pasta do cliente>/ANÁLISE INICIAL/AUTODECLARAÇÃO PESCADOR - <NOME>.pdf` |
| Pendências | `<pasta do cliente>/ANÁLISE INICIAL/AUTODECLARAÇÃO - PENDÊNCIAS - <NOME>.docx` |

Se já existir autodeclaração com esse nome na pasta, **não sobrescreva** — pode ser a
versão que o cliente devolveu preenchida. Grave com a data no nome
(`AUTODECLARAÇÃO RURAL - <NOME> - DD.MM.AAAA.pdf`) e avise.

### Lista de pendências

Documento curto, em linguagem para o cliente — sem sigla, sem número de campo
técnico. Uma linha por campo em branco, na ordem do formulário:

```
AUTODECLARAÇÃO DE SEGURADO ESPECIAL — O QUE FALTA PREENCHER
<NOME DO CLIENTE>

Preenchemos o formulário com as informações dos documentos que você nos enviou.
Confira tudo, complete os itens abaixo, assine em todas as páginas e nos devolva.

|Item do formulário|O que precisamos saber|O que já sabemos|
|---|---|---|
|1. Apelido|Você tem apelido? Qual?|—|
|2. Período de atividade rural, linha 1|Dia e mês em que começou a trabalhar na roça com a família|Os documentos indicam 1976|
|3.1. Área explorada|Quantos hectares do sítio a família plantava ou criava|O sítio tem 12,1 ha (CCIR)|
|3.4. Empregados|Vocês tiveram empregado ou pagaram alguém para ajudar? Quem e quando?|—|
|4. Outra atividade ou renda|Teve algum outro trabalho ou renda além da roça? Qual, onde e quando?|O CNIS mostra vínculo de 03/1995 a 05/1995, já preenchido|
```

E, ao final, para a equipe (não vai ao cliente — fica só no controle):

```
Conferência interna — fonte de cada campo preenchido:
- Nome, nascimento: RG (D02).
- Período 1: 12/03/1976 a 31/12/1985 — mapa de cobertura, trecho 1; início pela certidão de nascimento (D02) e idade adotada no Previus.
- Imóvel 1: CCIR 2003 (D09).
```

## 6. Registro no controle

No arquivo de controle, seção **Autodeclaração**: data de emissão, formulário e
versão usados, se os documentos mínimos estavam cumpridos, a conferência interna
(fonte de cada campo) e a lista de pendências. Acrescente a linha ao histórico
(`autodeclaração rural emitida; 9 campos pendentes`). Quando a autodeclaração voltar
assinada e chegar à pasta, a próxima rodada a inventaria como documento do próprio
cliente — **fonte das alegações, não prova material** — e confere se o que o cliente
completou bate com os documentos.
