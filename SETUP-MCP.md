# Conectar o Premiere ao Claude Code

Este é o passo que mais trava na instalação. Leia antes de tentar.

---

## Existem DOIS caminhos. Só um funciona.

| | Caminho A — Conector claude.ai | Caminho B — MCP local |
|---|---|---|
| Como | `claude.ai` → Settings → Connectors | `claude mcp add --transport http ...` |
| Onde autentica | no domínio da Anthropic | **em `localhost:<porta>`** |
| Funciona? | ✅ **sim** | ❌ **não** |

**Use o Caminho A.**

### Por que o Caminho B falha

O `claude mcp add` faz o Claude Code subir um servidor local (`localhost:4204`, `localhost:3118`, a porta muda a cada tentativa) e pedir ao Higgsfield que redirecione o login para lá.

O cliente OAuth do Higgsfield **não tem endereços de localhost cadastrados como redirect_uri**. O erro é sempre o mesmo:

```
invalid_request: redirect_uri
```

**Trocar de porta não resolve. Repetir não resolve.** Toda tentativa por esse caminho falha, em qualquer máquina — inclusive nas que já funcionam pelo Caminho A.

---

## Caminho A — passo a passo

**1. Se já tentou o caminho local, remova primeiro:**

```bash
claude mcp remove higgsfield
claude mcp list
```

**2. Pegue a URL no painel do Premiere.**
Abra o painel **Higgsfield** no Premiere. Em "How to connect", clique em **Copy**. A URL é:

```
https://bridge.higgsfield.ai/mcp
```

> Existe outra URL parecida (`mcp.higgsfield.ai`). **Não é essa.** A do painel é a correta.

**3. Adicione como conector:**
`claude.ai` → **Settings** → **Connectors** → **Add custom connector** → colar a URL → autenticar.

O login abre no navegador, no domínio do claude.ai. Sem localhost.

**4. No Premiere:** painel Higgsfield → **Connect** em "Supercomputer Connection". Tem que ficar **Live**, bolinha verde.

**5. Confirme no Claude Code:** peça `get_host_status`. Tem que voltar:

```json
{"aeft": false, "ppro": true, "blr": false}
```

`ppro: true` é o que importa.

---

## Diagnóstico por sintoma

Cada sintoma aponta para um lado diferente da ponte. Isso separa "não instalou" de "não conectou".

| Sintoma | Onde está o problema |
|---|---|
| `invalid_request: redirect_uri` no terminal | Está no Caminho B. Migre para o A. |
| *"Não tenho ferramenta de controle ao vivo do Premiere"* | O conector não foi adicionado, ou não foi autenticado |
| Claude oferece editar o `.prproj` ou gerar CSV de marcadores | Mesmo caso acima. **Recuse a edição do `.prproj`** — ver aviso abaixo |
| `get_host_status` não responde | Problema do lado do Claude: conector ausente ou sem auth |
| `get_host_status` responde com `ppro: false` | Problema do lado do Premiere: painel fechado ou sem Connect |
| Painel mostra **Live** mas `ppro: false` | Fechar e reabrir o Premiere |
| Funcionava e parou no meio do trabalho | A conexão cai sozinha. Reconectar pelo painel; nada se perde |

> **Nunca deixe o Claude editar o `.prproj` com o projeto aberto no Premiere.** O Premiere sobrescreve o arquivo ao salvar e o trabalho é perdido. É a saída que ele oferece quando não tem conexão, e é destrutiva.

---

## Script de diagnóstico

Rode e mande a saída para quem for ajudar:

```bash
bash diagnostico.sh
```

Ele reporta versões, dependências, fonte, servidores MCP locais e a pasta de skills — sem expor nenhuma chave.

---

## Como pedir ajuda

Mande três coisas:

1. A saída do `diagnostico.sh`
2. Print do painel Higgsfield no Premiere (mostrando Live ou não)
3. A resposta de `get_host_status`

Com isso dá para dizer em qual dos cinco elos travou, sem chute.
