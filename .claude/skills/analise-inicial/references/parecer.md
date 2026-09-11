# Parecer de atendimento

Etapa **opcional**, depois que a ficha e o documento de trabalho estão gravados na
pasta do cliente. É o documento que vai para o cliente após a reunião inicial.

## Quando e o que perguntar

Terminada a gravação, pergunte com `AskUserQuestion`: **há interesse em elaborar o
parecer de atendimento para enviar ao cliente?**

**Não** → a análise termina aqui. Não gere nada.

**Sim** → pergunte, nesta ordem:

1. **Quem é o especialista responsável pelo atendimento.** As opções são os nomes do
   quadro da equipe no próprio modelo (hoje sete). `AskUserQuestion` aceita no
   máximo quatro opções, então pergunte **em texto**, com a lista numerada.
2. **Data da reunião.**
3. **Resumo do que o cliente relatou na reunião** — atividade exercida, histórico de
   saúde ou de acidente, o que ele contou sobre o próprio tempo de contribuição.
4. **Data limite para o cliente enviar os documentos.**

Os itens 2 a 4 **se perguntam, não se deduzem**. A análise inicial lê documentos,
não a reunião. As pastas `TRANSCRIÇÕES DE REUNIÕES` guardam arquivos `.gdoc`, que
são atalhos do Google Docs e **não abrem pelo disco** — o nome traz a data, o
conteúdo não. Montar o "resumo do relato" a partir dos documentos colocaria na boca
do cliente coisas que ele não disse.

No mesmo bloco, confirme o **benefício analisado** que você vai informar na seção 3.

## Modelo

```
H:/Drives compartilhados/CBA/EQUIPE/LARISSA MARGHOTI DOS SANTOS/4 - JURÍDICO/CLOSER_PARECER_DE_ATENDIMENTO_v2.docx
```

**Leia o modelo antes de montar as diretivas.** O quadro da equipe e os textos fixos
mudam quando a equipe muda. O que está aqui descreve o modelo em 11/09/2026.

O modelo marca cada seção com uma caixa: **🟢 CONTEÚDO FIXO — não alterar** ou
**🟠 CAMPO CUSTOMIZÁVEL — preencher por caso**. O que está sob 🟢 fica exatamente
como está. As próprias caixas são instrução de montagem e **nunca chegam ao cliente**.

## Fotos

Banco de imagens: `H:/Drives compartilhados/CBA/EQUIPE/0 - BANCO DE IMAGENS/`

| Nome no quadro | Cargo | Foto |
|---|---|---|
| Cristhiane Barreto | Advogada Previdenciária | `CRISTHIANE BARRETO.jpg` |
| Larissa Marghoti dos Santos | Advogada Previdenciária | `JURÍDICO/LARISSA MARGHOTI DOS SANTOS.JPG` |
| Jaqueline Pereira | Especialista Previdenciária | `JURÍDICO/JAQUELINE PEREIRA CRIVELLENTI.png` |
| Stephanie Lacerda | Especialista Previdenciária | `COMERCIAL, MARKETING E CS/Stephanie Lacerda.ARW` — **não abre** |
| Jéssica Sutil | Especialista Previdenciária | `CONTROLADORIA/JESSICA SUTIL DE OLIVEIRA.JPG` |
| Dayane de Oliveira Santos | Especialista Previdenciária | `COMERCIAL, MARKETING E CS/Dayane O Santos.png` |
| Igor Feitosa Magalhães | Especialista Previdenciária | `COMERCIAL, MARKETING E CS/IGOR.jpeg` |

Os nomes dos arquivos não batem com os do quadro, daí a tabela. O cargo vem do
quadro do modelo, não desta tabela — se divergirem, vale o modelo.

A foto da **Stephanie está em `.ARW`**, formato bruto de câmera, que nada nesta
máquina abre. Enquanto não houver JPG ou PNG no banco, gere o parecer **sem a foto**
e avise na entrega. O mesmo vale para qualquer foto ausente ou que não abra: o
parecer nunca deixa de sair por causa da foto, e a ausência nunca fica em silêncio.

As fotos entram com **3,5 cm** de largura, que cabe na célula de 2400 dxa do modelo.
O script reduz para 800 px e regrava em JPEG — a da Cristhiane tem 10 MB crua.

## O que fica, o que sai, o que se preenche

| Seção | Tratamento |
|---|---|
| Abertura | sai a caixa 🟢 e o parágrafo "Este arquivo é o MODELO PADRÃO…" |
| 1. Sobre o Escritório | fixo; sai a caixa; entra a foto da Cristhiane |
| 2. Seu Especialista | **o quadro da equipe fica** (decisão do escritório); sai só o parágrafo de instrução "Equipe de referência…" |
| 2.2 Especialista responsável | sai a caixa 🟠; foto, nome e cargo do especialista |
| 3. Resumo do Seu Caso | sai a caixa; seis campos, abaixo |
| 4. Parecer Técnico Preliminar | sai a caixa; conclusão, regra, prazo e duas listas |
| Nota importante | fixa; sai a caixa 🟢 que a antecede |
| 5. Documentos Necessários | sai a caixa e o parágrafo "Selecione, no envio ao cliente…"; ficam só duas colunas do checklist |
| 6. Próximos Passos | sai a caixa; data limite |
| 7. Fale com a Gente | fixo; sai a caixa |

### Seção 3

| Campo | Origem |
|---|---|
| Nome completo | CNIS ou dados cadastrais |
| Data da reunião | **perguntada** |
| Benefício analisado | da análise, uma das opções do modelo: Aposentadoria · Auxílio-Acidente · Benefício por Incapacidade · BPC-LOAS · Planejamento Previdenciário · Regularização de CNIS |
| Situação contributiva atual | do CNIS, em linguagem simples: "sem vínculo de emprego desde agosto de 2023", não "Seq. 08 encerrado em 30/08/2023" |
| Tempo de contribuição estimado | da análise, **aproximado**: "aproximadamente 3 anos e 8 meses" |
| Resumo dos fatos relatados | **perguntado**; ajuste só a redação, sem acrescentar fato |

### Seção 4 — linguagem do cliente

O próprio modelo dá as regras, e elas valem:

- **Conclusão em 2 a 3 frases, sem termos técnicos**: se o cliente reúne ou está
  perto de reunir os requisitos, e o próximo passo.
- **Sem RMI e sem nome técnico de regra.** "Aposentadoria por idade", não
  "transição por pontos do art. 15 da EC 103". Isso é do planejamento, serviço
  contratado à parte.
- **Prazo aproximado, sem data exata**: "faltam aproximadamente 11 anos".
- **Sem siglas do CNIS** — nada de PEXT, DII, DCB, QS.

As listas de pontos favoráveis e de atenção saem do documento de trabalho, com uma
regra: **o que estiver etiquetado como controvertido nunca é ponto favorável.** Vai
para atenção, ou fica de fora. Nenhuma frase pode soar como promessa de resultado.

### Seção 5 — qual checklist fica

Fica sempre **"Comum a todos os casos"** e mais a coluna do benefício analisado. As
outras duas saem com `DEL_COLUNA`.

| Benefício analisado | Coluna que fica |
|---|---|
| Benefício por Incapacidade · Auxílio-Acidente | Benefício por Incapacidade / Auxílio-Acidente |
| Aposentadoria · Planejamento Previdenciário | Aposentadoria / Planejamento |
| BPC-LOAS | BPC/LOAS |
| Regularização de CNIS | Aposentadoria / Planejamento — **não há coluna própria**; avise que foi a escolha mais próxima |

## Saída

```
<pasta do cliente>/ANÁLISE INICIAL/PARECER DE ATENDIMENTO - <NOME DO CLIENTE>.docx
<pasta do cliente>/ANÁLISE INICIAL/PARECER DE ATENDIMENTO - <NOME DO CLIENTE>.pdf
```

O PDF é o que vai ao cliente; o `.docx` fica para ajustes. Nunca sobrescreva um
parecer existente sem mostrar antes o que muda.

## Diretivas

Preencha com `$BASE/scripts/preencher-template.ps1` e exporte com
`$BASE/scripts/exportar-pdf.ps1`. Receita testada, na ordem do documento:

```
# abertura
DEL_ATE|CONTEÚDO FIXO|CONTEÚDO FIXO
DEL_PARA|Este arquivo é o MODELO PADRÃO

# 1. sobre o escritório
DEL_ATE|CONTEÚDO FIXO|CONTEÚDO FIXO
IMAGEM|FOTOCristhiane|H:/Drives compartilhados/CBA/EQUIPE/0 - BANCO DE IMAGENS/CRISTHIANE BARRETO.jpg|3,5

# 2. seu especialista — o quadro fica
DEL_PARA|Equipe de referência
DEL_ATE|CAMPO CUSTOMIZÁVEL|CAMPO CUSTOMIZÁVEL
IMAGEM|[FOTO DOESPECIALISTA]|<caminho da foto>|3,5
SET_COLCHETE|[NOME — selecionar|<nome como no quadro>
SET_COLCHETE|[CARGO — copiar|<cargo como no quadro>

# 3. resumo do caso
DEL_ATE|CAMPO CUSTOMIZÁVEL|CAMPO CUSTOMIZÁVEL
SET_COLCHETE|[NOME DO CLIENTE]|<nome>
SET_COLCHETE|[DD/MM/AAAA]|<data da reunião>
SET_COLCHETE|[Selecionar:|<benefício>
SET_COLCHETE|[Ex.: CLT ativo|<situação contributiva>
SET_COLCHETE|[TEMPO DE CONTRIBUIÇÃO|<tempo aproximado>
SET_COLCHETE|[Síntese objetiva|<resumo do relato>

# 4. parecer técnico preliminar
DEL_ATE|CAMPO CUSTOMIZÁVEL|CAMPO CUSTOMIZÁVEL
SET_COLCHETE|[Em 2 a 3 frases|<conclusão>
SET_COLCHETE|[nome da regra em linguagem simples|<regra>
SET_COLCHETE|[aproximado|<prazo aproximado>
DUP_BLOCO|[Listar, em linguagem clara|[Listar, em linguagem clara|<n>
SET_COLCHETE|[Listar, em linguagem clara|<ponto favorável 1>
...
DUP_BLOCO|[Listar, com transparência|[Listar, com transparência|<n>
SET_COLCHETE|[Listar, com transparência|<ponto de atenção 1>
...

# nota importante e 5. documentos
DEL_ATE|CONTEÚDO FIXO|CONTEÚDO FIXO
DEL_ATE|CONTEÚDO FIXO|CONTEÚDO FIXO
DEL_PARA|Selecione, no envio ao cliente
DEL_COLUNA|<cabeçalho de uma coluna que sai>
DEL_COLUNA|<cabeçalho da outra coluna que sai>

# 6. próximos passos
DEL_ATE|CAMPO CUSTOMIZÁVEL|CAMPO CUSTOMIZÁVEL
SET_COLCHETE|[DATA LIMITE]|<data>

# 7. fale com a gente
DEL_ATE|CONTEÚDO FIXO|CONTEÚDO FIXO
```

**Sem foto do especialista** — no lugar da linha `IMAGEM` do item 2, use
`SET_PARA|[FOTO DOESPECIALISTA]|` (com o terceiro campo vazio), que deixa a célula em
branco sem sobrar colchete.

## Conferência antes de entregar

O script avisa campo entre colchetes que sobrou, mas não vê **texto no lugar
errado**. Depois de gerar, extraia o texto e confira duas coisas:

- a **primeira linha** do documento é `CRISTHIANE BARRETO`;
- cada lista da seção 4 tem seus itens **logo abaixo do título**.

Um defeito de duplicação já mandou itens de lista para o topo da página 1, sem
nenhum aviso. Foi corrigido, mas a conferência custa uma linha e pega a próxima
surpresa do mesmo tipo.
