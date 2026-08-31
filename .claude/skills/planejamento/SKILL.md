---
name: planejamento
description: Relatório de planejamento previdenciário nos três níveis do escritório, a partir dos documentos e cálculos da pasta PLANEJAMENTO PREVIDENCIÁRIO do cliente. Preenche o template oficial preservando timbre e rodapé, e entrega também um documento de trabalho interno.
disable-model-invocation: true
---

# Planejamento previdenciário

Lê a pasta do cliente e preenche um dos três templates do escritório. Entrega o
relatório em `.docx` e `.pdf`, mais um documento de trabalho interno.

## Invocação

```
/planejamento <caminho da pasta do cliente> --nivel 1|2|3
```

Se o caminho não vier, peça. Não adivinhe o cliente pelo nome citado na conversa.

Se o nível não vier, pergunte. **O nível é decisão comercial, não técnica** — reflete
o que o cliente contratou, e isso a pasta não diz. Mas se o material indicar outro
nível, avise: PPP, documento rural ou CTC na pasta sugerem nível 3, e pedir nível 1
com esse material significa deixar direito reconhecível de fora.

## Material compartilhado

Scripts e doutrina de leitura ficam em `previdenciario-base`, ao lado desta skill, e
são os mesmos da `analise-inicial`. Leia o `README.md` de lá antes de começar: as
regras sobre custo, cobertura e legislação valem aqui integralmente.

Aqui ficam só os três níveis e os formatos de saída desta skill.

> **Todo caminho neste arquivo é relativo à pasta desta skill**, informada como
> "Base directory for this skill" quando a skill carrega — **não** ao diretório de
> trabalho da sessão. Antes do primeiro comando, guarde essa pasta numa variável e
> use-a em tudo:
>
> ```bash
> SKILL="<base directory desta skill>"
> BASE="$SKILL/../previdenciario-base"
> ```
>
> Os exemplos abaixo usam `$BASE` e `$SKILL` nesse sentido.

## Fluxo

### 1. Varredura

```bash
bash "$BASE/scripts/varrer-pasta.sh" "<caminho da pasta do cliente>"
```

Varra a pasta raiz do cliente, não só a subpasta de planejamento — CTPS costuma
estar em `DOCUMENTOS PESSOAIS` e documentos médicos em `DOCUMENTOS MEDICOS`.

**Não leia a ficha de análise inicial**, mesmo que exista. A análise é feita do zero,
por decisão do escritório: partir da ficha propagaria qualquer erro dela para o
planejamento sem ninguém perceber.

### 2. Primeira parada — inventário

Mostre o que encontrou e **pare**. Some as páginas escaneadas e diga quantas são.

**Se não houver nenhum cálculo do Previus, pare aqui e diga o que falta.** Todo o
relatório gira em torno dos cenários, e cada cenário vem de um cálculo. Relatório
com cenário em branco é pior que relatório nenhum. Não siga adiante.

### 3. Leitura

```bash
bash "$BASE/scripts/ler-pdf.sh" "<arquivo.pdf>" "<pasta de trabalho>"
```

Doutrina por tipo de documento em `$BASE/references/`: `cnis.md`,
`ppp.md`, `rural.md`, `medicos.md`, `dtc-ctc.md`, `pedidos-administrativos.md`.
Carregue só o que o caso pedir.

Os cálculos do Previus são de leitura obrigatória e são a fonte dos cenários. Ver
`$SKILL/references/cenarios.md` para o que extrair de cada um.

### 4. Segunda parada — mapeamento dos cenários

Esta parada não existe na `analise-inicial` e existe aqui porque o mapeamento define
a estrutura do documento inteiro. Descobrir na entrega que o cenário 3 era outra
coisa significa refazer o relatório.

Apresente uma tabela: qual arquivo de cálculo vira qual cenário, com que nome, e os
números que você extraiu de cada um. **Pare e confirme.**

Diga também, aqui, o que você **não** conseguiu extrair — tipicamente valor investido
e payback, que podem ser conta feita à parte e não sair dos PDFs. Pergunte esses
números em vez de calculá-los: errar payback é errar a recomendação.

### 5. Montagem

Escreva um arquivo de diretivas e preencha o template:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/preencher-template.ps1" \
  -Modelo "<template do nível>" -Diretivas "<diretivas.txt>" -Destino "<saida.docx>"
```

O formato das diretivas e a ordem obrigatória estão no cabeçalho do próprio script.
O que preencher em cada nível está em `$SKILL/references/niveis.md`.

Depois exporte o PDF:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/exportar-pdf.ps1" -Origem "<saida.docx>"
```

Se o Word não estiver disponível, entregue só o `.docx` e avise. Falta de PDF nunca
impede a entrega.

### 6. Terceira parada — resultado

Entregue os dois arquivos e reúna as dúvidas restantes num bloco só.

## Saída

**O relatório** — `<pasta do cliente>/PLANEJAMENTO PREVIDENCIÁRIO/RELATÓRIO PLANEJAMENTO PREVIDENCIÁRIO - <NOME DO CLIENTE>.docx`, mais o `.pdf` de mesmo nome.
Se a subpasta não existir, crie com esse nome exato, acentuado.

**O documento de trabalho** — mesma pasta, sufixo ` - TRABALHO.docx`, gerado com
`gerar-docx.ps1`. Formato em `$SKILL/references/formato-trabalho.md`.

Nunca sobrescreva relatório existente sem antes mostrar o que muda.

## Regras que não se negociam

**Nenhuma nota interna chega ao cliente.** Os templates 2 e 3 trazem parágrafos
começando por `Nota interna:` que instruem o que remover antes de enviar. Remova
todos, sempre, e remova também as subseções que não se aplicam ao caso. Registre no
documento de trabalho o que foi removido e por quê.

**Nenhum campo entre colchetes chega ao cliente.** O script avisa quando sobra
`[ALGUMA COISA]` no documento. Trate esse aviso como bloqueio, não como observação.

**Use as escalas do template, não as suas.** O relatório vai para o cliente e as
escalas foram escolhidas para esse leitor: `viabilidade baixa/média/alta`, pendências
`leves/relevantes/críticas`, `custo-benefício bom/regular/baixo`, `segurança jurídica
alta/média/baixa`. As etiquetas `forte / depende de complementação / controvertido`
ficam só no documento de trabalho.

**O código GPS vai no campo que já existe.** `Modalidade de recolhimento: [facultativo
/ contribuinte individual — código GPS]` é onde entra o código, por exemplo
`contribuinte individual mensal — código 1007`. Não crie seção de instruções de
pagamento: o template não a prevê.

**Caso com RPPS fica pela metade, e isso precisa ser dito.** Os três templates
afirmam, na identificação, que o segurado é vinculado ao RGPS, e só tratam dele.
Havendo CTC, ficha financeira, mapa de tempo de serviço ou cálculo de regime próprio
na pasta, faça o RGPS e **avise com todas as letras**, no documento de trabalho e na
entrega, que os cenários do RPPS ficaram de fora e que o caso precisa de tratamento
manual até existir template com regime próprio.

**Nunca afirme regra legal de memória** — carência, regra de transição, pedágio,
pontuação, alíquota. Consulte `$BASE/references/legislacao.md`.

**Balanço de cobertura obrigatório** no documento de trabalho, uma linha por arquivo
da pasta.
