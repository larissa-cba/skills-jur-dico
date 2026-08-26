<#
  gerar-docx.ps1 - converte um arquivo de texto marcado em .docx (WordprocessingML puro).
  Nao depende de Word, LibreOffice, pandoc ou Python.

  Uso:
    powershell -ExecutionPolicy Bypass -File gerar-docx.ps1 -Origem entrada.txt -Destino "saida.docx"

  Marcacao aceita no arquivo de origem (UTF-8):
    # Texto            -> paragrafo em negrito (titulo de bloco)
    **negrito**        -> trecho em negrito dentro da linha
    |a|b|c|            -> linha de tabela (linhas consecutivas viram uma tabela)
    |---|---|---|      -> separador markdown (ignorado)
    (linha vazia)      -> paragrafo vazio
    qualquer outra     -> paragrafo normal

  Fonte e pagina seguem o PADRAO ANALISE INICIAL do escritorio:
  Times New Roman 11pt, A4, margens 2,5cm x 3cm.
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [Parameter(Mandatory=$true)][string]$Destino
)

$ErrorActionPreference = 'Stop'

function Esc([string]$s) { [System.Security.SecurityElement]::Escape($s) }

# Divide "texto **com negrito** aqui" em runs alternados
function Get-Runs([string]$texto, [bool]$forcarNegrito) {
  $out = ''
  $partes = $texto -split '\*\*'
  for ($i = 0; $i -lt $partes.Count; $i++) {
    $t = $partes[$i]
    if ($t -eq '') { continue }
    $bold = $forcarNegrito -or ($i % 2 -eq 1)
    $rPr = '<w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>'
    if ($bold) { $rPr = $rPr + '<w:b/>' }
    $rPr = $rPr + '<w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr>'
    $out = $out + '<w:r>' + $rPr + '<w:t xml:space="preserve">' + (Esc $t) + '</w:t></w:r>'
  }
  if ($out -eq '') {
    $out = '<w:r><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="22"/></w:rPr><w:t xml:space="preserve"></w:t></w:r>'
  }
  return $out
}

function New-Para([string]$texto, [bool]$negrito) {
  $pPr = '<w:pPr><w:spacing w:after="0" w:line="259" w:lineRule="auto"/><w:jc w:val="both"/></w:pPr>'
  return '<w:p>' + $pPr + (Get-Runs $texto $negrito) + '</w:p>'
}

function New-Celula([string]$texto, [bool]$negrito) {
  $tcPr = '<w:tcPr>' +
          '<w:tcBorders>' +
          '<w:top w:val="single" w:sz="4" w:color="999999"/>' +
          '<w:left w:val="single" w:sz="4" w:color="999999"/>' +
          '<w:bottom w:val="single" w:sz="4" w:color="999999"/>' +
          '<w:right w:val="single" w:sz="4" w:color="999999"/>' +
          '</w:tcBorders><w:vAlign w:val="top"/></w:tcPr>'
  $pPr = '<w:pPr><w:spacing w:after="0"/><w:jc w:val="left"/></w:pPr>'
  return '<w:tc>' + $tcPr + '<w:p>' + $pPr + (Get-Runs $texto $negrito) + '</w:p></w:tc>'
}

function New-Tabela($linhas) {
  if ($linhas.Count -eq 0) { return '' }
  $nCols = ($linhas | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
  if ($nCols -lt 1) { return '' }
  $larguraCol = [int](8504 / $nCols)
  $xml = '<w:tbl><w:tblPr><w:tblW w:w="5000" w:type="pct"/><w:tblLayout w:type="fixed"/></w:tblPr><w:tblGrid>'
  for ($i = 0; $i -lt $nCols; $i++) { $xml = $xml + '<w:gridCol w:w="' + $larguraCol + '"/>' }
  $xml = $xml + '</w:tblGrid>'
  for ($r = 0; $r -lt $linhas.Count; $r++) {
    $xml = $xml + '<w:tr>'
    for ($c = 0; $c -lt $nCols; $c++) {
      $v = ''
      if ($c -lt $linhas[$r].Count) { $v = $linhas[$r][$c] }
      $xml = $xml + (New-Celula $v ($r -eq 0))
    }
    $xml = $xml + '</w:tr>'
  }
  return $xml + '</w:tbl>'
}

# ---------- monta o corpo ----------
$linhas = @(Get-Content -LiteralPath $Origem -Encoding UTF8)
$body = ''
$bufTabela = @()

foreach ($linha in $linhas) {
  $l = $linha.TrimEnd()

  if ($l -match '^\s*\|') {
    $celulas = @(($l.Trim().Trim('|') -split '\|') | ForEach-Object { $_.Trim() })
    if ((($celulas -join '') -replace '[-: ]', '') -eq '') { continue }
    $bufTabela = $bufTabela + ,$celulas
    continue
  }

  if ($bufTabela.Count -gt 0) {
    $body = $body + (New-Tabela $bufTabela)
    $body = $body + '<w:p><w:pPr><w:spacing w:after="0"/></w:pPr></w:p>'
    $bufTabela = @()
  }

  if ($l -match '^#\s+(.*)$') { $body = $body + (New-Para $Matches[1] $true) }
  else                        { $body = $body + (New-Para $l $false) }
}

if ($bufTabela.Count -gt 0) {
  $body = $body + (New-Tabela $bufTabela)
}

$sectPr = '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/>' +
          '<w:pgMar w:top="1417" w:right="1701" w:bottom="1417" w:left="1701" w:header="708" w:footer="708" w:gutter="0"/>' +
          '<w:cols w:space="708"/></w:sectPr>'

$documentXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">' +
  '<w:body>' + $body + $sectPr + '</w:body></w:document>'

$stylesXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">' +
  '<w:docDefaults><w:rPrDefault><w:rPr>' +
  '<w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="Times New Roman" w:cs="Times New Roman"/>' +
  '<w:sz w:val="22"/><w:szCs w:val="22"/><w:lang w:val="pt-BR"/>' +
  '</w:rPr></w:rPrDefault></w:docDefaults>' +
  '<w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/></w:style>' +
  '</w:styles>'

$contentTypes = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">' +
  '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>' +
  '<Default Extension="xml" ContentType="application/xml"/>' +
  '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>' +
  '<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>' +
  '</Types>'

$rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
  '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>' +
  '</Relationships>'

$docRels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
  '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>' +
  '</Relationships>'

# ---------- escreve o pacote ----------
# Entradas gravadas uma a uma com barra normal: CreateFromDirectory grava com
# barra invertida no .NET Framework, o que produz um pacote OOXML invalido.
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$destinoAbs = [System.IO.Path]::GetFullPath($Destino)
$pasta = [System.IO.Path]::GetDirectoryName($destinoAbs)
if (-not (Test-Path $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }
if (Test-Path $destinoAbs) { Remove-Item -LiteralPath $destinoAbs -Force }

$partes = @{
  '[Content_Types].xml'         = $contentTypes
  '_rels/.rels'                 = $rels
  'word/document.xml'           = $documentXml
  'word/styles.xml'             = $stylesXml
  'word/_rels/document.xml.rels' = $docRels
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
$fs = [System.IO.File]::Open($destinoAbs, [System.IO.FileMode]::CreateNew)
try {
  $zip = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    foreach ($nome in $partes.Keys) {
      $entrada = $zip.CreateEntry($nome, [System.IO.Compression.CompressionLevel]::Optimal)
      $stream = $entrada.Open()
      try {
        $bytes = $utf8.GetBytes($partes[$nome])
        $stream.Write($bytes, 0, $bytes.Length)
      } finally { $stream.Dispose() }
    }
  } finally { $zip.Dispose() }
} finally { $fs.Dispose() }

Write-Output ("OK: " + $destinoAbs)
