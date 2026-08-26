---
name: analise-inicial
description: Análise inicial previdenciária a partir dos documentos já baixados na pasta do cliente. Lê CNIS, pedidos administrativos, documentos médicos, PPP, documentos rurais e DTC/CTC, e gera a ficha de análise no padrão do escritório mais um documento de trabalho com as providências.
disable-model-invocation: true
---

# Análise inicial previdenciária

Executa as etapas 3 a 9 do `ROTEIRO DE ANÁLISE INICIAL` do escritório sobre os
documentos já baixados na pasta do cliente, e entrega dois arquivos.

**Não faz** a etapa 1 (baixar no Meu INSS) nem a etapa 10 (calcular no Previus):
os dois exigem login em sistema externo. Os números do Previus são lidos dos PDFs
de cálculo quando estão na pasta, e perguntados quando não estão.

## Invocação

```
/analise-inicial <caminho da pasta do cliente>
```

Reprocessamento parcial, quando chegou documento novo e não vale refazer tudo:

```
/analise-inicial <caminho> --cnis
/analise-inicial <caminho> --ppp
/analise-inicial <caminho> --medicos
/analise-inicial <caminho> --pedidos
/analise-inicial <caminho> --rural
/analise-inicial <caminho> --dtc-ctc
```

No modo parcial, releia a ficha e o documento de trabalho existentes na pasta,
refaça só a seção pedida e reescreva os dois arquivos preservando o resto.

Se o caminho não foi informado, peça-o antes de qualquer outra coisa. Não tente
adivinhar o cliente a partir do nome mencionado na conversa.

## Fluxo

### 1. Varredura

```bash
bash scripts/varrer-pasta.sh "<caminho da pasta do cliente>"
```

Varre recursivamente. É necessário: `DOCUMENTOS MEDICOS` costuma ser pasta irmã de
`ANÁLISE INICIAL`, não filha, e a nomenclatura varia entre clientes (`ANÁLISE
INICIAL`, `ANALISE INICIAL`, `PRÉ ANÁLISE`, `ANÁLISE PREVIUS`, `PROCESSO ADM`).

Classifique cada arquivo **pelo conteúdo, não pelo nome**. Nomes mentem: um arquivo
chamado `RECEITUÁRIO 22.08.2023.pdf` pode ter 24 páginas de prontuário.

### 2. Primeira parada — conferência da lista

Apresente a lista classificada por tipo de documento, indicando quais são texto e
quais precisarão ser renderizados, e **pare**. Use `AskUserQuestion` para confirmar.

Sinalize explicitamente:

- documentos que parecem ser de terceiro (parente, sócio, instituidor);
- processos judiciais de outra matéria (trabalhista, cível) — leia só se a Larissa
  mandar, porque costumam ser longos e nem sempre interessam à análise previdenciária;
- o custo dos escaneados: some as páginas dos arquivos `IMAGEM` e diga quantas são.
  Cem páginas de exame renderizadas é leitura cara e nem toda página tem valor
  previdenciário. Proponha a triagem de `references/medicos.md` e deixe ela decidir.

### 3. Leitura

#### Documentos de leitura obrigatória

Estes **nunca entram em triagem**. Se estão na pasta, são lidos por inteiro,
independente de quantas páginas tenham e de quanto custe:

| Documento | Por quê |
|---|---|
| **CNIS** | base de tudo |
| **CTPS** | sem ela não se escreve `s/ CTPS` nem `c/ CTPS` |
| **PPP** | decide o tempo especial |
| **Carta de concessão, comunicação de decisão, laudo SABI** | é o que o INSS decidiu e por quê |
| **Cálculos do Previus** | são os números da ficha |
| **DTC / CTC** | risco de contagem em duplicidade |
| **Documentos médicos**, em caso de incapacidade ou PcD | são o caso |

Ausente da pasta, cada um vira **providência** no documento de trabalho — pedir ao
cliente, baixar no Meu INSS, solicitar à empresa — e a ficha não pode usar nenhuma
anotação que dependeria dele.

A CTPS costuma estar em `DOCUMENTOS PESSOAIS`, fora da pasta de análise, escaneada e
com 30 páginas ou mais. Anotação de contrato aparece em qualquer folha, então a
leitura é integral: não dá para saber de antemão qual página traz a data de saída que
falta no CNIS.

#### Como ler

Para cada documento aprovado:

```bash
bash scripts/ler-pdf.sh "<arquivo.pdf>" "<pasta de trabalho>"
```

Sai o texto direto quando o PDF tem camada de texto. Quando é escaneado, sai uma
lista de linhas `RENDERIZADO: <caminho.png>` — abra cada PNG com a ferramenta de
leitura de imagem. Use uma pasta de trabalho no diretório temporário da sessão,
nunca dentro da pasta do cliente.

Ordem de leitura, porque cada etapa informa a seguinte:

1. **CNIS** — `references/cnis.md`
2. **Pedidos administrativos** — `references/pedidos-administrativos.md`
3. **Documentos médicos** — `references/medicos.md`
4. **PPP** — `references/ppp.md`
5. **Rurais** — `references/rural.md`
6. **DTC/CTC** — `references/dtc-ctc.md`

Carregue a referência do tipo só quando aquele tipo aparecer na pasta. Cliente sem
documento rural não precisa da seção rural.

### 4. Segunda passada no CNIS

Obrigatória, e só no CNIS. Depois de montar os bullets, **releia o extrato** e
confira cada um contra ele: número da sequência, empresa, datas, competências,
indicadores. Um `Seq.` trocado não dá erro em lugar nenhum — só contamina o cálculo.

PPP e médicos não levam segunda passada: a etiqueta de grau de segurança já expõe
a incerteza deles.

### 5. Números do Previus

Procure na pasta arquivos como `Cálculo de <NOME> (...).pdf`. São legíveis por
texto e trazem espécie do benefício, DIB, tempo de contribuição e RMI.

- **Achou**: extraia e mostre o que extraiu, cenário por cenário, para conferência.
- **Não achou**: pergunte os números com `AskUserQuestion` na parada final. Não
  invente e não deixe o bloco em branco sem avisar.

O nome entre parênteses identifica o cenário (`comum`, `c. especial correio`,
`ap. especial`, `PCD desde o acidente`, `bi perm`) e vira a linha correspondente em
`Expectativa futura`.

**Cuidado com a data de referência.** Um mesmo relatório traz vários marcos — DIB
informada, data da EC 103/2019, data da Lei 9.876/99, data de projeção — e cada um
produz um tempo de contribuição, um número de contribuições e uma idade diferentes.
Pegar o marco errado erra os três números de uma vez e não dá sinal nenhum. Diga qual
data você adotou e confirme com a Larissa na parada final.

### 6. Segunda parada — dúvidas e resultado

Reúna **todas** as dúvidas num bloco só e pergunte de uma vez. Não pare a cada
seção. O que ficar sem resposta vira linha na tabela de providências.

Três perguntas são obrigatórias nesta parada, porque não se resolvem sozinhas:

1. **Cabeçalho** — tipo de análise e quem assina. Não há padrão fixo no escritório
   (`ANÁLISE INICIAL LARI`, `PRÉ-ANÁLISE – LARI`, `ATUALIZAÇÃO PREVIUS 2025`,
   `Feito por Carolina`…). Se houver ficha anterior do cliente, sugira o cabeçalho dela.
2. **Data de referência** dos números do bloco `Possui`.
3. **Achados do CNIS que ficaram de fora da ficha** — mostre o que você classificou
   como irrelevante para a estratégia e deixou só no documento de trabalho, para ela
   confirmar que concorda.

Depois gere os dois arquivos.

## Saída

Monte cada documento como `.txt` UTF-8 com a marcação descrita em
`references/formato-ficha.md`, e converta:

```bash
powershell -ExecutionPolicy Bypass -File scripts/gerar-docx.ps1 -Origem "<entrada.txt>" -Destino "<saida.docx>"
```

**A ficha** — `references/formato-ficha.md` — vai para dois lugares:

- `<pasta do cliente>/ANÁLISE INICIAL/<NOME DO CLIENTE>.docx`
- `H:/Drives compartilhados/CBA/EQUIPE/LARISSA MARGHOTI DOS SANTOS/2 - ANÁLISES INICIAIS/<NOME DO CLIENTE>.docx`

Se a subpasta `ANÁLISE INICIAL` não existir, crie-a com esse nome exato, acentuado.

**O documento de trabalho** — `references/formato-trabalho.md` — vai só para
`<pasta do cliente>/ANÁLISE INICIAL/<NOME DO CLIENTE> - TRABALHO.docx`.

Nunca sobrescreva uma ficha existente sem antes mostrar o que vai mudar.

## Regras que não se negociam

**Nunca afirme uma regra legal de memória.** Carência, período de graça, regra de
transição, limite de ruído por época, conversão de tempo especial, prazo decadencial
— tudo isso se consulta em `references/legislacao.md` e nos PDFs da pasta de
legislação do escritório, citando o dispositivo. Sem ter lido o texto, escreva que
o ponto depende de conferência legal. Um número legal errado escrito com segurança
é o pior defeito que esta skill pode ter.

**Toda conclusão sai etiquetada** com um dos três graus, que são os do próprio
roteiro (seções 6.12 e 7.9):

| Grau | Significado |
|---|---|
| **Forte** | conjunto documental consistente sustenta a conclusão |
| **Depende de complementação** | há indícios, faltam documentos ou esclarecimentos |
| **Controvertido** | há lacuna, divergência ou obstáculo relevante |

O que cair em **controvertido** vira pergunta à Larissa, não afirmação na ficha.

**Blocos vazios saem escritos como "Não há"**, nunca omitidos. Isso distingue *não
existe* de *ninguém olhou*.

**Custo nunca justifica pular categoria de documento.** Ler cem páginas escaneadas é
caro e demorado. Isso é motivo para **parar e perguntar** o que ler — nunca para
decidir sozinho que uma categoria fica de fora. Uma análise de incapacidade sem os
documentos médicos, ou de tempo especial sem o PPP, não é análise incompleta: é
análise errada, com aparência de completa.

A triagem de `medicos.md` serve para gastar leitura onde ela rende, sempre depois de
olhar a primeira página de cada arquivo. Descartar sem abrir não é triagem.

**Nunca declare lido o que não foi lido.** `ler-pdf.sh` sai com código 4 e imprime
`!!! RENDERIZACAO INCOMPLETA` quando renderiza menos páginas do que o PDF tem — o
`H:` é Drive em streaming e interrompe no meio sem dar erro. Trate isso como leitura
parcial: registre quais páginas faltaram e não afirme nada sobre elas.

**Toda análise termina com um balanço de cobertura**, no documento de trabalho: o que
foi lido integralmente, o que foi lido em parte, o que não foi lido e por quê. Sem
esse balanço, cobertura reduzida se lê como cobertura completa — e quem revisa não
tem como saber a diferença.

**O que não deu para ler entra no documento de trabalho** com o motivo. Página
ilegível, letra manuscrita indecifrável, PDF corrompido — tudo registrado. Nunca
conclua a partir de documento que você não conseguiu ler, e nunca deixe a
ilegibilidade invisível.

**Diagnóstico não é incapacidade** e **agente nocivo no PPP não é tempo especial.**
Os dois erros são os mais comuns da análise previdenciária e o roteiro insiste em
ambos. Ver `references/medicos.md` e `references/ppp.md`.

## Ambiente

Detalhes de ferramentas, caminhos e limitações desta máquina em
`references/ambiente.md`. O essencial: `pdftotext` lê o que tem texto, `pdftoppm`
renderiza o que é imagem, e o `.docx` é gerado por `scripts/gerar-docx.ps1` sem
depender de Word, Python ou pandoc.
