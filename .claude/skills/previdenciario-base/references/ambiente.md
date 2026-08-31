# Ambiente

Verificado nesta máquina em 26/08/2026. Se algo aqui falhar, confira antes de
concluir que o documento é ilegível.

## Onde ficam as coisas

**Pastas de cliente** — Google Drive compartilhado, não Dropbox:

```
H:/Drives compartilhados/CBA/CLIENTES/2 - CLIENTES ESCRITORIO/<letra>/<NOME DO CLIENTE>/
```

O roteiro do escritório descreve Dropbox com subpastas `ANÁLISE INICIAL`,
`PRÉ-ANÁLISE`, `ANÁLISE BI`, `ANÁLISE AA`, `PLANEJAMENTO PREVIDENCIÁRIO`. Não há
Dropbox sincronizado aqui. A estrutura real varia por cliente e a nomenclatura é
inconsistente — `ANÁLISE INICIAL` e `ANALISE INICIAL`, `PRÉ ANÁLISE`, `ANÁLISE
PREVIUS`, `PROCESSO ADM`, `ANÁLISE BI`, `ANÁLISE TRABALHISTA`. Por isso a varredura é
recursiva e a classificação é por conteúdo.

**Fichas prontas** (cerca de cem, úteis como referência de estilo):

```
H:/Drives compartilhados/CBA/EQUIPE/LARISSA MARGHOTI DOS SANTOS/2 - ANÁLISES INICIAIS/
```

**Roteiro e modelo** — na mesma pasta: `ROTEIRO DE ANÁLISE INICIAL.docx` e
`PADRAO ANÁLISE INICIAL.docx`.

**Legislação** — ver `legislacao.md`.

> O `H:` é Google Drive em modo streaming, e isso tem duas consequências práticas
> medidas em uso real:
>
> **É lento.** Renderizar os 24 arquivos escaneados de um cliente (118 páginas)
> estourou o limite de 2 minutos de um comando. Rode a renderização em segundo plano
> ou em lotes, não num comando só.
>
> **Falha em silêncio.** O `pdftoppm` interrompe no meio e devolve menos páginas do
> que o PDF tem, sem erro e sem aviso. Num teste, um documento de 12 páginas gerou 6
> e nada indicou o problema. Por isso `ler-pdf.sh` confere a contagem e sai com
> código 4 quando não bate — **confie no aviso dele, não no fato de existirem PNGs
> na pasta**. Reaproveitar PNG de execução anterior é como o defeito passa
> despercebido; o script sempre re-renderiza do zero.

## Ferramentas

| Ferramenta | Situação |
|---|---|
| `pdftotext` | vem no Git Bash (`/mingw64/bin`) |
| `pdftoppm`, `pdfinfo` | poppler instalado via winget; `scripts/_poppler.sh` acha o caminho |
| PowerShell | disponível; usado para gerar `.docx` |
| Word | instalado, mas **não é necessário** para gerar `.docx` |
| Python, pandoc, LibreOffice, tesseract | **não instalados** |

Não há OCR. Documento escaneado é lido renderizando a página em PNG e interpretando
a imagem — o que funciona melhor que OCR em atestado manuscrito, mas não transforma
rabisco em texto.

Se o poppler sumir do PATH:

```bash
winget install --id oschwartz10612.Poppler
```

## Ler documentos

```bash
bash scripts/ler-pdf.sh "<arquivo.pdf>" "<pasta de trabalho>" [dpi]
```

Sai `MODO: texto` seguido do conteúdo, ou `MODO: imagem` seguido de linhas
`RENDERIZADO: <png>` para abrir com a ferramenta de leitura de imagem.

O limiar é 200 caracteres extraíveis por página: abaixo disso, o texto costuma ser só
cabeçalho e rodapé de um documento que na verdade é imagem.

O padrão de 150 dpi resolve documento impresso. Para manuscrito apertado ou carimbo,
repita com 300.

Use pasta de trabalho no diretório temporário da sessão. **Nunca escreva PNG dentro
da pasta do cliente.**

### O que costuma ser legível por texto

Tudo do Meu INSS e do Previus: CNIS, carta de concessão, comunicação de decisão,
laudo SABI, dados cadastrais, declaração de benefícios, cálculos do Previus. Também
contratos e petições geradas em computador.

### O que costuma ser imagem

Atestados, exames, receituários, guias e encaminhamentos, CTPS fotografada, RG,
comprovante de residência, documentos rurais antigos, e parte dos PPPs.

Numa pasta típica, dois terços dos arquivos são imagem. Fazer a conta de páginas
antes de começar evita surpresa: a triagem de `medicos.md` existe para isso.

## Codificação

Sempre `pdftotext -enc UTF-8`. Sem isso, acentuação sai corrompida — os PDFs do INSS
são Latin-1.

## Gerar .docx

```bash
powershell -ExecutionPolicy Bypass -File scripts/gerar-docx.ps1 \
  -Origem "<entrada.txt>" -Destino "<saida.docx>"
```

Entrada em UTF-8 com a marcação de `formato-ficha.md`. Gera WordprocessingML puro,
Times New Roman 11pt, A4, margens do `PADRAO`. Sem dependência de Word, Python ou
pandoc.

Nota técnica: o script grava as entradas do pacote uma a uma com barra normal. O
`ZipFile::CreateFromDirectory` do .NET Framework grava com barra invertida, o que
produz um `.docx` que o Word recusa a abrir.
