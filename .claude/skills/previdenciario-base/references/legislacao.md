# Legislação

O escritório mantém um acervo curado em:

```
H:/Drives compartilhados/CBA/EQUIPE/LARISSA - JURIDICO/0 - LEGISLAÇÃO PREV/
```

Conteúdo:

| Arquivo | Serve para |
|---|---|
| `Lei 8213 de 1991.pdf` | benefícios do RGPS: requisitos, carência, espécies |
| `Lei 8212 de 1991.pdf` | custeio, contribuições, salário de contribuição |
| `Decreto n. 3048 de 1999.pdf` | regulamento: qualidade de segurado, período de graça, tempo especial |
| `IN 128 de 2022.pdf` | procedimento do INSS, indicadores do CNIS, comprovação |
| `Lei 8742 de 1993.pdf` | LOAS / BPC |
| `Lei 10259 de 2001.pdf` | juizados especiais federais |
| `Súmulas do STJ.pdf` | jurisprudência consolidada |
| `Súmulas TNU.pdf` | jurisprudência consolidada da Turma Nacional de Uniformização |
| `TEMA 1300 STF.docx` | tese vinculante |
| `I+Jornada+de+Direito+da+Seguridade+Social.pdf` | enunciados doutrinários |
| `Tabela profissões 1964.pdf` | Quadro Anexo ao Decreto 53.831/64 — tempo especial até 05/03/1997 |
| `Decreto de 79 - profissões.pdf` | Decreto 83.080/79, Anexos I (agentes) e II (grupos profissionais) — tempo especial até 05/03/1997 |
| `nr-15-atualizada-2025.pdf` e `nr-15-anexo-*.pdf` | NR-15: limites de tolerância e atividades insalubres por agente |
| `nr-16-atualizada-2025-ii.pdf` | NR-16: atividades perigosas |
| `portaria_092014-LINACH.pdf` | LINACH — lista nacional de agentes cancerígenos, com CAS |

Leitura: quase todos têm texto — use `scripts/ler-pdf.sh` e busque o dispositivo.
**Os dois decretos de 1964 e 1979 são escaneados** e precisam ser renderizados;
o de 1979 tem 236 páginas. O mapa de páginas, para renderizar só o necessário, está
em `agentes-quimicos.md`, seção 2.

**Lacuna conhecida:** o PDF do Decreto 3.048/99 não traz o **Anexo IV** (agentes
nocivos a partir de 1997), e o Decreto 2.172/97 não está no acervo. Enquadramento
de período posterior a 05/03/1997 por código do Anexo IV fica **pendente de
conferência** até o anexo entrar no acervo.

## A regra

> **Nunca afirme uma regra legal de memória.**

Vale para carência, qualidade de segurado, período de graça, regras de transição da
EC 103/2019, pedágio, pontuação, idade mínima, conversão de tempo especial, limites
de ruído por época, metodologia exigida por período, contagem recíproca, decadência
e prescrição.

Antes de escrever qualquer número ou requisito legal na ficha ou no documento de
trabalho:

1. abra o arquivo correspondente e localize o dispositivo;
2. cite-o (`art. 15, II, da Lei 8.213/91`);
3. registre no documento de trabalho qual dispositivo sustentou a conclusão.

Se não conseguiu localizar ou o ponto exige interpretação que o texto não resolve
sozinho, **escreva que depende de conferência legal** e transforme isso em linha na
tabela de providências. Marcar como pendente é sempre correto. Chutar nunca é.

## Por que isso é rígido aqui

Um número legal errado escrito com segurança é o pior defeito possível desta skill:
não dá erro, não chama atenção na revisão, e contamina a estratégia inteira. O grau
de segurança das outras conclusões existe justamente para expor incerteza — e uma
afirmação legal de memória a esconde.

## Limites

O acervo é uma seleção, não a legislação inteira. Não cobre atos normativos
posteriores à data dos arquivos, legislação estadual e municipal de RPPS, nem
jurisprudência recente fora das súmulas.

Quando a questão depender de algo que não está no acervo, diga isso — não preencha a
lacuna com memória. Esta skill não pesquisa tribunal nem consulta base de
jurisprudência externa.
