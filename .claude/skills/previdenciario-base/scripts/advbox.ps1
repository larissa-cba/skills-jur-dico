<#
  advbox.ps1 - consulta SOMENTE LEITURA a API do Advbox (app.advbox.com.br/api/v1).
  Nunca cria, altera ou apaga nada no Advbox: so faz GET.

  Token: variavel de ambiente ADVBOX_TOKEN ou, se ausente, o arquivo
  %USERPROFILE%\.advbox\token (uma linha, sem aspas). O token NUNCA vai para o
  repositorio nem e impresso.

  Uso:
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao cliente     -Nome "MARIA DA SILVA"
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao cliente     -Cpf "000.000.000-00"
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao processos   -ClienteId 123
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao processo    -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao historico   -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao movimentos  -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao publicacoes -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao tarefas     -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao pericia     -ProcessoId 456
    powershell -ExecutionPolicy Bypass -File advbox.ps1 -Acao configuracoes

  'pericia' junta etapa, historico, tarefas, movimentacoes e publicacoes do processo e
  imprime so o que menciona pericia, avaliacao social, laudo ou audiencia.

  Limite da API: 30 GETs por minuto por conta. Em HTTP 429 o script espera 60 s e
  tenta uma vez mais.

  Saidas: texto UTF-8, uma linha por registro, campos separados por " | ".
  Codigos de saida: 0 ok; 2 parametro faltando; 3 sem token; 4 erro HTTP.
#>
param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('cliente','processos','processo','historico','movimentos','publicacoes','tarefas','pericia','configuracoes')]
  [string]$Acao,
  [string]$Nome,
  [string]$Cpf,
  [long]$ClienteId,
  [long]$ProcessoId
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Base = 'https://app.advbox.com.br/api/v1'

function Get-Token {
  if ($env:ADVBOX_TOKEN) { return $env:ADVBOX_TOKEN.Trim() }
  $arq = Join-Path $env:USERPROFILE '.advbox\token'
  if (Test-Path $arq) { return (Get-Content $arq -Raw).Trim() }
  Write-Output 'ERRO: token do Advbox nao encontrado. Defina ADVBOX_TOKEN ou grave o token em %USERPROFILE%\.advbox\token.'
  exit 3
}

$Token = Get-Token
$Headers = @{ Authorization = "Bearer $Token"; Accept = 'application/json' }

function Invoke-Advbox([string]$caminho) {
  $url = "$Base/$caminho"
  for ($tentativa = 1; $tentativa -le 2; $tentativa++) {
    try {
      $r = Invoke-WebRequest -UseBasicParsing -Uri $url -Headers $Headers -Method Get
      if ($r.StatusCode -eq 204 -or -not $r.Content) { return $null }
      # decodifica como UTF-8 independente do charset anunciado
      $bytes = $r.RawContentStream.ToArray()
      $txt = [System.Text.Encoding]::UTF8.GetString($bytes)
      return ($txt | ConvertFrom-Json)
    } catch {
      $code = $null
      if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
      if ($code -eq 429 -and $tentativa -eq 1) {
        Write-Output 'AVISO: limite de 30 consultas por minuto atingido; aguardando 60 s.'
        Start-Sleep -Seconds 60
        continue
      }
      if ($code -eq 404) { return $null }
      Write-Output "ERRO HTTP $code em GET /$($caminho -replace '\?.*','')"
      exit 4
    }
  }
}

function Exigir([string]$nomeParam, $valor) {
  if (-not $valor) { Write-Output "ERRO: -$nomeParam e obrigatorio para -Acao $Acao."; exit 2 }
}

function Limpar([string]$s) {
  if ($null -eq $s) { return '' }
  return (($s -replace "`r", '') -replace "`n", ' / ').Trim()
}

function Esc-Url([string]$s) { [System.Uri]::EscapeDataString($s) }

function Linha-Processo($p) {
  $tipo = Limpar $p.type
  return "PROCESSO $($p.id) | tipo: $tipo | grupo: $(Limpar $p.group) | etapa: $(Limpar $p.step) | fase: $(Limpar $p.stage) | numero: $(Limpar $p.process_number) | protocolo: $(Limpar $p.protocol_number) | pasta: $(Limpar $p.folder) | responsavel: $(Limpar $p.responsible) | criado: $($p.created_at) | data do processo: $($p.process_date) | encerramento: $($p.status_closure)"
}

$RegexPericia = 'PER[IÍ]CI|PERITO|LAUDO|AVALIA[CÇ][AÃ]O (SOCIAL|M[EÉ]DICA|BIOPSICOSSOCIAL)|AV\. SOCIAL|AUDI[EÊ]NCIA|ASSISTENTE T[EÉ]CNICO|NOMOS'

# Trecho de ~300 caracteres em volta da primeira mencao a pericia/laudo/audiencia
function Trecho([string]$s) {
  $s = Limpar $s
  $m = [regex]::Match($s, $RegexPericia, 'IgnoreCase')
  if (-not $m.Success) { return $s }
  $ini = [Math]::Max(0, $m.Index - 120)
  $fim = [Math]::Min($s.Length, $m.Index + 180)
  $pre = if ($ini -gt 0) { '...' } else { '' }
  $pos = if ($fim -lt $s.Length) { '...' } else { '' }
  return $pre + $s.Substring($ini, $fim - $ini) + $pos
}

switch ($Acao) {

  'configuracoes' {
    $s = Invoke-Advbox 'settings'
    Write-Output '== ETAPAS E FASES (step | stage)'
    $s.stages | ForEach-Object { Write-Output "$($_.step) | $($_.stage) | id $($_.id)" }
    Write-Output '== TIPOS DE PROCESSO (grupo | tipo)'
    $s.lawsuit_types | ForEach-Object { Write-Output "$($_.group) | $($_.type) | id $($_.id)" }
    Write-Output '== TAREFAS LIGADAS A PERICIA, AVALIACAO, LAUDO OU AUDIENCIA'
    $s.tasks | Where-Object { $_.task -match $RegexPericia } | ForEach-Object { Write-Output "$($_.task) | id $($_.id)" }
  }

  'cliente' {
    if (-not $Nome -and -not $Cpf) { Write-Output 'ERRO: informe -Nome ou -Cpf.'; exit 2 }
    $q = if ($Cpf) { 'identification=' + (Esc-Url $Cpf) } else { 'name=' + (Esc-Url $Nome) }
    $r = Invoke-Advbox "customers?$q&limit=50"
    if (-not $r -or $r.totalCount -eq 0) { Write-Output 'NENHUM CLIENTE ENCONTRADO'; break }
    Write-Output "ENCONTRADOS: $($r.totalCount)"
    foreach ($c in $r.data) {
      Write-Output "CLIENTE $($c.id) | $($c.name) | nascimento: $($c.birthdate) | profissao: $(Limpar $c.occupation) | cidade: $($c.city)/$($c.state) | processos: $(@($c.lawsuits).Count)"
      foreach ($l in @($c.lawsuits)) { if ($l) { Write-Output "   processo $($l.lawsuit_id) | numero: $($l.process_number) | protocolo: $($l.protocol_number)" } }
    }
  }

  'processos' {
    Exigir 'ClienteId' $ClienteId
    $r = Invoke-Advbox "lawsuits?customer_id=$ClienteId&limit=100"
    if (-not $r -or $r.totalCount -eq 0) { Write-Output 'NENHUM PROCESSO PARA ESTE CLIENTE'; break }
    Write-Output "PROCESSOS: $($r.totalCount)"
    foreach ($p in $r.data) { Write-Output (Linha-Processo $p) }
  }

  'processo' {
    Exigir 'ProcessoId' $ProcessoId
    $p = Invoke-Advbox "lawsuits/$ProcessoId"
    if (-not $p) { Write-Output 'PROCESSO NAO ENCONTRADO'; break }
    Write-Output (Linha-Processo $p)
    Write-Output ('clientes: ' + ((@($p.customers) | ForEach-Object { "$($_.name) (id $($_.customer_id))" }) -join '; '))
    Write-Output '== ANOTACOES DO PROCESSO'
    Write-Output ($p.notes -replace "`r", '')
  }

  'historico' {
    Exigir 'ProcessoId' $ProcessoId
    $r = Invoke-Advbox "history/$ProcessoId"
    if (-not $r -or -not $r.data) { Write-Output 'HISTORICO VAZIO'; break }
    foreach ($h in $r.data) {
      Write-Output "$($h.start) | prazo: $($h.date_deadline) | $(Limpar $h.task) | por: $(Limpar $h.author) | resp.: $(Limpar ($h.responsible -join ', ')) | $(Limpar $h.comments)"
    }
  }

  'movimentos' {
    Exigir 'ProcessoId' $ProcessoId
    $r = Invoke-Advbox "movements/$ProcessoId"
    if (-not $r -or -not $r.data) { Write-Output 'SEM MOVIMENTACOES'; break }
    foreach ($m in $r.data) { Write-Output "$($m.date) | $(Limpar $m.header) | $(Limpar $m.title)" }
  }

  'publicacoes' {
    Exigir 'ProcessoId' $ProcessoId
    $r = Invoke-Advbox "publications?lawsuit_id=$ProcessoId&limit=100"
    if (-not $r -or -not $r.data) { Write-Output 'SEM PUBLICACOES'; break }
    foreach ($u in $r.data) { Write-Output "$($u.date) | $(Limpar $u.court) | $(Limpar $u.type) | prazo: $($u.deadline_start) a $($u.deadline_end) | $(Limpar $u.text)" }
  }

  'tarefas' {
    Exigir 'ProcessoId' $ProcessoId
    $r = Invoke-Advbox "posts?lawsuit_id=$ProcessoId&limit=200"
    if (-not $r -or -not $r.data) { Write-Output 'SEM TAREFAS PENDENTES'; break }
    foreach ($t in $r.data) { Write-Output "$($t.date) | prazo: $($t.date_deadline) | $(Limpar $t.task) | local: $(Limpar $t.local) | $(Limpar $t.notes)" }
  }

  'pericia' {
    Exigir 'ProcessoId' $ProcessoId
    $p = Invoke-Advbox "lawsuits/$ProcessoId"
    if (-not $p) { Write-Output 'PROCESSO NAO ENCONTRADO'; break }
    Write-Output (Linha-Processo $p)
    $achou = $false
    if ("$($p.stage)" -match $RegexPericia -or "$($p.stage)" -match 'AVALIA') {
      Write-Output "FASE ATUAL INDICA PERICIA/AVALIACAO: $($p.stage)"; $achou = $true
    }
    $h = Invoke-Advbox "history/$ProcessoId"
    foreach ($x in @($h.data)) {
      if ($x -and ("$($x.task) $($x.comments)" -match $RegexPericia)) {
        Write-Output "HISTORICO | $($x.start) | prazo: $($x.date_deadline) | $(Limpar $x.task) | local: $(Limpar $x.local) | $(Trecho $x.comments)"; $achou = $true
      }
    }
    $t = Invoke-Advbox "posts?lawsuit_id=$ProcessoId&limit=200"
    foreach ($x in @($t.data)) {
      if ($x -and ("$($x.task) $($x.notes)" -match $RegexPericia)) {
        Write-Output "TAREFA PENDENTE | $($x.date) | prazo: $($x.date_deadline) | $(Limpar $x.task) | local: $(Limpar $x.local) | $(Trecho $x.notes)"; $achou = $true
      }
    }
    $m = Invoke-Advbox "movements/$ProcessoId"
    foreach ($x in @($m.data)) {
      if ($x -and ("$($x.title)" -match $RegexPericia)) {
        Write-Output "MOVIMENTACAO | $($x.date) | $(Limpar $x.header) | $(Limpar $x.title)"; $achou = $true
      }
    }
    $u = Invoke-Advbox "publications?lawsuit_id=$ProcessoId&limit=100"
    foreach ($x in @($u.data)) {
      if (-not $x) { continue }
      # o perito aparece na lista de partes de toda publicacao do processo: tirar antes de buscar
      $texto = "$($x.text)" -replace 'PERITO\s+[^(/]+\([^)]*\)\(\)', ''
      if ($texto -match $RegexPericia) {
        Write-Output "PUBLICACAO | $($x.date) | $(Limpar $x.court) | $(Trecho $texto)"; $achou = $true
      }
    }
    if (-not $achou) { Write-Output 'NENHUMA MENCAO A PERICIA, AVALIACAO, LAUDO OU AUDIENCIA NO ADVBOX' }
  }
}
exit 0
