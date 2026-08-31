#!/usr/bin/env bash
# ler-pdf.sh - entrega o conteudo de um PDF na melhor forma disponivel.
#
# Uso: bash ler-pdf.sh "caminho/do/arquivo.pdf" "pasta/de/trabalho" [dpi]
#
# Se o PDF tem camada de texto, imprime o texto no stdout.
# Se e escaneado, renderiza cada pagina em PNG na pasta de trabalho e imprime
# os caminhos, um por linha, prefixados por RENDERIZADO: para o agente abrir
# com a ferramenta de leitura de imagem.
#
# Documentos do Meu INSS e do Previus caem sempre no primeiro caso.
# Atestados, exames, CTPS fotografada e PPP antigo costumam cair no segundo.

set -uo pipefail

PDF="${1:-}"
TRAB="${2:-}"
DPI="${3:-150}"

if [ -z "$PDF" ] || [ ! -f "$PDF" ]; then
  echo "ERRO: PDF nao encontrado: '$PDF'" >&2
  exit 1
fi
if [ -z "$TRAB" ]; then
  echo "ERRO: informe a pasta de trabalho para os PNGs." >&2
  exit 1
fi

# shellcheck source=_poppler.sh
. "$(dirname "${BASH_SOURCE[0]}")/_poppler.sh"

chars=$(pdftotext -enc UTF-8 -layout "$PDF" - 2>/dev/null | tr -d '[:space:]' | wc -c | tr -d ' ')
pags=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/{print $2}')
[ -z "$pags" ] && pags=1

# 200 chars por pagina e o limiar: abaixo disso o texto extraido costuma ser so
# cabecalho/rodape de um documento que na verdade e imagem.
limiar=$((200 * pags))

if [ "$chars" -ge 50 ] && [ "$chars" -ge "$limiar" ]; then
  echo "MODO: texto ($chars caracteres, $pags pagina(s))"
  echo "---"
  pdftotext -enc UTF-8 -layout "$PDF" -
  exit 0
fi

if ! command -v pdftoppm >/dev/null 2>&1; then
  echo "ERRO: documento e imagem e o pdftoppm nao esta instalado." >&2
  echo "Instale com: winget install --id oschwartz10612.Poppler" >&2
  exit 2
fi

mkdir -p "$TRAB"
base="$(basename "${PDF%.*}" | tr -cd '[:alnum:]._-' | cut -c1-60)"
prefixo="$TRAB/$base"

# Renderiza sempre do zero. Aproveitar PNG de uma execucao anterior esconde
# renderizacao parcial: o Drive em streaming interrompe no meio e sobram menos
# paginas do que o PDF tem, sem erro nenhum.
rm -f "$prefixo"-*.png
pdftoppm -png -r "$DPI" "$PDF" "$prefixo" 2>/dev/null

found=$(ls "$prefixo"-*.png 2>/dev/null | wc -l | tr -d ' ')

# Uma tentativa de recuperacao antes de desistir: o Drive costuma servir na
# segunda vez o arquivo que falhou na primeira.
if [ "$found" -ne "$pags" ]; then
  rm -f "$prefixo"-*.png
  pdftoppm -png -r "$DPI" "$PDF" "$prefixo" 2>/dev/null
  found=$(ls "$prefixo"-*.png 2>/dev/null | wc -l | tr -d ' ')
fi

if [ "$found" -eq 0 ]; then
  echo "ERRO: nenhuma pagina renderizada de '$PDF' ($pags pagina(s) esperadas)." >&2
  echo "Nao conclua nada a partir deste documento. Registre-o como ilegivel." >&2
  exit 3
fi

echo "MODO: imagem ($chars caracteres extraiveis, $pags pagina(s)) - renderizado a ${DPI}dpi"

if [ "$found" -ne "$pags" ]; then
  echo "!!! RENDERIZACAO INCOMPLETA: $found de $pags paginas."
  echo "!!! As paginas ausentes NAO foram lidas. Registre a lacuna no documento"
  echo "!!! de trabalho e nao afirme nada sobre o conteudo que faltou."
fi

if [ "$chars" -gt 0 ]; then
  echo "--- texto parcial encontrado (cabecalho/rodape, use como apoio) ---"
  pdftotext -enc UTF-8 -layout "$PDF" -
fi

echo "--- paginas renderizadas ($found de $pags) ---"
for png in "$prefixo"-*.png; do
  [ -f "$png" ] || continue
  echo "RENDERIZADO: $png"
done

[ "$found" -ne "$pags" ] && exit 4
exit 0
