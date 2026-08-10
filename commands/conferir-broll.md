---
description: QC do b-roll gerado — colagem, rotação, letterbox, elenco e continuidade do arco visual
---

Confira o b-roll de $1.

**Automático:** rode `scripts/qc_colagem.py` na pasta das imagens. Ele sinaliza colagem de painéis,
barras de letterbox e composição rotacionada.

**Visual:** monte contact sheets e olhe os sinalizados — o detector tem falso positivo em desenho
sobre papel. Depois confira, com os olhos:

- **Elenco:** o mesmo rosto, roupa e adereço em todos os planos do mesmo personagem?
- **Arco visual:** a variável que conta a história (cabelo, peso, pele) evolui na ordem certa e só
  ela muda?
- **Enquadramentos espelhados:** os pares de abertura/fecho batem?
- **Texto queimado:** legenda ou tarja que o modelo inventou.
- **Proporção:** conteúdo composto em paisagem dentro do quadro vertical.

**Técnico:** `ffprobe` em todos — resolução, duração e integridade.

Entregue a lista de aprovados e reprovados, com o motivo de cada reprovação.
