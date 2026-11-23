<#
  ler-docx.ps1 - extrai o texto de um .docx na mesma marcacao que gerar-docx.ps1 aceita.
  Nao depende de Word, LibreOffice, pandoc ou Python.

  Uso:
    powershell -ExecutionPolicy Bypass -File ler-docx.ps1 -Origem "ficha.docx" [-Destino "ficha.txt"]

  Saida (UTF-8):
    paragrafo inteiro em negrito -> "# Texto"
    trecho em negrito             -> "**trecho**"
    linha de tabela               -> "|a|b|c|"
    paragrafo vazio               -> linha vazia

  Ida e volta: um .docx gerado por gerar-docx.ps1, lido aqui e gerado de novo, sai igual.
  Um .docx feito a mao no Word perde o que a marcacao nao representa (cor, recuo,
  fonte, imagem). Por isso quem regrava uma ficha precisa avisar antes.
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [string]$Destino
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$caminho = (Resolve-Path -LiteralPath $Origem).Path
$zip = [System.IO.Compression.ZipFile]::OpenRead($caminho)
try {
  $entrada = $zip.GetEntry('word/document.xml')
  if ($null -eq $entrada) { throw "Arquivo sem word/document.xml - nao parece .docx: $caminho" }
  $leitor = New-Object System.IO.StreamReader($entrada.Open(), [System.Text.Encoding]::UTF8)
  $xmlTexto = $leitor.ReadToEnd()
  $leitor.Close()
} finally {
  $zip.Dispose()
}

[xml]$doc = $xmlTexto
$ns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')

function Test-Negrito($run) {
  $b = $run.SelectSingleNode('w:rPr/w:b', $ns)
  if ($null -eq $b) { return $false }
  $v = $b.GetAttribute('val', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
  return -not ($v -eq '0' -or $v -eq 'false')
}

function Get-TextoRun($run) {
  $s = ''
  foreach ($n in $run.ChildNodes) {
    switch ($n.LocalName) {
      't'   { $s += $n.InnerText }
      'tab' { $s += "`t" }
      'br'  { $s += ' ' }
    }
  }
  return $s
}

# Devolve [texto marcado, todo-negrito]
function Convert-Paragrafo($p) {
  $partes = @()
  foreach ($r in $p.SelectNodes('.//w:r', $ns)) {
    $t = Get-TextoRun $r
    if ($t -eq '') { continue }
    $partes += ,@($t, (Test-Negrito $r))
  }
  if ($partes.Count -eq 0) { return @('', $false) }

  $todos = $true
  foreach ($x in $partes) { if (-not $x[1]) { $todos = $false } }
  if ($todos) { return @((($partes | ForEach-Object { $_[0] }) -join ''), $true) }

  # junta runs vizinhos de mesmo estilo antes de marcar
  $out = ''
  $buf = ''
  $bufNeg = $partes[0][1]
  foreach ($x in $partes) {
    if ($x[1] -eq $bufNeg) { $buf += $x[0]; continue }
    $out += $(if ($bufNeg -and $buf.Trim() -ne '') { "**$buf**" } else { $buf })
    $buf = $x[0]; $bufNeg = $x[1]
  }
  $out += $(if ($bufNeg -and $buf.Trim() -ne '') { "**$buf**" } else { $buf })
  return @($out, $false)
}

$linhas = New-Object System.Collections.Generic.List[string]
$corpo = $doc.SelectSingleNode('/w:document/w:body', $ns)

foreach ($no in $corpo.ChildNodes) {
  if ($no.LocalName -eq 'p') {
    $r = Convert-Paragrafo $no
    if ($r[1] -and $r[0].Trim() -ne '') { $linhas.Add('# ' + $r[0]) } else { $linhas.Add($r[0]) }
  } elseif ($no.LocalName -eq 'tbl') {
    foreach ($tr in $no.SelectNodes('w:tr', $ns)) {
      $celulas = @()
      foreach ($tc in $tr.SelectNodes('w:tc', $ns)) {
        $txt = @()
        foreach ($p in $tc.SelectNodes('w:p', $ns)) {
          $c = (Convert-Paragrafo $p)[0]
          if ($c -ne '') { $txt += $c }
        }
        $celulas += (($txt -join ' ') -replace '\|', '/')
      }
      $linhas.Add('|' + ($celulas -join '|') + '|')
    }
  }
}

$saida = $linhas -join "`r`n"
if ($Destino) {
  [System.IO.File]::WriteAllText($Destino, $saida, (New-Object System.Text.UTF8Encoding($false)))
} else {
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  Write-Output $saida
}
