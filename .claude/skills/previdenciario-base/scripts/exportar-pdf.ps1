<#
  exportar-pdf.ps1 - exporta um .docx para PDF usando o Word instalado.

  Uso:
    powershell -ExecutionPolicy Bypass -File exportar-pdf.ps1 -Origem "arquivo.docx" [-Destino "arquivo.pdf"]

  Sem -Destino, grava ao lado do .docx com o mesmo nome.

  Depende do Word. Se ele nao estiver disponivel, o script falha com mensagem
  clara em vez de gerar um PDF vazio - e o .docx continua valido, entao a
  ausencia do PDF nunca deve impedir a entrega.
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [string]$Destino
)

$ErrorActionPreference = 'Stop'

$origemAbs = [System.IO.Path]::GetFullPath($Origem)
if (-not (Test-Path $origemAbs)) { throw "Arquivo nao encontrado: $origemAbs" }

if ([string]::IsNullOrWhiteSpace($Destino)) {
  $Destino = [System.IO.Path]::ChangeExtension($origemAbs, '.pdf')
}
$destinoAbs = [System.IO.Path]::GetFullPath($Destino)

$word = $null
$doc = $null
try {
  $word = New-Object -ComObject Word.Application
} catch {
  throw "Word nao disponivel nesta maquina. O .docx continua valido; entregue sem o PDF e avise."
}

try {
  $word.Visible = $false
  $word.DisplayAlerts = 0
  $doc = $word.Documents.Open($origemAbs, $false, $true)
  # 17 = wdExportFormatPDF
  $doc.ExportAsFixedFormat($destinoAbs, 17)
  Write-Output ("OK: " + $destinoAbs)
} finally {
  if ($null -ne $doc) { try { $doc.Close($false) } catch {} }
  if ($null -ne $word) { try { $word.Quit() } catch {} }
}
