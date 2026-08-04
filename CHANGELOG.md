# Changelog

## 1.7.1

**Os scripts do formato 2.** Rodaram os tres ADs do LinfaFlow no scratchpad de uma sessao; agora sao codigo da skill.

| | |
|---|---|
| `scripts/audio_da_timeline.py` | reconstroi o audio como ele toca na timeline |
| `scripts/mapear_vaos.py` | mapeia o que falta de video e gera o esqueleto de marcadores |
| `scripts/gerar_lote.py` | fila de geracao no CLI do Higgsfield, com retry e backoff |

Cada um carrega uma trava que veio de erro real:

- **`audio_da_timeline.py` aborta se a duracao nao bater** com a da sequencia. Locucao picotada em 24 pedacos com offsets diferentes da timecode errado se transcrita dos arquivos originais — e o mapa de marcacao inteiro sai torto. Testado contra o AD02: 711,29 contra 711,28.
- **`mapear_vaos.py` nunca gera cena acima de 15 s**, o teto do Seedance. Reproduz o AD02 exatamente: 8 vaos, 457,5 s, 64% sem video.
- **`gerar_lote.py` roda com 4 workers**, nao 8. O teto da conta e dividido com a equipe, e lote grande faz metade falhar calada. Escreve o indice com lock e relendo antes de gravar — dois processos no mesmo JSON ja custaram 7 URLs apagadas. E **pula o que ja esta pronto**, entao rodar de novo e seguro.

Os nomes do esqueleto saem como `(descrever)` de proposito. Marcador precisa dizer o que colocar; 47 marcadores identicos nao ajudam ninguem.


## 1.7.0

**Abertura reescrita: descobrir primeiro, perguntar depois.**

A etapa 0 só perguntava qual MCP usar. Faltava tudo que trava um job de verdade — onde está o material, se existe copy, que formato é — e sobrava pergunta cuja resposta é sempre a mesma.

Agora são **duas listas, nessa ordem**.

**`0a` — descobrir sozinho, numa rodada só:** se o Premiere está aberto e com qual projeto e sequência, se já existe edição e onde estão os vãos, se Tools PRO e Higgsfield respondem, se o CLI está autenticado. E na pasta da demanda: folhas de personagem e B-roll já gerado.

Perguntar o que dá para ler na tela atrasa o trabalho e faz o usuário repetir o óbvio.

Dois sinais de alarme entram aqui, os dois vistos em produção: **sequência ativa duplicada** na listagem costuma ser mais de um projeto aberto; e **nome de projeto batendo com a demanda não garante nada** — um `AD08.prproj` aberto era outro job com o mesmo nome, e só o conteúdo da timeline denunciou.

**`0b` — cinco perguntas, em bloco:**

1. Onde está o material
2. Tem a copy? *(opcional)*
3. Qual formato *(resposta livre)*
4. Até onde vai a entrega
5. MCP ou CLI do Higgsfield

**O formato é resposta livre, não lista fechada.** A operação trabalha com cinco formatos — Criativos, VSL, Microleads, Lead, Troca de potes — e o que a skill documenta são duas variações dentro de Criativos. Se a resposta não for nenhuma das duas, **não forçar no molde de UGC**: pedir um job já feito daquele formato e deduzir o processo olhando o resultado. Formato que se repetir vira referência própria em `references/`.

**A copy entrou porque é ela que corrige a transcrição.** O Whisper acerta o timing e erra nome próprio — saíram "Stalinger" por Stillingia, "Monjaro" por Mounjaro, "Brickly ash" por Prickly Ash. A regra é **timing do áudio, texto da copy**. Ela ainda traz o brief de edição, os hooks e o nome dos personagens.

### O que deixou de ser pergunta

Quatro coisas viraram **regra fixa**, porque a resposta nunca muda:

- **Quem opera a timeline é o Tools PRO** — o Higgsfield gera, o Tools PRO monta; somam, não competem
- **A conta do Higgsfield é da equipe** — fila de 4 no teto de 8 jobs Seedance, e nunca medir custo por diferença de saldo
- **Gerar sem texto nenhum na tela** — a legenda é feita à mão pelo editor
- **Seedance `fast`, 720p, máximo 15 s** — mínimo do modelo é 4 s

### Manifesto

`marketplace.json` ainda descrevia só o formato UGC — é o texto que a equipe lê na hora de instalar. Corrigido junto com a descrição do plugin.


## 1.6.0

**Segundo formato: VSL narrada em 3D estilo Pixar.**

A skill nasceu para body de avatar em plano fixo com poucos inserts. A casa produz também um formato onde **não há avatar filmado nenhum** — 8 a 12 minutos de locução e 40 a 50 cenas inteiramente geradas. `references/historia-3d-pixar.md` documenta esse caminho.

Validado nos **AD08, AD02 e AD04** do LinfaFlow: 134 cenas geradas, conferidas e montadas nas três timelines.

**O risco central muda.** No formato UGC é o insert não casar com a fala. Aqui é **o personagem mudar de rosto entre as cenas** — e a resposta não é o texto do prompt. É a **imagem-âncora passada em `--image-references` em toda geração**. Descrever "mulher de 47 anos, cabelo castanho" em 51 prompts produz 51 mulheres diferentes.

Três coisas que só se aprendem fazendo:

- A âncora de **estilo** é separada da de personagem, e para acertar o render da casa tem que ser **um frame do próprio anúncio de referência**. Descrever "estilo Pixar" em texto produz fotorrealismo tipo scan 3D.
- Os estados **antes** e **depois** são duas âncoras, e a segunda é gerada **a partir da primeira** — senão vira outra atriz e a transformação, que é o que o anúncio vende, perde o sentido.
- Se a âncora do "depois" usa uma roupa marcante, ela **vaza** para as cenas anteriores. Precisa de uma variante casual.

**Marcação sobre timeline já editada.** Nos três ADs a primeira metade estava pronta e a segunda vazia — 64% e 63% sem vídeo. O fluxo agora mapeia os vãos em vez de tratar a linha inteira, e ganhou um tipo de marcador: **REAPROVEITAR**, para o material já gerado que está parado. Havia 9 clipes prontos que ninguém usava — não estavam nem importados no projeto, e por isso ninguém conseguia arrastá-los.

**Reconstruir o áudio como ele toca na timeline.** Quando a locução está picotada em dezenas de pedaços com offsets diferentes, às vezes em duas trilhas, transcrever os arquivos originais dá timecode errado. Remontar com ffmpeg a partir de `pr_timeline_listar` e conferir que a duração bate antes de transcrever.

**Sincronia vale mais que timeline sem buraco.** Fechar vão encaixando cada clipe onde o anterior termina adiantou cenas em até 9 segundos — a praia da semana três aparecia antes da narração falar dela. Clipe no tempo do seu marcador; antecipar só abaixo de ~1,5 s.

### Armadilhas novas em `armadilhas.md`

Nove do Higgsfield em escala e duas do Premiere. As que mais custaram:

- **Teto de 8 jobs Seedance simultâneos**, compartilhado com a equipe. Lote de 39 faz 15 falharem calado, se você não imprimir o retorno do submit.
- **Frame de estilo com rosto contamina cena sem personagem** — o protagonista apareceu como pessoa real em 7 cenas de produto.
- **O rótulo do produto some** se não for exigido de frente e legível. Conferir rótulo no QA, não só rosto.
- **Corpo humano translúcido é barrado como `nsfw`**, mesmo como ilustração médica.
- **Não medir custo por diferença de saldo** em conta compartilhada: deu 445 lidos contra 207,5 reais.
- **Dois processos gravando o mesmo JSON se sobrescrevem** — 7 URLs apagadas, recuperadas pelo histórico.

### O que isso economiza

QA da **imagem** antes de animar. Imagem custa 2 créditos, vídeo de 12 s custa 42. Nos três ADs o QA pegou 13 defeitos: 26 créditos para corrigir contra ~550 se tivessem virado vídeo.

E **Seedance `fast`** em vez de `std`: 3,5 créditos por segundo contra 4,5, sem perda no QA frame a frame.


## 1.5.1

**Git nos requisitos.** Ele não aparecia em NENHUM documento de instalação — e é o requisito do primeiro passo: `/plugin marketplace add` clona um repositório.

Sem git a instalação para com `Command 'git' not found or is in an unsafe location`, e quem cai nisso não tem como se diagnosticar: o `diagnostico.sh` checa git, mas para tê-lo é preciso clonar o repo, o que exige git.

Inclui o aviso de reabrir o VS Code no Windows — o PATH só é lido em processo novo.


## 1.5.0

**Documentação de uso.** `references/como-pedir-marcacoes.md` — escrita para quem *usa* a automação, não para quem a executa.

Traz o prompt pronto, por que o nome exato da sequência é a parte mais importante (foi o que causou a perda de 17 marcadores num job real), as três coisas que mais mudam o resultado, e o checklist de instalação separando o que é necessário para **marcar** do que só serve para **gerar** b-roll.

O ponto prático: marcar é 100% local. Não precisa de Higgsfield, nem de chave de API — ou seja, dispensa justamente a etapa que mais trava na instalação.


## 1.4.0

**Edição de timeline, e a regra de ler de volta.**

O Tools PRO 1.2.0 trouxe `pr_timeline_listar`, `pr_timeline_remover` e `pr_timeline_mudo`. Com o leitor, a skill passa a **conferir** o que escreveu em vez de confiar no retorno da ferramenta.

- **B-roll entra com áudio** — `pr_timeline_colocar` traz o áudio nativo junto, e ele briga com a voz do avatar. O passo 8 agora manda tirar. Isso aconteceu de verdade num teste: dois b-rolls colocados, `colocados: 2` de resposta, e o áudio em A3 sem ninguém notar.
- **Ler de volta virou obrigatório**, não zelo extra. Retorno de sucesso diz que a chamada não deu erro — não que o resultado está certo.
- `pr_timeline_remover` deixa o buraco por padrão: *ripple* numa timeline sincronizada com áudio desalinha tudo que vem depois, então tem que ser pedido.

Requer Editor Black Belt Tools PRO **1.2.0** ou superior.


## 1.3.0

**A skill agora pergunta qual MCP usar.** Existem dois servidores que falam com o Adobe e eles somam: o **Tools PRO** (painel do Editor Black Belt, local, sem login) opera a timeline; o **Higgsfield** gera imagem e vídeo. A escolha de quem opera passa a ser do usuário — a automação não decide sozinha.

- `references/mcp-premiere.md` — referência nova: como conectar, as 24 ferramentas do Premiere e 10 do AE, as travas e a convenção de cor
- Passo 0 do fluxo: descobrir quem está vivo e **perguntar**
- Passo 8 deixou de ser opcional — com o Tools PRO dá para entregar o projeto editável
- `SETUP-MCP.md` reescrito: o caminho do Tools PRO leva 2 minutos e não tem OAuth, então o `invalid_request: redirect_uri` deixou de ser o obstáculo principal
- `armadilhas.md`: três lições novas — declarar a sequência antes de escrever, o AutoClip cortando em marcador de anotação, e simular antes de destruir
- `diagnostico.sh` passa a esperar `toolspro-pr` na lista de MCPs

Requer Editor Black Belt Tools PRO **1.1.0** ou superior.


## [1.2.0] — 2026-07-29

### Adicionado
- **`SETUP-MCP.md`** — o passo que mais trava na instalação, documentado com os dois caminhos possíveis e por que só um funciona.
- **`diagnostico.sh`** — reporta versões, dependências, fonte, modelo do Whisper, servidores MCP, skills, plugins e presença de chaves. Nunca imprime valor de chave.

### Descoberto em suporte real
- **O Higgsfield NÃO pode ser adicionado com `claude mcp add`.** Esse caminho sobe um servidor em `localhost:<porta>` e pede redirect para lá; o cliente OAuth do Higgsfield não tem localhost cadastrado. Falha sempre com `invalid_request: redirect_uri`, em qualquer porta e em qualquer máquina — inclusive nas que funcionam.
- **O caminho correto é conector do claude.ai**, com a URL `https://bridge.higgsfield.ai/mcp` (a que o painel do Premiere mostra em "Copy"). O OAuth acontece no domínio da Anthropic, sem localhost.
- Existe outra URL parecida (`mcp.higgsfield.ai`) que não funciona. A do painel é a válida.
- Tabela de diagnóstico por sintoma, separando falha do lado do Claude e falha do lado do Premiere.

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
