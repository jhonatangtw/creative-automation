---
description: Marca a timeline de uma VSL/AD a partir da locução — trechos ancorados na fala, numerados e coloridos
---

Marque a sequência **$1** do projeto aberto no Premiere.

Copy de referência: $2

Siga a skill `broll-narrativo-pixar`, etapas 1 a 3:

1. Leia a sequência ativa (`pr_marcadores_info`, `pr_timeline_listar`) e identifique os clipes de VO
   com seus offsets. Se houver sobreposição, **transcreva cada arquivo separado** e converta para
   tempo de timeline.
2. Transcreva com timestamps de palavra. Cruze com a copy: corrija erro de ASR e liste os trechos
   que existem na copy e não aparecem na transcrição.
3. Crie marcadores de **TRECHO** cobrindo a janela real da fala, no padrão `NN - TIPO - descrição`:
   - vermelho (1) `B-ROLL` — esticado até o próximo, começando em 0, sem buraco
   - azul (6) `LETTERING` — colado na fala
   - roxo (2) `COPY` — conflito de copy, nome real citado, claim sensível, vão sem transcrição

Não gere nenhuma imagem. Ao terminar, mostre a contagem por cor, a cobertura do vermelho e a lista
dos roxos com o que cada um precisa de decisão.
