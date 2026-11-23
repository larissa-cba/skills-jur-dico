<#
  aplicar-timbrado.ps1 - escreve um texto marcado dentro do papel timbrado do escritorio.
  Preserva cabecalho, rodape, logotipo, margens, fontes e estilos do timbrado; troca
  so o corpo do documento.

  Uso:
    powershell -ExecutionPolicy Bypass -File aplicar-timbrado.ps1 `
      -Timbrado "Papel timbrado Cristhiane Barreto 2025.docx" `
      -Origem "minuta.txt" -Destino "PEDIDO ... .docx"

  Marcacao aceita no arquivo de origem (UTF-8) - a mesma do gerar-docx.ps1, mais tres:
    # Texto            -> paragrafo em negrito
    **negrito**        -> trecho em negrito dentro da linha
    |a|b|c|            -> linha de tabela
    (linha vazia)      -> paragrafo vazio
    >> Texto           -> paragrafo alinhado a direita (local e data)
    ^^ Texto           -> paragrafo centralizado (bloco de assinatura)
    ---quebra---       -> quebra de pagina
    @@assinaturas Nome 1;OAB/SC 1|Nome 2;OAB/SC 2
                       -> assinaturas lado a lado, sem bordas, sem partir entre paginas
    qualquer outra     -> paragrafo justificado

  A fonte nao e forcada: vale a padrao do timbrado.
#>
param(
  [Parameter(Mandatory=$true)][string]$Timbrado,
  [Parameter(Mandatory=$true)][string]$Origem,
  [Parameter(Mandatory=$true)][string]$Destino
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Esc([string]$s) { [System.Security.SecurityElement]::Escape($s) }

function Get-Runs([string]$texto, [bool]$forcarNegrito) {
  $out = ''
  $partes = $texto -split '\*\*'
  for ($i = 0; $i -lt $partes.Count; $i++) {
    $t = $partes[$i]
    if ($t -eq '') { continue }
    $bold = $forcarNegrito -or ($i % 2 -eq 1)
    $rPr = ''
    if ($bold) { $rPr = '<w:rPr><w:b/></w:rPr>' }
    $out += '<w:r>' + $rPr + '<w:t xml:space="preserve">' + (Esc $t) + '</w:t></w:r>'
  }
  return $out
}

function New-Para([string]$texto, [bool]$negrito, [string]$alin) {
  $pPr = '<w:pPr><w:spacing w:after="120" w:line="300" w:lineRule="auto"/><w:jc w:val="' + $alin + '"/></w:pPr>'
  return '<w:p>' + $pPr + (Get-Runs $texto $negrito) + '</w:p>'
}

function New-Tabela($linhas) {
  if ($linhas.Count -eq 0) { return '' }
  $nCols = ($linhas | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
  $larguraCol = [int](9000 / $nCols)
  $borda = '<w:tcBorders><w:top w:val="single" w:sz="4" w:color="999999"/><w:left w:val="single" w:sz="4" w:color="999999"/><w:bottom w:val="single" w:sz="4" w:color="999999"/><w:right w:val="single" w:sz="4" w:color="999999"/></w:tcBorders>'
  $xml = '<w:tbl><w:tblPr><w:tblW w:w="5000" w:type="pct"/><w:tblLayout w:type="fixed"/></w:tblPr><w:tblGrid>'
  for ($i = 0; $i -lt $nCols; $i++) { $xml += '<w:gridCol w:w="' + $larguraCol + '"/>' }
  $xml += '</w:tblGrid>'
  for ($r = 0; $r -lt $linhas.Count; $r++) {
    $xml += '<w:tr>'
    for ($c = 0; $c -lt $nCols; $c++) {
      $v = ''
      if ($c -lt $linhas[$r].Count) { $v = $linhas[$r][$c] }
      $xml += '<w:tc><w:tcPr>' + $borda + '</w:tcPr><w:p><w:pPr><w:spacing w:after="0"/></w:pPr>' + (Get-Runs $v ($r -eq 0)) + '</w:p></w:tc>'
    }
    $xml += '</w:tr>'
  }
  return $xml + '</w:tbl>'
}

# Bloco de assinaturas lado a lado, sem bordas, que nao se parte entre paginas.
# Entrada: "Nome 1;OAB 1|Nome 2;OAB 2"
function New-Assinaturas([string]$spec) {
  $pessoas = @($spec -split '\|' | ForEach-Object { ,@($_ -split ';' | ForEach-Object { $_.Trim() }) })
  $n = $pessoas.Count
  $larg = [int](9000 / $n)
  $semBorda = '<w:tblBorders><w:top w:val="nil"/><w:left w:val="nil"/><w:bottom w:val="nil"/><w:right w:val="nil"/><w:insideH w:val="nil"/><w:insideV w:val="nil"/></w:tblBorders>'
  $junto = '<w:keepNext/><w:keepLines/><w:spacing w:after="0"/><w:jc w:val="center"/>'
  # paragrafos vazios antes, presos ao bloco, para o espaco da assinatura
  $xml = ''
  for ($k = 0; $k -lt 3; $k++) { $xml += '<w:p><w:pPr><w:keepNext/><w:spacing w:after="0"/></w:pPr></w:p>' }
  $xml += '<w:tbl><w:tblPr><w:tblW w:w="5000" w:type="pct"/><w:jc w:val="center"/>' + $semBorda + '<w:tblLayout w:type="fixed"/></w:tblPr><w:tblGrid>'
  for ($i = 0; $i -lt $n; $i++) { $xml += '<w:gridCol w:w="' + $larg + '"/>' }
  $xml += '</w:tblGrid><w:tr><w:trPr><w:cantSplit/></w:trPr>'
  foreach ($p in $pessoas) {
    $xml += '<w:tc><w:tcPr><w:tcW w:w="' + $larg + '" w:type="dxa"/></w:tcPr>'
    $xml += '<w:p><w:pPr>' + $junto + '</w:pPr>' + (Get-Runs '______________________________' $false) + '</w:p>'
    $xml += '<w:p><w:pPr>' + $junto + '</w:pPr>' + (Get-Runs $p[0] $true) + '</w:p>'
    $oab = ''
    if ($p.Count -gt 1) { $oab = $p[1] }
    $xml += '<w:p><w:pPr><w:spacing w:after="0"/><w:jc w:val="center"/></w:pPr>' + (Get-Runs $oab $false) + '</w:p></w:tc>'
  }
  return $xml + '</w:tr></w:tbl>'
}

# ---------- corpo novo ----------
$body = ''
$buf = @()
foreach ($linha in @(Get-Content -LiteralPath $Origem -Encoding UTF8)) {
  $l = $linha.TrimEnd()
  if ($l -match '^\s*\|') {
    $cel = @(($l.Trim().Trim('|') -split '\|') | ForEach-Object { $_.Trim() })
    if ((($cel -join '') -replace '[-: ]', '') -eq '') { continue }
    $buf += ,$cel
    continue
  }
  if ($buf.Count -gt 0) { $body += (New-Tabela $buf) + '<w:p/>'; $buf = @() }

  if ($l -eq '---quebra---')       { $body += '<w:p><w:r><w:br w:type="page"/></w:r></w:p>' }
  elseif ($l -match '^@@assinaturas\s+(.+)$') {
    # prende o paragrafo anterior ("Atenciosamente,") ao bloco de assinaturas
    $i = $body.LastIndexOf('<w:p><w:pPr>')
    if ($i -ge 0) { $body = $body.Substring(0, $i) + '<w:p><w:pPr><w:keepNext/>' + $body.Substring($i + 12) }
    $body += New-Assinaturas $Matches[1]
  }
  elseif ($l -match '^#\s+(.*)$')  { $body += New-Para $Matches[1] $true 'both' }
  elseif ($l -match '^>>\s?(.*)$') { $body += New-Para $Matches[1] $false 'right' }
  elseif ($l -match '^\^\^\s?(.*)$') { $body += New-Para $Matches[1] $false 'center' }
  else                             { $body += New-Para $l $false 'both' }
}
if ($buf.Count -gt 0) { $body += New-Tabela $buf }

# ---------- copia o timbrado e troca o corpo ----------
$timbradoAbs = (Resolve-Path -LiteralPath $Timbrado).Path
$destinoAbs = [System.IO.Path]::GetFullPath($Destino)
$pasta = [System.IO.Path]::GetDirectoryName($destinoAbs)
if (-not (Test-Path $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }
if (Test-Path $destinoAbs) { throw "Destino ja existe, nao sobrescrevo: $destinoAbs" }
Copy-Item -LiteralPath $timbradoAbs -Destination $destinoAbs

$zip = [System.IO.Compression.ZipFile]::Open($destinoAbs, [System.IO.Compression.ZipArchiveMode]::Update)
try {
  $entrada = $zip.GetEntry('word/document.xml')
  $leitor = New-Object System.IO.StreamReader($entrada.Open(), [System.Text.Encoding]::UTF8)
  $xml = $leitor.ReadToEnd()
  $leitor.Close()

  $iBody = $xml.IndexOf('<w:body>')
  $iSect = $xml.LastIndexOf('<w:sectPr')
  if ($iBody -lt 0 -or $iSect -lt $iBody) { throw 'Timbrado sem <w:body> ou <w:sectPr> - estrutura inesperada.' }
  $novo = $xml.Substring(0, $iBody + 8) + $body + $xml.Substring($iSect)

  $entrada.Delete()
  $nova = $zip.CreateEntry('word/document.xml', [System.IO.Compression.CompressionLevel]::Optimal)
  $s = $nova.Open()
  try {
    $bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($novo)
    $s.Write($bytes, 0, $bytes.Length)
  } finally { $s.Dispose() }
} finally {
  $zip.Dispose()
}

Write-Output ("OK: " + $destinoAbs)
