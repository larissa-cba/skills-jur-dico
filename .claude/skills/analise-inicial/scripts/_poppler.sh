#!/usr/bin/env bash
# _poppler.sh - coloca as ferramentas do poppler no PATH.
# Feito para ser carregado com "source", nao executado direto.
#
# O Git Bash ja traz pdftotext, mas nao traz pdftoppm nem pdfinfo. O poppler
# instalado via winget fica sob o LOCALAPPDATA e nao entra no PATH do Git Bash
# automaticamente, entao procuramos qualquer versao instalada.

_win2posix() {
  # "C:\Users\x" -> "/c/Users/x"
  printf '%s' "$1" | sed -e 's|\\|/|g' -e 's|^\([A-Za-z]\):|/\1|' \
    | sed -e 's|^/\([A-Z]\)|/\l\1|'
}

if ! command -v pdftoppm >/dev/null 2>&1 || ! command -v pdfinfo >/dev/null 2>&1; then
  _localapp="${LOCALAPPDATA:-}"
  if [ -n "$_localapp" ]; then
    _base="$(_win2posix "$_localapp")/Microsoft/WinGet/Packages"
  else
    _base="$HOME/AppData/Local/Microsoft/WinGet/Packages"
  fi
  for _cand in "$_base"/oschwartz10612.Poppler*/poppler-*/Library/bin; do
    if [ -d "$_cand" ]; then
      export PATH="$PATH:$_cand"
      break
    fi
  done
  unset _localapp _base _cand
fi

poppler_ok() { command -v pdftoppm >/dev/null 2>&1; }
