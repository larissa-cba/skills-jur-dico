<#
  preencher-pdf-form.ps1 - preenche campos de formulario (AcroForm) de um PDF.
  Nao depende de Python, pdftk ou Acrobat. Grava uma atualizacao incremental:
  o PDF original fica intacto dentro do novo arquivo, e so os campos preenchidos
  sao regravados.

  Uso:
    powershell -ExecutionPolicy Bypass -File preencher-pdf-form.ps1 -Origem "form.pdf" -Valores "valores.json" -Destino "preenchido.pdf"

  valores.json (UTF-8): objeto JSON { "<nome do campo>": "<valor>" }
    - nome do campo exatamente como listar-campos-pdf.ps1 imprime (ex.: "Caixa de texto 14_2",
      "Caixa de sele#C3#A7#C3#A3o 1_11");
    - caixa de texto e lista: o texto a gravar (acentos permitidos);
    - caixa de selecao: "Yes" (ou o estado listado) para marcar, "Off" para desmarcar.

  Os campos de texto ficam sem aparencia propria e o formulario sai com
  /NeedAppearances true: o leitor de PDF (Acrobat, Edge, Chrome, poppler) desenha o
  valor ao abrir. O campo continua editavel.

  Campo do JSON que nao existe no PDF interrompe com erro - nada e gravado.
  Limitacao: PDF de xref classica, sem object stream (caso dos formularios do INSS).
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [Parameter(Mandatory=$true)][string]$Valores,
  [Parameter(Mandatory=$true)][string]$Destino
)

$ErrorActionPreference = 'Stop'
$latin1 = [System.Text.Encoding]::GetEncoding(28591)
$bytes = [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $Origem).Path)
$pdf = $latin1.GetString($bytes)

if ($pdf -match '/Type\s*/ObjStm' -or $pdf -match '/Type\s*/XRef') {
  throw "PDF usa object stream ou xref stream - nao suportado por este script."
}

$json = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $Valores).Path, [System.Text.Encoding]::UTF8)
$mapa = $json | ConvertFrom-Json
$pedidos = @{}
foreach ($p in $mapa.PSObject.Properties) { $pedidos[$p.Name] = [string]$p.Value }

# Ultima definicao de cada objeto
$objs = @{}
foreach ($m in [regex]::Matches($pdf, '(?s)(\d+)\s+0\s+obj(.*?)endobj')) {
  $objs[[int]$m.Groups[1].Value] = $m.Groups[2].Value
}

function ConvertTo-PdfHex([string]$s) {
  $b = [System.Text.Encoding]::BigEndianUnicode.GetBytes($s)
  return '<FEFF' + (($b | ForEach-Object { $_.ToString('X2') }) -join '') + '>'
}

# Dictionary tipado: num [ordered]@{} a chave inteira seria lida como posicao
$novos = New-Object 'System.Collections.Generic.Dictionary[int,string]'
$encontrados = @{}
foreach ($n in ($objs.Keys | Sort-Object)) {
  $o = $objs[$n]
  if ($o -notmatch '/FT\s*/(Tx|Btn|Ch)') { continue }
  $tipo = $Matches[1]
  $nome = [regex]::Match($o, '/T\s*\(((?:\\.|[^\\)])*)\)').Groups[1].Value
  if (-not $pedidos.ContainsKey($nome)) { continue }
  $encontrados[$nome] = $true
  $valor = $pedidos[$nome]

  $ini = $o.IndexOf('<<'); $fim = $o.LastIndexOf('>>')
  $dict = $o.Substring($ini + 2, $fim - $ini - 2)
  $dict = [regex]::Replace($dict, '/V\s*(\((?:\\.|[^\\)])*\)|<[^>]*>|/[A-Za-z0-9#_]+)', '')
  $dict = [regex]::Replace($dict, '/AS\s*/[A-Za-z0-9#_]+', '')

  if ($tipo -eq 'Btn') {
    $ap = [regex]::Match($o, '(?s)/N\s*<<(.*?)>>').Groups[1].Value
    $estados = [regex]::Matches($ap, '/([A-Za-z0-9#_]+)\s+\d+\s+0\s+R') | ForEach-Object { $_.Groups[1].Value }
    $marcar = $valor -notin @('Off', '', 'false', 'nao', 'não')
    if ($marcar) {
      $on = $estados | Where-Object { $_ -ne 'Off' } | Select-Object -First 1
      if ($valor -in $estados) { $on = $valor }
      if (-not $on) { throw "Campo '$nome' sem estado de marcacao." }
      $dict += "`n/V /$on`n/AS /$on`n"
    } else {
      $dict += "`n/V /Off`n/AS /Off`n"
    }
  } else {
    $dict = [regex]::Replace($dict, '(?s)/AP\s*<<.*?>>', '')
    $dict += "`n/V " + (ConvertTo-PdfHex $valor) + "`n"
  }
  $novos[$n] = "$n 0 obj`n<<" + $dict + ">>`nendobj`n"
}

$faltando = $pedidos.Keys | Where-Object { -not $encontrados.ContainsKey($_) }
if ($faltando) { throw ("Campos nao encontrados no PDF: " + ($faltando -join '; ')) }

# Garante /NeedAppearances true no AcroForm
$rootMatches = [regex]::Matches($pdf, '/Root\s+(\d+)\s+0\s+R')
$root = [int]$rootMatches[$rootMatches.Count - 1].Groups[1].Value
$rootObj = $objs[$root]
$acroRef = [regex]::Match($rootObj, '/AcroForm\s+(\d+)\s+0\s+R')
if ($acroRef.Success) {
  $an = [int]$acroRef.Groups[1].Value
  $ao = $objs[$an]
  if ($ao -notmatch '/NeedAppearances\s+true') {
    $ini = $ao.IndexOf('<<'); $fim = $ao.LastIndexOf('>>')
    $d = [regex]::Replace($ao.Substring($ini + 2, $fim - $ini - 2), '/NeedAppearances\s+\w+', '')
    $novos[$an] = "$an 0 obj`n<<" + $d + "`n/NeedAppearances true`n>>`nendobj`n"
  }
} elseif ($rootObj -match '(?s)/AcroForm\s*<<') {
  if ($rootObj -notmatch '/NeedAppearances\s+true') {
    $r = [regex]::Replace($rootObj, '/NeedAppearances\s+\w+', '')
    $r = [regex]::Replace($r, '/AcroForm\s*<<', "/AcroForm<</NeedAppearances true ")
    $ini = $r.IndexOf('<<'); $fim = $r.LastIndexOf('>>')
    $novos[$root] = "$root 0 obj`n" + $r.Substring($ini, $fim - $ini + 2) + "`nendobj`n"
  }
} else {
  throw "PDF sem AcroForm."
}

# Atualizacao incremental
$prevXref = [regex]::Matches($pdf, 'startxref\s+(\d+)')
$prev = $prevXref[$prevXref.Count - 1].Groups[1].Value
$trailers = [regex]::Matches($pdf, '(?s)trailer\s*<<(.*?)>>\s*startxref')
$ultimo = $trailers[$trailers.Count - 1].Groups[1].Value
$size = [regex]::Match($ultimo, '/Size\s+(\d+)').Groups[1].Value
$info = [regex]::Match($ultimo, '/Info\s+\d+\s+0\s+R').Value
$id = [regex]::Match($ultimo, '(?s)/ID\s*\[.*?\]').Value

$sb = New-Object System.Text.StringBuilder
[void]$sb.Append("`n")
$offsets = @{}
$base = $bytes.Length
foreach ($k in $novos.Keys) {
  $offsets[$k] = $base + $sb.Length
  [void]$sb.Append($novos[$k])
}
$xrefPos = $base + $sb.Length
[void]$sb.Append("xref`n")
foreach ($k in ($novos.Keys | Sort-Object)) {
  [void]$sb.Append(("{0} 1`n{1:D10} 00000 n `n" -f $k, $offsets[$k]))
}
[void]$sb.Append("trailer`n<</Size $size /Root $root 0 R $info $id /Prev $prev>>`nstartxref`n$xrefPos`n%%EOF`n")

$saida = New-Object byte[] ($bytes.Length + $sb.Length)
[System.Array]::Copy($bytes, $saida, $bytes.Length)
$extra = $latin1.GetBytes($sb.ToString())
[System.Array]::Copy($extra, 0, $saida, $bytes.Length, $extra.Length)
[System.IO.File]::WriteAllBytes($Destino, $saida)
Write-Output ("OK: {0} campos preenchidos em {1}" -f $encontrados.Count, $Destino)
