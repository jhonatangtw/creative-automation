# Estilo UGC — padrão extraído da referência aprovada

Use como default quando não houver vídeo de referência. Quando houver, **a referência manda** — extrair dela por mosaico de frames e sobrescrever o que estiver aqui.

## Proporção do tempo

| Elemento | Proporção |
|---|---|
| Talking head | ~70% do tempo |
| Inserts de B-roll | 4–5 em ~2min, 4–8s cada |
| Punch-in | 3–4 janelas, nos beats sem B-roll |

Menos é mais. Insert espalhado vira videoclipe e perde o cheiro de depoimento.

## Legenda

- Pílula branca **opaca**, cantos arredondados (raio ~20px em 1080 de largura)
- Texto **preto**, bold arredondado (`Arial Rounded Bold` no macOS), ~60px
- **Caso da copy, NÃO caixa alta.** O padrão é `--caixa original`. Caixa alta perde a pontuação de leitura e descaracteriza nome próprio (`MOUNJARO` some no meio do bloco). Só usar `--caixa alta` se o usuário pedir.
- Depois de gerar, conferir o caso **de forma sensível a maiúscula** contra a copy — o diff normal do `conferir_legenda.py` normaliza tudo e não pega isso. O Whisper quebra frase em lugar diferente da copy e capitaliza errado, sobretudo em fala entre aspas (`It's okay. You can let go...`). Realinhar palavra a palavra pelo índice.
- 3–4 palavras por bloco
- Centro horizontal, **y ≈ 73%** da altura
- Quebra respeitando frase: sempre após `. ! ?`, após `,` se o bloco já tem 2+ palavras, teto de 4 palavras
- Nunca separar número da unidade (`12 DAYS`, não `12` / `DAYS`)

## Inserts — onde entram

O único critério é **casamento verbal-visual**: o insert entra no segundo em que a fala o descreve. Os pontos que sempre se pagam num criativo de emagrecimento/suplemento:

| Momento da copy | Insert |
|---|---|
| Prova física ("troquei o guarda-roupa", "minha barriga sumiu") | Ela **de outra roupa**, mostrando a mudança |
| A receita / o mecanismo | Preparo, mãos, macro do produto |
| Tentativas que falharam | Opcional — só se sobrar espaço |
| Payoff / callback perto do CTA | Callback da primeira prova, roupa nova |

## Punch-in

Escala entre **110% e 116%**, **variando entre as janelas**. Escala igual em todas vira tique perceptível.

Corte seco para dentro e para fora — nada de zoom animado, que lê como corporativo. Aplicar nos beats de virada emocional onde não há B-roll cobrindo.

## Transição

**Nenhuma.** Corte seco. A referência aprovada não usa transição em lugar nenhum.

Se o usuário pedir explicitamente, só flash — e discreto. Ver `armadilhas.md`.

## Áudio

Body de TTS já vem empacotado, sem tempo morto. Não procurar silêncio para cortar.

Música de fundo e transição são finalização do usuário no Premiere — não fazer por ele salvo pedido explícito.
