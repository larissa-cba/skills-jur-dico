<#
  listar-campos-pdf.ps1 - lista os campos de formulario (AcroForm) de um PDF.
  Nao depende de Python, pdftk ou Acrobat.

  Uso:
    powershell -ExecutionPolicy Bypass -File listar-campos-pdf.ps1 -Origem "formulario.pdf" [-Destino "campos.tsv"]

  Saida (TSV, UTF-8): objeto, pagina, tipo, nome, x1, y1, x2, y2, estados, valor
    tipo     Tx (texto), Btn (caixa de selecao), Ch (lista)
    estados  para Btn, os estados de aparencia alem de Off (ex.: Yes); para Ch, as opcoes
    x/y      retangulo do campo em pontos, origem no canto inferior esquerdo da pagina

  Limitacao: funciona com PDF de xref classica e objetos de campo fora de object
  streams - o caso dos formularios do INSS gerados pelo LibreOffice. Se o PDF usar
  xref stream ou object stream, o script avisa e para.
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [string]$Destino
)

$ErrorActionPreference = 'Stop'
$latin1 = [System.Text.Encoding]::GetEncoding(28591)
$bytes = [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $Origem).Path)
$pdf = $latin1.GetString($bytes)

if ($pdf -match '/Type\s*/ObjStm' -or $pdf -match '/Type\s*/XRef') {
  throw "PDF usa object stream ou xref stream - nao suportado por este script."
}

# Ultima definicao de cada objeto (respeita atualizacoes incrementais anteriores)
$objs = @{}
foreach ($m in [regex]::Matches($pdf, '(?s)(\d+)\s+0\s+obj(.*?)endobj')) {
  $objs[[int]$m.Groups[1].Value] = $m.Groups[2].Value
}

# Ordem das paginas pela arvore /Pages
$paginas = New-Object System.Collections.ArrayList
function Add-Paginas([int]$n) {
  $o = $objs[$n]
  if ($o -match '/Type\s*/Pages') {
    $kids = [regex]::Match($o, '/Kids\s*\[([^\]]*)\]').Groups[1].Value
    foreach ($k in [regex]::Matches($kids, '(\d+)\s+0\s+R')) { Add-Paginas ([int]$k.Groups[1].Value) }
  } else { [void]$paginas.Add($n) }
}
$trailerRoot = [regex]::Matches($pdf, '/Root\s+(\d+)\s+0\s+R')
$root = [int]$trailerRoot[$trailerRoot.Count - 1].Groups[1].Value
$pagesRef = [int][regex]::Match($objs[$root], '/Pages\s+(\d+)\s+0\s+R').Groups[1].Value
Add-Paginas $pagesRef

$linhas = New-Object System.Collections.ArrayList
[void]$linhas.Add("objeto`tpagina`ttipo`tnome`tx1`ty1`tx2`ty2`testados`tvalor")

foreach ($n in ($objs.Keys | Sort-Object)) {
  $o = $objs[$n]
  if ($o -notmatch '/FT\s*/(Tx|Btn|Ch)') { continue }
  $tipo = $Matches[1]
  $nome = [regex]::Match($o, '/T\s*\(((?:\\.|[^\\)])*)\)').Groups[1].Value
  $rect = [regex]::Match($o, '/Rect\s*\[\s*([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s*\]')
  $p = [regex]::Match($o, '/P\s+(\d+)\s+0\s+R')
  $pag = if ($p.Success) { $paginas.IndexOf([int]$p.Groups[1].Value) + 1 } else { '?' }
  $estados = ''
  if ($tipo -eq 'Btn') {
    $ap = [regex]::Match($o, '(?s)/N\s*<<(.*?)>>').Groups[1].Value
    $estados = ([regex]::Matches($ap, '/([A-Za-z0-9#_]+)\s+\d+\s+0\s+R') | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -ne 'Off' }) -join ','
  } elseif ($tipo -eq 'Ch') {
    $opt = [regex]::Match($o, '(?s)/Opt\s*\[(.*?)\]').Groups[1].Value
    $ops = foreach ($x in [regex]::Matches($opt, '\(((?:\\.|[^\\)])*)\)|<([0-9A-Fa-f\s]*)>')) {
      if ($x.Groups[1].Success) { $x.Groups[1].Value }
      else {
        $h = $x.Groups[2].Value -replace '\s', ''
        if ($h -match '^FEFF') {
          $h = $h.Substring(4)
          $b = for ($i = 0; $i -lt $h.Length; $i += 2) { [Convert]::ToByte($h.Substring($i, 2), 16) }
          if ($b) { [System.Text.Encoding]::BigEndianUnicode.GetString([byte[]]$b) }
        }
      }
    }
    $estados = (@($ops) | Where-Object { $_ }) -join ','
  }
  $valor = [regex]::Match($o, '/V\s*(\([^)]*\)|<[^>]*>|/[A-Za-z0-9#_]+)').Groups[1].Value
  if ($valor -match '^<FEFF([0-9A-Fa-f\s]*)>$') {
    $h = $Matches[1] -replace '\s', ''
    $b = for ($i = 0; $i -lt $h.Length; $i += 2) { [Convert]::ToByte($h.Substring($i, 2), 16) }
    $valor = if ($b) { [System.Text.Encoding]::BigEndianUnicode.GetString([byte[]]$b) } else { '' }
  }
  [void]$linhas.Add(("{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}`t{9}" -f $n, $pag, $tipo, $nome,
    $rect.Groups[1].Value, $rect.Groups[2].Value, $rect.Groups[3].Value, $rect.Groups[4].Value, $estados, $valor))
}

$saida = $linhas -join "`n"
if ($Destino) {
  [System.IO.File]::WriteAllText($Destino, $saida, (New-Object System.Text.UTF8Encoding($false)))
  Write-Output ("OK: {0} campos em {1}" -f ($linhas.Count - 1), $Destino)
} else {
  Write-Output $saida
}
