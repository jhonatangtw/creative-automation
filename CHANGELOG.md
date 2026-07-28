# Changelog

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
