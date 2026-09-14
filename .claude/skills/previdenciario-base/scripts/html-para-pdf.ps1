<#
  html-para-pdf.ps1 - converte uma pagina HTML/CSS em PDF usando o Microsoft
  Edge instalado, em modo headless. Nao depende de Word, Python ou navegador
  aberto.

  Uso:
    powershell -ExecutionPolicy Bypass -File html-para-pdf.ps1 `
      -Origem "apresentacao.html" -Destino "apresentacao.pdf"

  Sem -Destino, grava ao lado do .html com o mesmo nome.

  O tamanho da pagina, a cor de fundo e as margens vem inteiramente do CSS do
  proprio arquivo HTML (@page { size: ...; margin: ... }) - este script nao
  aplica cabecalho/rodape do navegador nem margens proprias.

  Depende do Edge. Se ele nao estiver instalado no caminho padrao, o script
  falha com mensagem clara.
#>
param(
  [Parameter(Mandatory=$true)][string]$Origem,
  [string]$Destino
)

$ErrorActionPreference = 'Stop'

$origemAbs = [System.IO.Path]::GetFullPath($Origem)
if (-not (Test-Path -LiteralPath $origemAbs)) { throw "Arquivo nao encontrado: $origemAbs" }

if ([string]::IsNullOrWhiteSpace($Destino)) {
  $Destino = [System.IO.Path]::ChangeExtension($origemAbs, '.pdf')
}
$destinoAbs = [System.IO.Path]::GetFullPath($Destino)
$pasta = [System.IO.Path]::GetDirectoryName($destinoAbs)
if (-not (Test-Path -LiteralPath $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }

$candidatos = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)
$edge = $candidatos | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if ($null -eq $edge) {
  throw "Microsoft Edge nao encontrado nos caminhos padrao. O .html continua valido; abra-o e imprima em PDF manualmente, ou informe o caminho do Edge nesta maquina."
}

# file:/// exige barras normais, mesmo em Windows.
$urlOrigem = 'file:///' + ($origemAbs -replace '\\', '/')

# Perfil proprio e isolado: rodar headless contra o perfil padrao falha com
# "Multiple targets are not supported in headless mode" quando ja existe uma
# janela do Edge aberta (o caso normal nesta maquina). Um --user-data-dir
# temporario evita tocar na sessao real do usuario.
$perfilTemp = Join-Path $env:TEMP ("edge-headless-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $perfilTemp | Out-Null

# Windows PowerShell 5.1 nao cota automaticamente elementos de -ArgumentList
# que contem espaco (caminho "Projetos Claude\Skills Juridico" tem espaco) -
# ele so junta os elementos com espaco, entao um caminho sem aspas propria
# vira dois argumentos para o Edge, que le como dois alvos e recusa rodar
# headless. Por isso cada valor que pode ter espaco leva aspas duplas aqui.
$args = @(
  '--headless',
  '--disable-gpu',
  "--user-data-dir=`"$perfilTemp`"",
  '--no-pdf-header-footer',
  "--print-to-pdf=`"$destinoAbs`"",
  "`"$urlOrigem`""
)

if (Test-Path -LiteralPath $destinoAbs) { Remove-Item -LiteralPath $destinoAbs -Force }

try {
  $proc = Start-Process -FilePath $edge -ArgumentList $args -NoNewWindow -PassThru -Wait
} finally {
  Remove-Item -LiteralPath $perfilTemp -Recurse -Force -ErrorAction SilentlyContinue
}
if (-not (Test-Path -LiteralPath $destinoAbs)) {
  throw "O Edge nao gerou o PDF. Confira se o HTML abre sem erro e se os caminhos de fonte/CSS sao relativos ao proprio arquivo."
}

Write-Output ("OK: " + $destinoAbs)
