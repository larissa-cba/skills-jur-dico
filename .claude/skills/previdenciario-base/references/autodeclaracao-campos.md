# Autodeclaração — mapa dos campos dos formulários

Os dois formulários do Ofício-Circular 46/DIRBEN no acervo são **PDF preenchíveis**
(AcroForm), mas os campos têm nomes genéricos ("Caixa de texto 14_2"). Este mapa diz
**qual campo é qual** — conferido visualmente em 24/11/2026, preenchendo cada campo
com o próprio nome e renderizando as páginas.

| Formulário | Arquivo no acervo (`0 - LEGISLAÇÃO PREV/`) | Páginas | Campos |
|---|---|---|---|
| Rural (Anexo I) | `anexo_i___autodeclaracao_do_segurado_especial_rural.pdf` | 3 | 164 |
| Pescador (Anexo II) | `autodeclaracao-do-segurado-especial-pescador-pdf.pdf` | 4 | 134 |

## Scripts

```bash
# listar os campos (nome, página, tipo, posição, opções)
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/listar-campos-pdf.ps1" -Origem "<form.pdf>" [-Destino "campos.tsv"]

# preencher a partir de um JSON { "<nome do campo>": "<valor>" }
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/preencher-pdf-form.ps1" -Origem "<form.pdf>" -Valores "<valores.json>" -Destino "<saida.pdf>"
```

- Use o **nome técnico exatamente como está nas tabelas abaixo**, com os `#C3#A7`
  (é assim que o LibreOffice gravou os nomes com "ç" e "ã").
- Caixa de seleção: `"Yes"` marca, `"Off"` desmarca. Campo que não vai no JSON fica
  como está no formulário (em branco).
- Lista suspensa do formulário rural (destinação): só aceita `Subsistência`, `Venda`
  ou `Subsistência/Venda`.
- O JSON é gravado em UTF-8; acentos saem corretos no PDF.
- O PDF sai **editável** — a equipe ou o cliente completam o que ficou em branco.

**Se o formulário do acervo for substituído** (nova versão, IN 128), os nomes mudam:
rode `listar-campos-pdf.ps1`, repita a conferência visual e atualize este mapa antes
de preencher.

Prefixos usados abaixo: `T` = `Caixa de texto `, `S` = `Caixa de sele#C3#A7#C3#A3o `,
`C` = `Caixa de combina#C3#A7#C3#A3o `. Ex.: `T14_2` = `Caixa de texto 14_2`;
`S1_11` = `Caixa de sele#C3#A7#C3#A3o 1_11`.

## Formulário rural (Anexo I)

### 1. Dados do segurado — página 1

| Campo | Nome |
|---|---|
| Nome | T1 |
| Apelido | T3 |
| Data de nascimento | T2 |
| Local de nascimento | T4 |
| Endereço residencial | T5 |
| Município | T6 |
| UF | T7 |
| CPF | T9 |
| RG | T10 |
| Data/local de expedição do RG | T11 |

### 2. Períodos de atividade rural — página 1

| Linha | Período | Condição em relação ao imóvel | Individual | Economia familiar |
|---|---|---|---|---|
| 1 | T14 | T14_4 | S1 | S1_2 |
| 2 | T14_2 | T14_3 | S1_3 | S1_4 |
| 3 | T14_5 | T14_6 | S1_5 | S1_6 |
| 4 | T14_7 | T14_8 | S1_7 | S1_8 |
| 5 | T12 | T14_9 | S1_9 | S1_10 |

Condição: proprietário, possuidor, comodatário, arrendatário, parceiro, meeiro,
usufrutuário, condômino, posseiro, assentado, acampado.

**2.1 — condição no grupo na data do requerimento:** Titular `S1_11`; Componente `S1_12`.

**2.2 — grupo familiar** (página 1):

| Membro | Nome | Nascimento | CPF | Estado civil | Parentesco |
|---|---|---|---|---|---|
| 1 | T17 | T17_2 | T17_3 | T17_5 | T17_4 |
| 2 | T17_6 | T17_7 | T17_8 | T17_10 | T17_9 |
| 3 | T17_11 | T17_12 | T17_13 | T17_15 | T17_14 |
| 4 | T17_16 | T17_17 | T17_18 | T17_20 | T17_19 |

### 3. Cessão da terra — página 2

| Linha | Forma de cessão | Período | Área cedida (ha) |
|---|---|---|---|
| 1 | T19 | T19_2 | T19_3 |
| 2 | T19_4 | T19_5 | T19_6 |
| 3 | T19_7 | T19_8 | T19_9 |
| 4 | T19_10 | T19_11 | T19_12 |
| 5 | T19_13 | T19_14 | T19_15 |

### 3.1. Dados das terras — página 2

| Imóvel | Registro ITR | Nome da propriedade | Município/UF | Área total (ha) | Área explorada (ha) | Proprietário | CPF do proprietário |
|---|---|---|---|---|---|---|---|
| 1 | T8 | T8_6 | T8_25 | T8_15 | T8_16 | T8_26 | T8_31 |
| 2 | T8_2 | T8_7 | T8_11 | T8_17 | T8_18 | T8_27 | T8_32 |
| 3 | T8_3 | T8_8 | T8_12 | T8_20 | T8_19 | T8_28 | T8_33 |
| 4 | T8_4 | T8_9 | T8_13 | T8_21 | T8_22 | T8_29 | T8_34 |
| 5 | T8_5 | T8_10 | T8_14 | T8_23 | T8_24 | T8_30 | T8_35 |

Atenção às linhas 3 a 5: a ordem dos nomes de área total e área explorada **não**
segue a numeração — use a tabela.

### 3.2. Atividade e destinação — página 2

| Linha | Atividade | Subsistência/Venda (lista) |
|---|---|---|
| 1 | T14_10 | C1 |
| 2 | T14_11 | C1_2 |
| 3 | T14_12 | C1_3 |

### 3.3. IPI sobre a venda — página 2

Sim `S1_13`; Não `S1_14`. Períodos: `T13`, `T14_13`, `T14_14`.

### 3.4. Empregados ou prestadores — página 3

Sim `S1_15`; Não `S1_16`.

| Linha | Nome | CPF | Período |
|---|---|---|---|
| 1 | T14_15 | T14_16 | T14_17 |
| 2 | T14_18 | T14_19 | T14_20 |
| 3 | T14_21 | T14_22 | T14_23 |

### 4. Outra atividade ou renda — página 3

Sim `S1_17`; Não `S1_18`.

| Linha | Atividade/renda | Local | Período |
|---|---|---|---|
| 1 | T14_24 | T14_25 | T14_26 |
| 2 | T14_30 | T14_31 | T14_27 |
| 3 | T14_29 | T14_28 | T14_32 |

### 4.1. Renda de turismo, arte, artesanato, dirigente, vereador — página 3

Sim `S1_19`; Não `S1_20`.

| Linha | Atividade | Período | Renda (R$) | Outras informações |
|---|---|---|---|---|
| 1 | T14_33 | T14_34 | T14_35 | T14_36 |
| 2 | T14_52 | T14_45 | T14_44 | T14_37 |
| 3 | T14_51 | T14_46 | T14_43 | T14_38 |
| 4 | T14_50 | T14_47 | T14_42 | T14_39 |
| 5 | T14_49 | T14_48 | T14_41 | T14_40 |

### 4.2. Cooperativa — página 3

Sim `S1_21`; Não `S1_22`. Entidade `T14_53`; CNPJ `T14_54`; agropecuária ou de
crédito rural `T14_55`.

### Fecho — página 3

Local `T15`; Data `T16`. Assinatura e polegar: no papel.

## Formulário do pescador (Anexo II)

Mesmos prefixos; aqui as caixas de seleção usam a família `S5`.

### 1. Dados do segurado — página 1

| Campo | Nome |
|---|---|
| Nome | T1 |
| Apelido | T3 |
| Data de nascimento | T3_2 |
| Local de nascimento | T3_3 |
| Endereço residencial | T5 |
| Município | T6 |
| UF | T7 |
| CPF | T8 |
| RG | T8_2 |
| Data/local de expedição do RG | T8_3 |
| RGP | T8_4 |
| Matrícula CEI/CAEPF | T8_5 |

### 2. Períodos de atividade de pesca — página 1

| Linha | Período | Local onde exerce (mar, rio, estuário, lagoa, açude, represa) | Individualmente | Economia familiar |
|---|---|---|---|---|
| 1 | T9 | T9_2 | S5 | S6 |
| 2 | T9_3 | T9_4 | S7 | S8 |
| 3 | T9_5 | T9_6 | S9 | S10 |

**2.1 — condição no grupo:** Titular `S5_2`; Componente `S5_3`.

**2.2 — grupo familiar** (página 1):

| Membro | Nome | Nascimento | CPF | Estado civil | Parentesco |
|---|---|---|---|---|---|
| 1 | T1_2 | T1_3 | T1_4 | T1_5 | T1_6 |
| 2 | T1_7 | T1_8 | T1_9 | T1_10 | T1_11 |
| 3 | T1_12 | T1_13 | T1_14 | T1_15 | T1_16 |
| 4 | T1_17 | T1_18 | T1_19 | T1_20 | T1_21 |

### 3. Condição em relação à embarcação — páginas 1 e 2

| Linha | Período | Condição | Arqueação bruta (AB) |
|---|---|---|---|
| 1 (p. 1) | T9_7 | T9_8 | T9_9 |
| 2 (p. 2) | T9_10 | T9_11 | T9_12 |
| 3 | T9_13 | T9_14 | T9_15 |
| 4 | T9_16 | T9_17 | T9_18 |
| 5 | T9_19 | T9_20 | T9_21 |

Condição: arrendatário, comodatário, meeiro, parceiro, proprietário, pescador
artesanal ou mariscador sem embarcação.

### 3.1. Arrendamento da embarcação própria — página 2

Períodos: `T2_5`, `T2_6`, `T2_7`, `T2_8`.

### 3.2. Titulares da embarcação — página 2

| Linha | Nome | CPF | Período |
|---|---|---|---|
| 1 | T9_22 | T9_23 | T9_27 |
| 2 | T9_24 | T9_25 | T9_28 |
| 3 | T4 | T9_26 | T9_29 |

### 3.3. Atividade pesqueira — página 2

| Linha | Atividade (pescador de tambaqui, de ostra…) | Subsistência/Venda (texto livre) |
|---|---|---|
| 1 | T9_30 | T9_33 |
| 2 | T9_31 | T9_34 |
| 3 | T9_32 | T9_35 |

### 3.4. IPI sobre a venda — página 2

Sim `S5_4`; Não `S1` (sic — é `Caixa de sele#C3#A7#C3#A3o 1`). Períodos: `T2`,
`T2_2`, `T2_3`, `T2_4`.

### 3.5. Empregados ou prestadores — página 2

Sim `S5_5`; Não `S5_6`.

| Linha | Nome | CPF | Período |
|---|---|---|---|
| 1 | T10 | T10_2 | T10_3 |
| 2 | T10_4 | T10_5 | T10_6 |

### 4. Outra atividade ou renda — página 3

Sem caixa de Sim/Não neste formulário.

| Linha | Atividade | Local | Período |
|---|---|---|---|
| 1 | T10_7 | T11 | T13 |
| 2 | T10_8 | T11_2 | T13_2 |
| 3 | T10_9 | T11_3 | T13_3 |
| 4 | T10_10 | T11_4 | T13_4 |
| 5 | T10_11 | T11_5 | T13_5 |

### 4.1. Renda de turismo, arte, artesanato, dirigente, vereador — página 3

Sim `S5_9`; Não `S5_10`.

| Linha | Atividade | Período | Renda (R$) | Outras informações |
|---|---|---|---|---|
| 1 | T10_12 | T10_13 | T10_22 | T10_14 |
| 2 | T10_15 | T10_16 | T10_23 | T10_17 |
| 3 | T10_18 | T10_20 | T10_24 | T10_26 |
| 4 | T10_19 | T10_21 | T10_25 | T10_27 |

### 4.2. Cooperativa — página 3

Sim `S5_7`; Não `S5_8`. Entidade `T14`; CNPJ `T15`; agropecuária ou de crédito rural
`T16`.

### Fecho — página 4

Local `T17`; Data `T17_2`. Assinatura e polegar: no papel.
