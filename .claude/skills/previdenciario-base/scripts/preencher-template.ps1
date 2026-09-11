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

    SET_COLCHETE|<inicio do colchete>|<texto novo>
        Troca o colchete inteiro - do "[" ate o "]" - informando so o comeco
        dele. Serve para placeholders longos, como "[Sintese objetiva do que o
        cliente relatou na reuniao - atividade exercida, ...]": basta
        "[Sintese objetiva". Preserva o texto fora do colchete no mesmo trecho.

    SET_EXATO|<texto integral>|<texto novo>
        Como SET, mas so casa quando o trecho e IGUAL ao procurado, nao apenas
        contido nele. Use quando um rotulo curto de tabela e prefixo de um
        titulo: "Cenario 1" na celula versus "Cenario 1 - Sem reconhecimentos"
        no cabecalho. Sem isso, o SET acertaria o titulo.

        Atencao: substituir por um texto que ainda contenha o procurado faz o
        proximo SET reencontrar a mesma ocorrencia. Ao renomear linhas
        clonadas, de a cada uma um texto que nao case mais.

    DUP_LINHA|<texto numa celula da linha modelo>|<n>
        Deixa a linha de tabela repetida n vezes no total (clona n-1).

    DUP_BLOCO|<texto do 1o paragrafo>|<texto do ultimo paragrafo>|<n>
        Deixa o bloco repetido n vezes no total. Serve para cenarios.

    SET_PARA|<texto que identifica o paragrafo>|<novo texto do paragrafo inteiro>
        Substitui TODO o texto do paragrafo. Use quando o campo tem texto fixo
        dos dois lados e nao da para editar so o placeholder, como em
        'IRRF (quando aplicavel): R$ [VALOR] ou "nao aplicavel"'.
        Perde formatacao inline dentro do paragrafo.

    DEL_PARA|<texto que identifica o paragrafo>
        Remove o paragrafo inteiro. Use para as notas internas.

    DEL_ATE|<texto inicial>|<texto final>
        Remove do bloco inicial ao final, inclusive, incluindo tabelas no meio.
        Use para subsecoes que nao se aplicam ao caso. Com o mesmo texto nos
        dois campos, remove so a tabela ou o paragrafo que o contem.

    IMAGEM|<texto do paragrafo marcador>|<caminho da imagem>|<largura em cm>
        Troca o paragrafo inteiro que contem o texto por uma foto, mantendo a
        proporcao. A imagem e reduzida a 800 px de largura e regravada como
        JPEG antes de entrar no pacote. Procura no paragrafo inteiro, entao
        acha marcadores que o Word partiu em varios trechos. Falha com
        mensagem clara se o formato nao abrir - caso de fotos .ARW de camera.

    DEL_COLUNA|<texto numa celula da coluna>
        Remove a coluna inteira da tabela (a celula em todas as linhas e a
        largura correspondente) e redistribui a largura entre as que ficam.

  BUSCA - diferenca que importa: SET, SET_PARA e DEL_PARA procuram o texto
  dentro de UM trecho (<w:t>), entao nao acham frases que o Word partiu em
  varios trechos - e comum o rotulo e o placeholder ficarem separados, como
  em "Viabilidade: [baixa/media/alta]". Nesses casos procure so pelo colchete.
  Ja o texto final de DEL_ATE e DUP_BLOCO e procurado no paragrafo inteiro,
  entao aceita a frase completa.

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

# ATENCAO: variaveis do PowerShell nao diferenciam maiusculas. $W, $CTNS e
# $RELNS sao enderecos de namespace; nunca crie $w, $ctns ou $relns - elas
# sobrescrevem as de cima e corrompem o pacote sem erro nenhum.
$W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'

# ---------- le o document.xml de dentro do modelo ----------
$modeloAbs = [System.IO.Path]::GetFullPath($Modelo)
if (-not (Test-Path $modeloAbs)) { throw "Modelo nao encontrado: $modeloAbs" }

# Abre compartilhando leitura e escrita: o modelo costuma estar aberto no Word
# de alguem da equipe, e ZipFile::OpenRead falha nesse caso.
$fsIn = [System.IO.File]::Open($modeloAbs, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
$zipIn = New-Object System.IO.Compression.ZipArchive($fsIn, [System.IO.Compression.ZipArchiveMode]::Read)
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

# Primeiro <w:t> cujo texto e EXATAMENTE $texto. Serve para distinguir uma
# celula curta de um titulo que a contem: "Cenario 1" na tabela comparativa
# versus "Cenario 1 - Sem reconhecimentos adicionais" no cabecalho da secao.
function Find-T-Exato([string]$texto) {
  foreach ($t in $xml.SelectNodes('//w:t', $ns)) {
    if ($t.InnerText -eq $texto) { return $t }
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

# Primeiro <w:p> cujo texto COMPLETO contem $texto. Diferente de Find-T, acha
# marcadores que o Word partiu em varios trechos, como "[FOTOCristhiane Barreto]"
# gravado como "[" + "FOTOCristhiane" + " Barreto]".
function Find-P([string]$texto) {
  foreach ($p in $xml.SelectNodes('//w:p', $ns)) {
    if ($p.InnerText -and $p.InnerText.Contains($texto)) { return $p }
  }
  return $null
}

# ---------- imagens ----------
$imagens = New-Object System.Collections.ArrayList
Add-Type -AssemblyName System.Drawing

# Abre, reduz e regrava como JPEG. Fotos do banco de imagens chegam com 10 MB e
# 5000 px; embutidas cruas, o .docx fica pesado para mandar ao cliente.
function New-ImagemJpeg([string]$caminho, [int]$larguraMaxPx) {
  if (-not (Test-Path -LiteralPath $caminho)) { throw "Imagem nao encontrada: $caminho" }
  try { $img = [System.Drawing.Image]::FromFile($caminho) }
  catch { throw "Nao foi possivel abrir a imagem (formato nao suportado?): $caminho" }
  try {
    $larg = $img.Width; $alt = $img.Height
    if ($larg -gt $larguraMaxPx) { $alt = [int]($alt * $larguraMaxPx / $larg); $larg = $larguraMaxPx }
    $bmp = New-Object System.Drawing.Bitmap $larg, $alt
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $larg, $alt)
    $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $par = New-Object System.Drawing.Imaging.EncoderParameters 1
    $par.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 85L
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, $enc, $par)
    $g.Dispose(); $bmp.Dispose()
    return @{ Bytes = $ms.ToArray(); Largura = $larg; Altura = $alt }
  } finally { $img.Dispose() }
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
    # a virgula impede o PowerShell de desembrulhar uma lista de um elemento so:
    # sem ela, o bloco de paragrafo unico vira elemento solto e a copia vai para o
    # inicio do documento.
    if ($atual.InnerText -and $atual.InnerText.Contains($textoFinal)) { return ,$faixa }
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

    'SET_EXATO' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: SET_EXATO precisa de 2 campos" }
      $alvo = $campos[1]
      $novo = ''
      if ($campos.Count -ge 3) { $novo = ($campos[2..($campos.Count-1)] -join '|') }
      $t = Find-T-Exato $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: nenhum trecho igual a -> '$alvo'" }
      $t.InnerText = $novo
      $aplicadas++
    }

    'SET_PARA' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: SET_PARA precisa de 2 campos" }
      $alvo = $campos[1]
      $novo = ''
      if ($campos.Count -ge 3) { $novo = ($campos[2..($campos.Count-1)] -join '|') }
      $t = Find-T $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: texto nao encontrado -> '$alvo'" }
      $p = Get-Ancestral $t 'p'
      if ($null -eq $p) { throw "Linha ${nLinha}: '$alvo' nao esta dentro de um paragrafo" }
      $primeiro = $true
      foreach ($no in $p.SelectNodes('.//w:t', $ns)) {
        if ($primeiro) { $no.InnerText = $novo; $primeiro = $false }
        else { $no.InnerText = '' }
      }
      $aplicadas++
    }

    'SET_COLCHETE' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: SET_COLCHETE precisa de 2 campos" }
      $inicio = $campos[1]
      if (-not $inicio.StartsWith('[')) { throw "Linha ${nLinha}: SET_COLCHETE deve comecar com '[' -> '$inicio'" }
      $novo = ''
      if ($campos.Count -ge 3) { $novo = ($campos[2..($campos.Count-1)] -join '|') }
      $t = Find-T $inicio
      if ($null -eq $t) { throw "Linha ${nLinha}: nenhum colchete comecando com -> '$inicio'" }
      $txt = $t.InnerText
      $a = $txt.IndexOf($inicio)
      $b = $txt.IndexOf(']', $a)
      if ($b -lt 0) { throw "Linha ${nLinha}: colchete sem fechamento no mesmo trecho -> '$inicio'" }
      $t.InnerText = $txt.Substring(0, $a) + $novo + $txt.Substring($b + 1)
      $aplicadas++
    }

    'IMAGEM' {
      if ($campos.Count -lt 4) { throw "Linha ${nLinha}: IMAGEM precisa de 4 campos" }
      $alvo = $campos[1]; $arquivo = $campos[2]
      $larguraCm = [double]::Parse($campos[3].Replace(',', '.'), [System.Globalization.CultureInfo]::InvariantCulture)
      $p = Find-P $alvo
      if ($null -eq $p) { throw "Linha ${nLinha}: paragrafo nao encontrado -> '$alvo'" }
      $foto = New-ImagemJpeg $arquivo 800
      $n = $imagens.Count + 1
      $relId = "rIdFoto$n"
      $nomeParte = "media/foto$n.jpeg"
      [void]$imagens.Add(@{ Parte = "word/$nomeParte"; Bytes = $foto.Bytes; RelId = $relId; Alvo = $nomeParte })
      $cx = [int64]($larguraCm * 360000)
      $cy = [int64]($cx * $foto.Altura / $foto.Largura)
      $idDoc = 5000 + $n
      $frag = '<w:r xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" ' +
        'xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" ' +
        'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" ' +
        'xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" ' +
        'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">' +
        '<w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0">' +
        "<wp:extent cx=`"$cx`" cy=`"$cy`"/><wp:effectExtent l=`"0`" t=`"0`" r=`"0`" b=`"0`"/>" +
        "<wp:docPr id=`"$idDoc`" name=`"Foto $n`"/>" +
        '<wp:cNvGraphicFramePr><a:graphicFrameLocks noChangeAspect="1"/></wp:cNvGraphicFramePr>' +
        '<a:graphic><a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture"><pic:pic>' +
        "<pic:nvPicPr><pic:cNvPr id=`"$idDoc`" name=`"foto$n.jpeg`"/><pic:cNvPicPr/></pic:nvPicPr>" +
        "<pic:blipFill><a:blip r:embed=`"$relId`"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>" +
        "<pic:spPr><a:xfrm><a:off x=`"0`" y=`"0`"/><a:ext cx=`"$cx`" cy=`"$cy`"/></a:xfrm>" +
        '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr>' +
        '</pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing></w:r>'
      $tmp = New-Object System.Xml.XmlDocument
      $tmp.LoadXml($frag)
      $run = $xml.ImportNode($tmp.DocumentElement, $true)
      # tira todo o conteudo do paragrafo (o marcador), preservando a formatacao dele
      foreach ($filho in @($p.ChildNodes)) {
        if ($filho.LocalName -ne 'pPr') { [void]$p.RemoveChild($filho) }
      }
      [void]$p.AppendChild($run)
      $aplicadas++
    }

    'DEL_COLUNA' {
      if ($campos.Count -lt 2) { throw "Linha ${nLinha}: DEL_COLUNA precisa de 2 campos" }
      $alvo = $campos[1]
      $t = Find-T $alvo
      if ($null -eq $t) { throw "Linha ${nLinha}: texto nao encontrado -> '$alvo'" }
      $tc = Get-Ancestral $t 'tc'
      if ($null -eq $tc) { throw "Linha ${nLinha}: '$alvo' nao esta dentro de uma tabela" }
      $tr = $tc.ParentNode
      $tbl = Get-Ancestral $tr 'tbl'
      $idx = [array]::IndexOf(@($tr.SelectNodes('w:tc', $ns)), $tc)
      $grid = @($tbl.SelectNodes('w:tblGrid/w:gridCol', $ns))
      $total = 0
      foreach ($gc in $grid) { $total += [int]$gc.GetAttribute('w', $W) }
      foreach ($linhaTab in $tbl.SelectNodes('w:tr', $ns)) {
        $cels = @($linhaTab.SelectNodes('w:tc', $ns))
        if ($idx -lt $cels.Count) { [void]$linhaTab.RemoveChild($cels[$idx]) }
      }
      if ($idx -lt $grid.Count) { [void]$grid[$idx].ParentNode.RemoveChild($grid[$idx]) }
      # redistribui a largura: sem isso a tabela encolhe e deixa um vazio a direita
      $restantes = @($tbl.SelectNodes('w:tblGrid/w:gridCol', $ns))
      if ($restantes.Count -gt 0 -and $total -gt 0) {
        $nova = [int]($total / $restantes.Count)
        foreach ($gc in $restantes) { [void]$gc.SetAttribute('w', $W, [string]$nova) }
        foreach ($tcw in $tbl.SelectNodes('w:tr/w:tc/w:tcPr/w:tcW', $ns)) {
          [void]$tcw.SetAttribute('w', $W, [string]$nova); [void]$tcw.SetAttribute('type', $W, 'dxa')
        }
      }
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
# Olha o paragrafo inteiro, nao cada trecho: um marcador partido pelo Word em
# "[" + "FOTO" + "]" nao seria visto trecho a trecho e chegaria ao cliente.
$restantes = @()
foreach ($p in $xml.SelectNodes('//w:p', $ns)) {
  $txt = $p.InnerText
  foreach ($m in [regex]::Matches($txt, '\[[^\]]{2,}\]')) { $restantes += $m.Value }
}

# ---------- escreve o .docx de saida ----------
$destinoAbs = [System.IO.Path]::GetFullPath($Destino)
$pasta = [System.IO.Path]::GetDirectoryName($destinoAbs)
if (-not (Test-Path $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }
if (Test-Path $destinoAbs) { Remove-Item -LiteralPath $destinoAbs -Force }

$utf8 = New-Object System.Text.UTF8Encoding($false)

function Read-Parte([string]$nome) {
  $e = $zipIn.Entries | Where-Object { $_.FullName -eq $nome }
  if ($null -eq $e) { return $null }
  $r = New-Object System.IO.StreamReader($e.Open(), [System.Text.Encoding]::UTF8)
  try { return $r.ReadToEnd() } finally { $r.Dispose() }
}

# Partes que mudam alem do document.xml quando ha foto: as relacoes (que ligam
# o r:embed ao arquivo) e o [Content_Types].xml (que declara o tipo jpeg).
$substituir = @{ 'word/document.xml' = $xml.OuterXml }
if ($imagens.Count -gt 0) {
  $RELNS = 'http://schemas.openxmlformats.org/package/2006/relationships'
  $rels = New-Object System.Xml.XmlDocument
  $rels.LoadXml((Read-Parte 'word/_rels/document.xml.rels'))
  foreach ($im in $imagens) {
    $el = $rels.CreateElement('Relationship', $RELNS)
    $el.SetAttribute('Id', $im.RelId)
    $el.SetAttribute('Type', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image')
    $el.SetAttribute('Target', $im.Alvo)
    [void]$rels.DocumentElement.AppendChild($el)
  }
  $substituir['word/_rels/document.xml.rels'] = $rels.OuterXml

  $CTNS = 'http://schemas.openxmlformats.org/package/2006/content-types'
  $ct = New-Object System.Xml.XmlDocument
  $ct.LoadXml((Read-Parte '[Content_Types].xml'))
  $gerCt = New-Object System.Xml.XmlNamespaceManager($ct.NameTable); $gerCt.AddNamespace('c', $CTNS)
  if ($null -eq $ct.SelectSingleNode("//c:Default[@Extension='jpeg']", $gerCt)) {
    $d = $ct.CreateElement('Default', $CTNS)
    $d.SetAttribute('Extension', 'jpeg'); $d.SetAttribute('ContentType', 'image/jpeg')
    [void]$ct.DocumentElement.PrependChild($d)
  }
  $substituir['[Content_Types].xml'] = $ct.OuterXml
}

$fs = [System.IO.File]::Open($destinoAbs, [System.IO.FileMode]::CreateNew)
try {
  $zipOut = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    foreach ($e in $zipIn.Entries) {
      $nova = $zipOut.CreateEntry($e.FullName, [System.IO.Compression.CompressionLevel]::Optimal)
      $saida = $nova.Open()
      try {
        if ($substituir.ContainsKey($e.FullName)) {
          $bytes = $utf8.GetBytes($substituir[$e.FullName])
          $saida.Write($bytes, 0, $bytes.Length)
        } else {
          $entrada = $e.Open()
          try { $entrada.CopyTo($saida) } finally { $entrada.Dispose() }
        }
      } finally { $saida.Dispose() }
    }
    foreach ($im in $imagens) {
      $nova = $zipOut.CreateEntry($im.Parte, [System.IO.Compression.CompressionLevel]::NoCompression)
      $saida = $nova.Open()
      try { $saida.Write($im.Bytes, 0, $im.Bytes.Length) } finally { $saida.Dispose() }
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
