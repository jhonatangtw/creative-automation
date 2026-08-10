---
description: Pipeline completa — do VO marcado ao criativo montado com b-roll narrativo Pixar 3D
---

Execute a pipeline completa de b-roll narrativo na sequência **$1**.

Siga a skill `broll-narrativo-pixar`. Pare e me mostre em dois portões:

**Portão 1 — marcadores.** Depois de marcar, mostre a contagem por cor e os roxos.
**Portão 2 — bíblia de elenco.** Antes de gerar qualquer imagem, mostre as âncoras de mundo,
personagem, cenário e o arco visual. Só siga depois do meu OK.

Depois dos portões:

- Planeje `takes = ceil(duração / 5.03)` por marcador, para cobrir a timeline inteira.
- Gere as imagens com as três travas (colagem, retrato, ângulo). Personagem em `nano_banana_pro`,
  desenho/gráfico em `gpt_image_2`.
- **Confira as imagens antes de animar** — rode `qc_colagem.py` e olhe os sinalizados. Refaça os
  reprovados. Vídeo custa 11× uma imagem.
- Anime no Seedance 2.0 720p com `--start-image` (caminho local).
- Importe em lotes, posicione, aplique a escala e **leia de volta**.

Me diga o custo estimado em créditos antes de disparar a geração.
