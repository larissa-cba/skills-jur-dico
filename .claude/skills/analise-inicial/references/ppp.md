# PPP — Perfil Profissiográfico Previdenciário

Seção 6 do roteiro. Principal documento do tempo especial, e o mais fácil de ler
errado.

> **Agente nocivo no PPP não é tempo especial.** A conclusão depende de atividade,
> ambiente, agente, intensidade ou concentração, período, habitualidade e
> permanência, metodologia, EPI/EPC e legislação do período — em conjunto, nunca do
> nome do agente sozinho.

Muitos PPPs são escaneados. Renderize e leia como imagem quando `varrer-pasta.sh`
marcar `IMAGEM` ou `MISTO`.

## Conferência inicial

Nome e CPF do segurado · razão social e CNPJ · período trabalhado · cargo/função ·
setor · descrição das atividades · agentes nocivos · período de exposição ·
intensidade ou concentração · metodologia · responsável pelos registros ambientais ·
EPI e EPC · data de emissão · identificação e assinatura do responsável.

## Função e atividades

Verifique se a função registrada corresponde ao que era efetivamente feito: cargo,
setor, descrição, máquinas e ferramentas, ambiente, exposição decorrente das
atividades descritas.

> Funções com o mesmo nome podem ter condições completamente distintas. O nome do
> cargo não decide nada.

Preste atenção às **observações do PPP**: é onde costumam estar as lotações,
períodos de substituição e mudanças de função que não aparecem no corpo do
documento. A ficha do exemplo do roteiro se apoia inteira nisso — períodos de
"Motorizado (M) - titular" alternados com "Motorizado (V) - substituição",
descontínuos, extraídos das observações.

## Agentes nocivos

Identifique todos: ruído · calor · agentes químicos · biológicos · radiações ·
vibração · eletricidade · poeiras e particulados · outros.

Para cada um, registre a cadeia completa:

`agente → período de exposição → intensidade/concentração → metodologia →
habitualidade/permanência → EPI/EPC → possível enquadramento`

## Período e habitualidade

A exposição valeu para todo o período do PPP ou só para parte dele? Verifique data
de início e término da exposição, mudanças de função ou setor, alterações do
ambiente, períodos sem exposição, e a coerência entre período de exposição e período
efetivamente trabalhado.

## Ruído e agentes quantitativos

Registre nível informado, unidade, técnica/metodologia, período da medição,
compatibilidade entre a metodologia e o período analisado, e variação dos níveis ao
longo do vínculo.

> Não basta existir um número no campo de ruído. Importa **como, quando e em que
> condições** a exposição foi aferida — e qual a legislação do período.

Os limites de ruído mudaram ao longo do tempo e a metodologia exigida também. **Não
escreva limite de memória**: consulte `legislacao.md`. Sem conferir, registre o
nível encontrado e marque o enquadramento como pendente de conferência legal.

## Agentes químicos e biológicos

Qual agente · qual atividade gerava a exposição · frequência e forma de contato ·
período · avaliação qualitativa ou quantitativa · EPI/EPC · informação adicional no
PPP ou LTCAT.

Havendo agente potencialmente **cancerígeno**, sinalize expressamente para análise
individualizada — o tratamento jurídico é específico.

## Responsável pelos registros ambientais

Nome, registro profissional, período de responsabilidade, datas de início e fim, e
compatibilidade com o período de trabalho analisado.

Achado recorrente e relevante: **o responsável técnico começa depois do início do
vínculo**. Quando ocorrer, registre e verifique se o documento sustenta as condições
ambientais do período anterior. No exemplo do roteiro: vínculo desde 01/02/2000,
responsável pelos registros a partir de 19/06/2000.

## EPI e EPC

A informação de fornecimento de EPI **não neutraliza automaticamente** o agente.

Verifique: identificação do EPI · número do CA · período de utilização ·
compatibilidade com o agente · informação sobre eficácia · existência de EPC ·
coerência com as condições efetivas de trabalho.

Inconsistência típica: PPP informa neutralização por EPI em período com agente
reconhecidamente cancerígeno. Destaque para análise individualizada.

## Regularidade formal

Razão social · CNPJ · identificação de quem emitiu · cargo do signatário ·
assinatura · data de emissão · coerência entre signatário e empresa.

Assinatura por quem não aparenta ter vínculo ou poderes para representar a empresa é
inconsistência a registrar.

## Confronto com outras provas

Nunca analise o PPP isolado. Cruze com CNIS, CTPS, contratos, holerites, LTCAT,
laudos ambientais, PPRA/PGR, PCMSO, documentos da empresa, processos anteriores e
provas produzidas em juízo.

Exemplo: CNIS e CTPS registram "operador de produção" de 01/2005 a 12/2010, e o PPP
descreve função diversa no mesmo período — verificar documentação laboral e
ambiental para esclarecer.

## Classificação dos períodos

Ao final, classifique cada período com um dos três graus:

- **Forte** — documentação consistente para sustentar a especialidade;
- **Depende de complementação** — há indício, faltam provas ou esclarecimentos;
- **Controvertido** — há inconsistência relevante ou obstáculo ao reconhecimento.

## Conclusão do bloco

Para cada período: `empresa → função → período → agente → intensidade/concentração →
metodologia → habitualidade/permanência → EPI/EPC → inconsistências → documentação
complementar → conclusão preliminar`.

Três perguntas que a análise precisa responder:

1. O cliente esteve efetivamente exposto a agente nocivo?
2. A documentação é suficiente e tecnicamente adequada para comprovar isso?
3. Quais períodos têm potencial de reconhecimento e quais exigem complementação ou
   discussão administrativa/judicial?

## Registro na ficha

Bloco `PPP`, uma linha por vínculo com função e período, seguida dos achados em
bullets:

```
PPP:
Carteiro de 01/02/2000 a 30/06/2008
Agente de correios de 01/07/2008 a 28/02/2010
- Profissiografia não traz a motocicleta como ferramenta de trabalho.
- Exposição a fatores de risco de 01/02/2000 a 31/12/2022 com risco postural,
  acidentes e exposição à radiação não ionizante (sol).
- Responsável pelos registros ambientais iniciou em 19/06/2000, depois do início
  do vínculo dele.
```
