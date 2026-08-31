# Documento de trabalho — planejamento

Fica só na pasta do cliente, ao lado do relatório, com sufixo ` - TRABALHO.docx`.
Gerado com `$BASE/scripts/gerar-docx.ps1`, marcação no cabeçalho do
próprio script.

O relatório vai para o cliente; este fica para a equipe. Aqui a linguagem é por
extenso e aqui vivem as etiquetas `forte / depende de complementação / controvertido`,
que **não** aparecem no relatório.

## Estrutura

```
NOME COMPLETO DO CLIENTE
DOCUMENTO DE TRABALHO — PLANEJAMENTO PREVIDENCIÁRIO NÍVEL [1|2|3]
Data da análise: DD/MM/AAAA

# 1. Mapeamento dos cenários

| Cenário | Arquivo de origem | Regra / espécie | Data | RMI | Grau |
|---|---|---|---|---|---|

# 2. Números que não saíram dos cálculos

| Campo | Cenário | Origem | Valor usado |
|---|---|---|---|

# 3. Premissas

# 4. O que foi removido do template

| Seção removida | Motivo |
|---|---|

# 5. Balanço de cobertura

| Arquivo | Págs | Lidas | Situação |
|---|---|---|---|

# 6. Limitações desta análise

# 7. Perguntas em aberto
```

## 1. Mapeamento dos cenários

Espelha o que foi confirmado na segunda parada. Serve para refazer o relatório depois
sem reconstruir o raciocínio, e para conferir se o cenário 3 do documento é mesmo o
que se pensou que era.

## 2. Números que não saíram dos cálculos

Toda linha aqui é um número que **você informou** e eu não extraí — tipicamente valor
investido, retorno projetado e payback. Registrar a origem é o que impede que, meses
depois, alguém trate um número informado como se tivesse sido calculado.

Coluna `Origem`: `informado pela Larissa`, `extraído do PDF X`, `calculado a partir
de Y`.

## 3. Premissas

Uma linha por premissa, com o porquê. No mínimo: qual data de referência foi adotada
e por quê, quais períodos foram tratados como incontroversos, e o que foi assumido
sobre contribuição futura.

## 4. O que foi removido do template

Uma linha por subseção removida e por nota interna apagada. É o que permite conferir
que a subseção saiu porque não se aplicava, e não por descuido.

## 5. Balanço de cobertura

Uma linha **para cada arquivo da pasta**, inclusive os lidos por inteiro. A tabela
tem que fechar com o inventário da varredura.

Situações: `Lido` · `Parcial — páginas N a M` · `Não lido — descartado na triagem` ·
`Não lido — ilegível` · `Não lido — fora do escopo`.

Cobertura reduzida em silêncio se lê como cobertura completa.

## 6. Limitações desta análise

Onde entra, com todas as letras, o que o relatório não cobre. Obrigatório quando:

- **o caso tem RPPS** — liste os arquivos de regime próprio encontrados e diga que os
  cenários dele ficaram de fora;
- documentos de leitura obrigatória faltaram na pasta;
- algum cálculo não pôde ser lido;
- o nível pedido é menor do que o material sustenta.

## 7. Perguntas em aberto

O que ficou sem resposta na parada final. Cada pergunta aberta precisa ter destino:
ou vira providência no relatório, ou vira limitação na seção 6.
