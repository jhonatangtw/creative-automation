# Changelog

## [1.1.1] — 2026-07-28

### Corrigido
- **O plugin do Premiere NÃO é opcional.** Estava documentado como opcional; sem ele a automação não cria sequência, não coloca insert e não escreve marcador. Reescrito em `REQUISITOS.md` com as duas peças necessárias (conector no claude.ai + painel conectado no Premiere) e como confirmar (`get_host_status` → `ppro: true`).
- **Regra nova em `armadilhas.md`:** rodar `get_host_status` antes de tudo e, se o Premiere não estiver conectado, **avisar e parar** — nunca editar o `.prproj` diretamente. Com o projeto aberto, o Premiere sobrescreve ao salvar e o trabalho é perdido.
- Tabela de sintomas em `COMO-USAR.md` cobre a mensagem *"não tenho ferramenta de controle ao vivo do Premiere"*.

## [1.1.0] — 2026-07-28

### Alterado
- **`estilo-ugc.md` reescrito a partir de medição real** no acervo de ativos validados da H&W (5 de 27 ADs, detecção de cena).

### O que a medição revelou
- **Existem DOIS formatos validados, não um.** Alta densidade (1 corte a cada 3–5s) e talking head puro (zero cortes). Sem meio-termo.
- **Insert não é obrigatório.** O criativo mais longo do acervo (251s) é o mais simples: plano fixo sem um corte, e valida.
- A afirmação anterior de que "o que segura retenção é insert" estava **errada como regra universal** — foi corrigida.
- O AD01 do LeafTide (1 corte a cada 8,9s) está provavelmente **subcortado** para o padrão de alta densidade da casa.
- Confirmado como padrão da casa em 100% da amostra: legenda em pílula branca, texto preto, 3–4 palavras.

### Corrigido
- Comando de medição de densidade exige `-v info`; com `-v error` o filtro não imprime e a contagem volta zero silenciosamente.

## [1.0.0] — 2026-07-28

Primeira versão. Validada em produção nos criativos AD01 e AD05 do LeafTide.

### Inclui
- Fluxo completo: bruto → transcrição → mapa de inserts → B-roll → timeline → legenda → marcações
- Geração de B-roll da mesma pessoa em roupas diferentes, casando com o cenário original
- Punch-ins com escalas variadas (110–116%)
- Legenda conferida palavra a palavra contra a copy aprovada
- Lettering animado com glow
- Marcações que citam a fala literal e a instrução do brief
- Caminho para gerar o bruto do zero (HeyGen Avatar V + clone de voz no ElevenLabs)

### Armadilhas documentadas
- Premiere em PT-BR quebra `pr_set_clip_transform` em silêncio — usar "Movimento"/"Escala"
- Dois projetos abertos fazem a escrita cair no projeto errado
- NodeIds são reciclados após salvar — reler antes de usar
- `blend=screen` em YUV deixa o vídeo inteiro magenta — converter para RGB
- Forçar idioma no Whisper produz legenda ilegível quando o áudio é inglês
- Camada de efeito com `overlay`+`enable` vaza para todos os frames — usar `tpad`
- Export do v3 do HeyGen exige `aspect_ratio`, senão sai deitado

### Limitações conhecidas
- Sem retorno de performance: não sabe qual criativo converteu
- Não escala para centenas de variações
- Não gera semelhança de pessoa real nem fabrica registro
