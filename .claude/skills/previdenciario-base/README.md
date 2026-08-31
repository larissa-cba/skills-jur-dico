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

### `references/`

Doutrina de leitura, uma por tipo de documento. Carregue só a que o caso pedir.

| Referência | Cobre |
|---|---|
| `cnis.md` | vínculos, indicadores, tipo de filiação, confronto com CTPS, segunda passada |
| `pedidos-administrativos.md` | requerimentos, concessões, indeferimentos, processos judiciais |
| `medicos.md` | laudos, atestados, perícias, incapacidade e PcD |
| `ppp.md` | tempo especial, agentes nocivos, EPI, responsável técnico |
| `rural.md` | linha do tempo rural, prova material, atividade na infância |
| `dtc-ctc.md` | contagem recíproca, utilização anterior, concomitância |
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
