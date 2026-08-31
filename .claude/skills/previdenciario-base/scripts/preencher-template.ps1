<#
  preencher-template.ps1 - preenche um .docx modelo por dentro, preservando
  cabecalho, rodape, estilos, tabelas e numeracao exatamente como estao.

  Uso:
    powershell -ExecutionPolicy Bypass -File preencher-template.ps1 `
      -Modelo "Template_Nivel2_Completo.docx" `
      -Diretivas "diretivas.txt" `
      -Destino "RELATORIO ... .docx"

  O arquivo de diretivas e UTF-8, uma diretiva por linha, campos separados por "|".
  Linhas vazias e linhas iniciadas por # sao ignoradas.

    SET|<texto a procurar>|<texto novo>
        Substitui a PRIMEIRA ocorrencia ainda existente, na ordem do documento.
        E assim que se preenche um placeholder que se repete: o primeiro SET
        pega a primeira ocorrencia, o segundo pega a seguinte, e assim por diante.

    DUP_LINHA|<texto numa celula da linha modelo>|<n>
        Deixa a linha de tabela repetida n vezes no total (clona n-1).

    DUP_BLOCO|<texto do 1o paragrafo>|<texto do ultimo paragrafo>|<n>
        Deixa o bloco repetido n vezes no total. Serve para cenarios.

    DEL_PARA|<texto que identifica o paragrafo>
        Remove o paragrafo inteiro. Use para as notas internas.

    DEL_ATE|<texto inicial>|<texto final>
        Remove do bloco inicial ao final, inclusive, incluindo tabelas no meio.
        Use para subsecoes que nao se aplicam ao caso.

  ORDEM DAS DIRETIVAS - importa, e nao e obvia:

    1. Todos os DUP primeiro. Duplicar depois de preencher copiaria o conteudo
       ja escrito em vez do campo em branco.

    2. Depois, SET e DEL intercalados NA ORDEM DO DOCUMENTO. SET pega sempre a
       primeira ocorrencia ainda existente, entao a sequencia das diretivas
       precisa acompanhar a sequencia do texto.

       Apagar uma secao ANTES de preencher o que vem depois dela nao e detalhe:
       se a secao removida contem um [DATA] e voce so a apaga no fim, o SET do
       [DATA] do rodape vai acertar o [DATA] da secao que seria removida, e o
       rodape fica em branco. Apague a secao ao chegar nela.

  Falha ruidosamente quando um texto procurado nao existe. Isso e proposital:
  placeholder nao encontrado significa que o modelo mudou, e preencher pela
  metade em silencio produziria um documento errado com aparencia de pronto.
#>
param(
  [Parameter(Mandatory=$true)][string]$Modelo,
  [Parameter(Mandatory=$true)][string]$Diretivas,
  [Parameter(Mandatory=$true)][string]$Destino
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'

# ---------- le o document.xml de dentro do modelo ----------
$modeloAbs = [System.IO.Path]::GetFullPath($Modelo)
if (-not (Test-Path $modeloAbs)) { throw "Modelo nao encontrado: $modeloAbs" }

$zipIn = [System.IO.Compression.ZipFile]::OpenRead($modeloAbs)
$entradaDoc = $zipIn.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
if ($null -eq $entradaDoc) { $zipIn.Dispose(); throw "O modelo nao tem word/document.xml" }
$sr = New-Object System.IO.StreamReader($entradaDoc.Open(), [System.Text.Encoding]::UTF8)
$documentXml = $sr.ReadToEnd()
$sr.Dispose()

$xml = New-Object System.Xml.XmlDocument
$xml.PreserveWhitespace = $true
$xml.LoadXml($documentXml)
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace('w', $W)

$body = $xml.SelectSingleNode('//w:body', $ns)
if ($null -eq $body) { $zipIn.Dispose(); throw "document.xml sem <w:body>" }

# ---------- utilitarios ----------

# Primeiro <w:t> cujo texto contem $texto, na ordem do documento.
function Find-T([string]$texto) {
  foreach ($t in $xml.SelectNodes('//w:t', $ns)) {
    if ($t.InnerText -and $t.InnerText.Contains($texto)) { return $t }
  }
  return $null
}

# Sobe do no ate o ancestral cujo pai e o <w:body>: o "bloco" de topo,
# que pode ser um <w:p> ou uma <w:tbl>.
function Get-Bloco($no) {
  $n = $no
  while ($null -ne $n -and -not $n.ParentNode.Equals($body)) { $n = $n.ParentNode }
  return $n
}

function Get-Ancestral($no, [string]$nomeLocal) {
  $n = $no
  while ($null -ne $n) {
    if ($n.LocalName -eq $nomeLocal) { return $n }
    $n = $n.ParentNode
  }
  return $null
}

# Percorre os blocos de topo a partir de $blocoInicial e devolve a faixa ate o
# primeiro bloco que contem $textoFinal. Procurar o texto final a partir do
# inicial, e nao no documento inteiro, e o que permite usar como delimitador um
# texto que se repete entre cenarios - o caso normal nestes modelos.
function Get-Faixa($blocoInicial, [string]$textoFinal, [int]$nLinha) {
  $faixa = @()
  $atual = $blocoInicial
  while ($null -ne $atual) {
    $faixa += $atual
    if ($atual.InnerText -and $atual.InnerText.Contains($textoFinal)) { return $faixa }
    $atual = $atual.NextSibling
  }
  throw "Linha ${nLinha}: texto final nao encontrado depois do inicial -> '$textoFinal'"
}

# ---------- aplica as diretivas ----------
$linhas = @(Get-Content -LiteralPath $Diretivas -Encoding UTF8)
$nLinha = 0
$aplicadas = 0

foreach ($linha in $linhas) {
  $nLinha++
  $l = $linha.Trim()
  if ($l -eq '' -or $l.StartsWith('#')) { continue }

  $campos = $l -split '\|'
  $cmd = $campos[0].Trim()

  switch ($cmd) {

    'SET' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: SET precisa de 2 campos" }
      $alvo = $campos[1]
      $novo = ''
      if ($campos.Count -ge 3) { $novo = ($campos[2..($campos.Count-1)] -join '|') }
      $t = Find-T $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: texto nao encontrado no modelo -> '$alvo'" }
      $t.InnerText = $t.InnerText.Replace($alvo, $novo)
      $aplicadas++
    }

    'DUP_LINHA' {
      if ($campos.Count -lt 3) { throw "Linha ${nLinha}: DUP_LINHA precisa de 3 campos" }
      $alvo = $campos[1]
      $n = [int]$campos[2]
      if ($n -lt 1) { throw "Linha ${nLinha}: DUP_LINHA com n menor que 1" }
      $t = Find-T $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: texto nao encontrado -> '$alvo'" }
      $tr = Get-Ancestral $t 'tr'
      if ($null -eq $tr) { throw "Linha ${nLinha}: '$alvo' nao esta dentro de uma linha de tabela" }
      $ref = $tr
      for ($i = 1; $i -lt $n; $i++) {
        $copia = $tr.CloneNode($true)
        $tr.ParentNode.InsertAfter($copia, $ref) | Out-Null
        $ref = $copia
      }
      $aplicadas++
    }

    'DUP_BLOCO' {
      if ($campos.Count -lt 4) { throw "Linha ${nLinha}: DUP_BLOCO precisa de 4 campos" }
      $ini = $campos[1]; $fim = $campos[2]; $n = [int]$campos[3]
      if ($n -lt 1) { throw "Linha ${nLinha}: DUP_BLOCO com n menor que 1" }
      $tIni = Find-T $ini
      if ($null -eq $tIni) { throw "Linha ${nLinha}: texto inicial nao encontrado -> '$ini'" }
      $bIni = Get-Bloco $tIni
      $faixa = Get-Faixa $bIni $fim $nLinha
      $ref = $faixa[$faixa.Count - 1]
      for ($i = 1; $i -lt $n; $i++) {
        foreach ($b in $faixa) {
          $copia = $b.CloneNode($true)
          $body.InsertAfter($copia, $ref) | Out-Null
          $ref = $copia
        }
      }
      $aplicadas++
    }

    'DEL_PARA' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: DEL_PARA precisa de 2 campos" }
      $alvo = $campos[1]
      $t = Find-T $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: texto nao encontrado -> '$alvo'" }
      $p = Get-Ancestral $t 'p'
      if ($null -eq $p) { throw "Linha ${nLinha}: '$alvo' nao esta dentro de um paragrafo" }
      $p.ParentNode.RemoveChild($p) | Out-Null
      $aplicadas++
    }

    'DEL_ATE' {
      if ($campos.Count -lt 3) { throw "Linha ${nLinha}: DEL_ATE precisa de 3 campos" }
      $ini = $campos[1]; $fim = $campos[2]
      $tIni = Find-T $ini
      if ($null -eq $tIni) { throw "Linha ${nLinha}: texto inicial nao encontrado -> '$ini'" }
      $bIni = Get-Bloco $tIni
      $remover = Get-Faixa $bIni $fim $nLinha
      foreach ($b in $remover) { $body.RemoveChild($b) | Out-Null }
      $aplicadas++
    }

    default { throw "Linha ${nLinha}: diretiva desconhecida -> '$cmd'" }
  }
}

# ---------- avisa se sobrou placeholder ----------
$restantes = @()
foreach ($t in $xml.SelectNodes('//w:t', $ns)) {
  if ($t.InnerText -match '\[[^\]]{2,}\]') { $restantes += $t.InnerText.Trim() }
}

# ---------- escreve o .docx de saida ----------
$destinoAbs = [System.IO.Path]::GetFullPath($Destino)
$pasta = [System.IO.Path]::GetDirectoryName($destinoAbs)
if (-not (Test-Path $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }
if (Test-Path $destinoAbs) { Remove-Item -LiteralPath $destinoAbs -Force }

$utf8 = New-Object System.Text.UTF8Encoding($false)
$fs = [System.IO.File]::Open($destinoAbs, [System.IO.FileMode]::CreateNew)
try {
  $zipOut = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    foreach ($e in $zipIn.Entries) {
      $nova = $zipOut.CreateEntry($e.FullName, [System.IO.Compression.CompressionLevel]::Optimal)
      $saida = $nova.Open()
      try {
        if ($e.FullName -eq 'word/document.xml') {
          $bytes = $utf8.GetBytes($xml.OuterXml)
          $saida.Write($bytes, 0, $bytes.Length)
        } else {
          $entrada = $e.Open()
          try { $entrada.CopyTo($saida) } finally { $entrada.Dispose() }
        }
      } finally { $saida.Dispose() }
    }
  } finally { $zipOut.Dispose() }
} finally { $fs.Dispose(); $zipIn.Dispose() }

Write-Output ("OK: " + $destinoAbs)
Write-Output ("Diretivas aplicadas: " + $aplicadas)
if ($restantes.Count -gt 0) {
  Write-Output ""
  Write-Output ("!!! ATENCAO: sobraram " + $restantes.Count + " campo(s) do modelo sem preencher:")
  foreach ($r in ($restantes | Select-Object -Unique)) { Write-Output ("    " + $r) }
  Write-Output "!!! Confira antes de enviar. Campo em colchetes chegando ao cliente e erro visivel."
}
