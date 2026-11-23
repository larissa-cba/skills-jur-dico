# Minuta de pedido de retificação de PPP

Gerada **só quando aprovada** na segunda parada. É uma minuta: a equipe revisa,
ajusta e envia. A skill não envia nada.

Fica em:
`<pasta do cliente>/ANÁLISE INICIAL/PEDIDO DE RETIFICAÇÃO DE PPP - <EMPRESA> - <DD.MM.AAAA>.docx`

Nunca sobrescreva um pedido anterior: a data no nome distingue o primeiro pedido da
reiteração, e o anterior é a prova do que já foi pedido.

## Papel timbrado

A minuta sai **sempre no papel timbrado do escritório**, que fica em:

```
H:/Drives compartilhados/CBA/EQUIPE/LARISSA - JURIDICO/3 - PETIÇÕES/Papel timbrado Cristhiane Barreto 2025.docx
```

Se não estiver lá, **pare e pergunte** onde está. Não gere a minuta em papel branco
nem com `gerar-docx.ps1`.

Monte o texto em `.txt` UTF-8 e converta:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/aplicar-timbrado.ps1" \
  -Timbrado "<papel timbrado .docx>" -Origem "<minuta.txt>" -Destino "<PEDIDO ... .docx>"
```

O script preserva cabeçalho, rodapé, logotipo, margens e a fonte do timbrado, e
recusa sobrescrever destino existente. Marcação: a do `gerar-docx.ps1` (`# negrito`,
`**trecho**`, `|tabela|`), mais `>> ` para alinhar à direita, `^^ ` para centralizar
e `@@assinaturas` para o bloco de assinaturas.

Depois do `.docx`, gere o PDF ao lado, para conferência visual:

```bash
powershell -ExecutionPolicy Bypass -File "$BASE/scripts/exportar-pdf.ps1" -Origem "<PEDIDO ... .docx>"
```

Renderize a primeira e a última página do PDF e **olhe**: logotipo no cabeçalho,
rodapé com endereço, assinaturas juntas e inteiras. Se o PDF falhar (Word
indisponível), entregue o `.docx` e diga que a conferência visual não foi feita.

## Assinaturas

Fixas, sempre as duas, nesta ordem:

| Nome | Inscrição |
|---|---|
| Cristhiane Constantino Barreto | OAB/SC 20.738 |
| Larissa Marghoti dos Santos | OAB/SC 63.521 |

Na marcação, a linha é exatamente:

```
Atenciosamente,
@@assinaturas Cristhiane Constantino Barreto;OAB/SC 20.738|Larissa Marghoti dos Santos;OAB/SC 63.521
```

`Atenciosamente,` imediatamente antes, sem linha vazia no meio — o script prende
os dois para que a despedida não fique numa página e as assinaturas em outra.

## Quando cabe

Cabe pedir retificação de defeito que **a empresa pode corrigir** no PPP:

- campo obrigatório ausente ou em branco (metodologia, intensidade, responsável
  técnico, CA do EPI, assinatura, identificação do signatário);
- informação incorreta ou divergente de outro documento da própria empresa (cargo,
  setor, período, descrição das atividades diferente da CTPS ou do LTCAT);
- responsável pelos registros ambientais só a partir de data posterior ao início do
  vínculo, quando há laudo contemporâneo que a empresa pode indicar;
- período de exposição menor que o período trabalhado sem justificativa;
- dados do segurado errados.

Não cabe — ou cabe com cuidado, e vai como pergunta na parada:

- discordância de **mérito técnico** (o segurado acha que o ruído era maior do que o
  medido): a empresa não vai "corrigir" uma medição; o caminho é prova técnica;
- pedido para **retirar** informação de EPI eficaz sem fundamento técnico;
- empresa extinta ou sem representante: o caminho é outro (similaridade, perícia
  indireta) — registre como providência, não como pedido.

## Estrutura

O modelo abaixo está quebrado em várias linhas só para leitura. No `.txt` da
minuta, **cada parágrafo vai numa linha só** — o script transforma cada quebra de
linha num parágrafo novo.

```
>> Florianópolis, <data por extenso>.

À
<RAZÃO SOCIAL DA EMPRESA>
CNPJ <número>
<endereço, se constar no PPP ou na pasta>
A/C Departamento de Recursos Humanos / Segurança do Trabalho

# Assunto: Solicitação de retificação de Perfil Profissiográfico Previdenciário (PPP)

Prezados,

<NOME DO SEGURADO>, ex-empregado(a) / empregado(a) dessa empresa no período de
<início> a <fim>, no cargo de <cargo>, por intermédio de suas procuradoras, vem
solicitar a retificação do Perfil Profissiográfico Previdenciário emitido em
<data de emissão>, pelos motivos abaixo.

# Itens a retificar

1. <Campo do PPP> — <o que consta hoje>. <O que deveria constar e por quê,
   apontando o documento que mostra a divergência, quando houver.>
2. ...

# Pedido

Solicita-se a emissão de novo PPP com as correções acima, devidamente assinado pelo
representante legal da empresa ou por preposto com poderes, com a identificação do
signatário, acompanhado, se possível, de cópia do LTCAT que lhe dá suporte.

<Fundamento normativo da obrigação de fornecer e manter atualizado o PPP —
**só depois de conferido no acervo**, com o dispositivo citado.>

Atenciosamente,
@@assinaturas Cristhiane Constantino Barreto;OAB/SC 20.738|Larissa Marghoti dos Santos;OAB/SC 63.521
```

## Regras

**Fundamento legal só do acervo.** A obrigação da empresa de emitir e manter o PPP
atualizado tem base normativa — consulte `../previdenciario-base/references/legislacao.md`,
abra o Decreto 3.048/99 e a IN 128/2022 no acervo, localize o dispositivo e cite-o.
Sem ter localizado, deixe o parágrafo como
`[FUNDAMENTO NORMATIVO — conferir no acervo antes de enviar]`. Nunca preencha de
memória.

**Agente químico genérico é item de retificação.** Se o PPP nomeia só o produto
("óleo mineral", "diesel", "solvente", "produtos químicos"), peça a composição
conforme a FISPQ e, quando a norma distinguir, a característica que ela exige (óleo
mineral não tratado ou pouco tratado; presença de hidrocarbonetos aromáticos). Ver
`../../previdenciario-base/references/agentes-quimicos.md`.

**Itens específicos e verificáveis.** Cada item diz o campo, o que está escrito, o
que deveria estar e qual documento comprova. "Corrigir a descrição das atividades"
não serve; "a descrição das atividades (campo 14) registra função administrativa,
enquanto a CTPS (fl. 12) e o contrato de trabalho registram operador de prensa"
serve.

**Tom cordial e técnico.** É uma solicitação, não notificação extrajudicial. Nada
de ameaça de ação.

**Campos que a skill não sabe** — endereço ou CNPJ da empresa quando não constam
na pasta — saem entre colchetes, em maiúsculas, `[ENDEREÇO DA EMPRESA]`, para a
equipe ver de relance o que falta. Local (Florianópolis) e assinaturas são fixos:
não pergunte.

**Reiteração.** Se já existe pedido anterior na pasta, a minuta nova começa
referindo o pedido anterior pela data, lista só os itens **não atendidos** e diz o
que foi corrigido, para mostrar boa-fé.

**Dados do segurado** necessários à identificação (nome, cargo, período) entram na
minuta porque ela vai para a empresa. CPF e NIT entram só se a empresa precisar para
localizar o registro — pergunte.
