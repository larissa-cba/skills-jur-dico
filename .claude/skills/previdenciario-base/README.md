# previdenciario-base

**Isto não é uma skill.** É o material que as skills previdenciárias do escritório
compartilham. Não tem `SKILL.md` de propósito: nada aqui deve ser invocado
diretamente.

Existe porque ler um CNIS é ler um CNIS, tanto para a ficha de análise inicial
quanto para o relatório de planejamento. O que muda entre as skills é o que se faz
com a leitura, não como se lê. Duplicar isso significaria corrigir cada defeito em
dois lugares — e esquecer num deles.

## Quem usa

| Skill | Para quê |
|---|---|
| `analise-inicial` | ficha de análise inicial no padrão do escritório |
| `planejamento` | relatório de planejamento previdenciário em três níveis |
| `analise-ppp` | análise de PPP recebido no curso do processo, comparação entre versões e validação do cálculo |
| `analise-rural` | controle vivo da prova do tempo rural e da pesca artesanal: enquadramento como segurado especial em economia familiar, período controvertido, graduação de cada documento e de cada trecho, atualização a cada chegada |
| `analise-medica` | análise dos documentos médicos em benefício por incapacidade, BPC da pessoa com deficiência, auxílio-acidente e aposentadoria PcD: contrato e fase no Advbox, resumo e papel de cada documento, suficiência do conjunto, se vale juntar conforme a fase, o que pedir e resumo para o sistema |

Os caminhos nas skills são relativos: `../previdenciario-base/...`. Funciona tanto
no repositório do projeto quanto em `~/.claude/skills`, desde que esta pasta fique
ao lado das skills que a usam.

## O que tem aqui

### `scripts/`

| Script | O que faz |
|---|---|
| `varrer-pasta.sh` | inventaria a pasta do cliente, diz o que é texto e o que precisa ser renderizado, soma as páginas escaneadas e checa os documentos de leitura obrigatória |
| `ler-pdf.sh` | entrega o conteúdo de um PDF: texto direto, ou páginas renderizadas em PNG quando é escaneado; **detecta renderização parcial e avisa** |
| `_poppler.sh` | encontra o poppler instalado via winget e o põe no PATH; carregado com `source` |
| `gerar-docx.ps1` | converte texto marcado em `.docx` sem depender de Word, Python ou pandoc |
| `ler-docx.ps1` | lê um `.docx` de volta para a mesma marcação do `gerar-docx.ps1` — usado para atualizar a ficha sem reescrevê-la à mão |
| `aplicar-timbrado.ps1` | escreve um texto marcado dentro do papel timbrado do escritório, preservando cabeçalho, rodapé e logotipo; tem bloco de assinaturas lado a lado |
| `html-para-pdf.ps1` | converte uma página HTML/CSS em PDF usando o Edge instalado, em modo headless |
| `listar-campos-pdf.ps1` | lista os campos de um PDF preenchível (nome, página, tipo, posição, opções, valor atual) |
| `preencher-pdf-form.ps1` | preenche um PDF preenchível a partir de um JSON, por atualização incremental, sem Python nem pdftk — usado para a autodeclaração de segurado especial |
| `advbox.ps1` | consulta **somente leitura** à API do Advbox: cliente, processos, etapa e fase, histórico, movimentações, publicações, tarefas e tudo o que menciona perícia; token fora do repositório |

### `references/`

Doutrina de leitura, uma por tipo de documento. Carregue só a que o caso pedir.

| Referência | Cobre |
|---|---|
| `cnis.md` | vínculos, indicadores, tipo de filiação, confronto com CTPS, segunda passada |
| `pedidos-administrativos.md` | requerimentos, concessões, indeferimentos, processos judiciais |
| `medicos.md` | laudos, atestados, perícias, incapacidade e PcD |
| `ppp.md` | tempo especial, agentes nocivos, EPI, responsável técnico |
| `agentes-quimicos.md` | produto × composto, régua por período, mapa dos decretos de 1964 e 1979, NR-15, NR-16 e LINACH |
| `rural.md` | linha do tempo rural, prova material, atividade na infância |
| `autodeclaracao-campos.md` | mapa campo a campo dos formulários de autodeclaração rural e do pescador (Ofício 46), para preenchimento automático |
| `segurado-especial.md` | enquadramento como segurado especial (produtor rural e pescador artesanal), economia familiar, descaracterização, Ofício-Circular 46/DIRBEN, autodeclarações e súmulas |
| `dtc-ctc.md` | contagem recíproca, utilização anterior, concomitância |
| `advbox.md` | API do Advbox: acesso, token, script, significado dos campos e das etapas do escritório, limitações |
| `legislacao.md` | acervo do escritório e a regra de nunca afirmar lei de memória |
| `ambiente.md` | ferramentas, caminhos e limites desta máquina |

## As regras que valem para toda skill que usa este material

**Nunca afirme uma regra legal de memória.** Consulte o acervo e cite o dispositivo.
Ver `references/legislacao.md`.

**Custo nunca justifica pular categoria de documento.** É motivo para parar e
perguntar, nunca para decidir sozinho que algo fica de fora.

**Nunca declare lido o que não foi lido.** `ler-pdf.sh` sai com código 4 quando
renderiza menos páginas do que o PDF tem — o Drive em streaming interrompe em
silêncio. Trate como leitura parcial e registre a lacuna.

**Toda análise termina com um balanço de cobertura**: o que foi lido por inteiro, o
que foi lido em parte, o que não foi lido e por quê. Cada skill decide onde registra
isso, mas nenhuma pode omiti-lo.

**Diagnóstico não é incapacidade. Agente nocivo no PPP não é tempo especial.**
