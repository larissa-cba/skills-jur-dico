#!/usr/bin/env bash
# varrer-pasta.sh - inventaria os documentos de uma pasta de cliente.
#
# Uso: bash varrer-pasta.sh "H:/Drives compartilhados/.../NOME DO CLIENTE"
#
# Para cada arquivo, informa paginas, caracteres extraiveis e um veredito:
#   TEXTO   - da para ler direto com pdftotext
#   IMAGEM  - escaneado, precisa renderizar em PNG e ler com visao
#   MISTO   - tem texto, mas pouco para o numero de paginas (provavel scan parcial)
# A saida e uma tabela para conferencia antes de comecar a analise.

set -uo pipefail

RAIZ="${1:-}"
if [ -z "$RAIZ" ] || [ ! -d "$RAIZ" ]; then
  echo "ERRO: informe uma pasta existente. Recebido: '$RAIZ'" >&2
  exit 1
fi

# shellcheck source=_poppler.sh
. "$(dirname "${BASH_SOURCE[0]}")/_poppler.sh"

LISTA="$(mktemp)"
trap 'rm -f "$LISTA"' EXIT

printf '%-8s %-6s %-9s %s\n' "TIPO" "PAGS" "CHARS" "ARQUIVO"
printf '%s\n' "--------------------------------------------------------------------------------"

total=0; texto=0; imagem=0; misto=0; outros=0; pags_render=0

while IFS= read -r -d '' f; do
  total=$((total+1))
  rel="${f#$RAIZ/}"
  ext="$(printf '%s' "${f##*.}" | tr '[:upper:]' '[:lower:]')"

  case "$ext" in
    pdf)
      pags=$(pdfinfo "$f" 2>/dev/null | awk '/^Pages:/{print $2}')
      [ -z "$pags" ] && pags="?"
      chars=$(pdftotext -enc UTF-8 -layout "$f" - 2>/dev/null | tr -d '[:space:]' | wc -c | tr -d ' ')
      if [ "$chars" -lt 50 ]; then
        tipo="IMAGEM"; imagem=$((imagem+1))
        [ "$pags" != "?" ] && pags_render=$((pags_render + pags))
      elif [ "$pags" != "?" ] && [ "$pags" -gt 0 ] && [ $((chars / pags)) -lt 200 ]; then
        tipo="MISTO"; misto=$((misto+1))
        pags_render=$((pags_render + pags))
      else
        tipo="TEXTO"; texto=$((texto+1))
      fi
      ;;
    docx|doc)
      pags="-"; chars="-"; tipo="DOCX"; outros=$((outros+1))
      ;;
    jpg|jpeg|png|tif|tiff|bmp)
      pags="1"; chars="0"; tipo="IMAGEM"; imagem=$((imagem+1))
      ;;
    *)
      continue
      ;;
  esac

  printf '%-8s %-6s %-9s %s\n' "$tipo" "$pags" "$chars" "$rel"
  printf '%s\n' "$rel" >> "$LISTA"
done < <(find "$RAIZ" -type f \( -iname '*.pdf' -o -iname '*.docx' -o -iname '*.doc' \
         -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
         -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.bmp' \) -print0 2>/dev/null | sort -z)

printf '%s\n' "--------------------------------------------------------------------------------"
printf 'Total: %s | texto: %s | imagem (precisa renderizar): %s | misto: %s | word/outros: %s\n' \
  "$total" "$texto" "$imagem" "$misto" "$outros"
printf 'Paginas a renderizar: %s\n' "$pags_render"
if [ "$pags_render" -gt 60 ]; then
  printf '\n'
  printf 'ATENCAO: %s paginas escaneadas. Isso e leitura cara e demorada.\n' "$pags_render"
  printf 'Apresente a triagem e PERGUNTE o que ler. Nao decida sozinho pular\n'
  printf 'uma categoria inteira por causa do custo.\n'
fi

# ---------------------------------------------------------------------------
# Rede de seguranca para os documentos de leitura obrigatoria.
# Isto e PISTA POR NOME DE ARQUIVO, nao classificacao: nomes mentem, e um
# arquivo chamado "RECEITUARIO" pode ter 24 paginas de prontuario. Serve so
# para que um obrigatorio guardado em pasta inesperada nao passe batido -
# a CTPS costuma estar em DOCUMENTOS PESSOAIS, longe da pasta de analise.
# A classificacao de verdade e feita lendo o conteudo.
# ---------------------------------------------------------------------------
printf '\n%s\n' "DOCUMENTOS DE LEITURA OBRIGATORIA (pista por nome)"
printf '%s\n' "--------------------------------------------------------------------------------"

checar() {
  rotulo="$1"; padrao="$2"
  # grep -c ja imprime 0 e sai com 1 quando nao acha; o "|| echo 0" duplicaria.
  achados=$(grep -icE "$padrao" "$LISTA" 2>/dev/null); achados="${achados:-0}"
  if [ "$achados" -gt 0 ]; then
    printf '  [ ] %-28s %s candidato(s):\n' "$rotulo" "$achados"
    grep -iE "$padrao" "$LISTA" | sed 's|^|        |'
  else
    printf '  [!] %-28s nenhum candidato -> se o caso exigir, vira PROVIDENCIA\n' "$rotulo"
  fi
}

checar "CNIS"                 'cnis'
checar "CTPS / carteira"      'ctps|carteira'
checar "PPP"                  'ppp|perfil profissiog'
checar "Concessao / decisao"  'concess|decisao|decisão|comunica'
checar "Pericia / laudo SABI" 'sabi|pericia|perícia|laudo'
# "lculo" cobre calculo e cálculo: o ponto do regex casa 1 byte e o "a" acentuado
# ocupa 2 em UTF-8, entao "c.lculo" nao acha "Cálculo".
checar "Calculo Previus"      'lculo|previus'
checar "CTC / DTC"            '(^|[^a-z])(ctc|dtc)([^a-z]|$)|certid.o de tempo|declara.+tempo de contrib'

printf '\n%s\n' "Marcados com [!] nao foram encontrados por nome. Confirme lendo o conteudo"
printf '%s\n' "antes de concluir que nao existem: o nome do arquivo nao e garantia."
