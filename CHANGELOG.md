# Changelog

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
