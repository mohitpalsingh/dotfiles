# local-llm

Local LLM inference stack tuned for MacBook Pro M3 Pro 18GB.
Full benchmark data: `~/Documents/personal/engineering/experiments/local-llm-bench/results/SCORECARD.md`

## Fresh-machine setup

```bash
brew bundle --file=~/dotfiles/Brewfile     # installs llama.cpp (and everything else)
~/dotfiles/local-llm/install.sh            # downloads models (~14GB total)
```

## Daily use

```bash
~/dotfiles/local-llm/serve.sh              # Jarvis/agent mode — OpenAI API on :8080
~/dotfiles/local-llm/serve.sh --think      # deep review mode (thinking ON, slower)
```

Point any OpenAI-compatible client at `http://127.0.0.1:8080/v1`:
- **OpenCode** (`~/.config/opencode/opencode.json`): provider baseURL + jarvis MCP server
- **jarvis ask**: same base URL
- test: `curl -s localhost:8080/v1/chat/completions -d \'{...}\'`

Run it inside a tmux window; kill the window to stop. Zero idle cost when not running.

## Models on disk (~13.5GB)

| Model | Role |
|---|---|
| Qwen3.8-9B-Distill Q4_K_M | primary — best reviews + 6/6 tool-calls at ~20 t/s |
| Ornith-1.5-9B Q4_K_M | alternate — same perf, proactive agent style, MIT |
| Qwen3.8-4B-Distill Q4_K_M | speculative-decoding draft candidate (same tokenizer family); smoke-test baseline |

## Tuned flags (do not change without re-benching)

`-ngl 99` all GPU · `-fa on` flash attention · KV cache q8_0/q8_0 · `--jinja`
tool calling · ctx 8192 (16K OOMs with desktop apps open) · sampling 0.6/0.95/20.
Thinking off by default via `--reasoning off` (agent mode); `serve.sh --think` for reviews..

## Pi harness integration (pi.dev)

The router runs as a LaunchAgent: `com.mohit.llama-router` (starts at login,
restarts on crash, ~50MB idle until a model is loaded).

```bash
llm-models        # list models + load state
llm-load Qwen3.8-9B-Q4_K_M
llm-unload Qwen3.8-9B-Q4_K_M   # free ~6GB RAM
```

In pi:
- `/model` → pick `llama-local/Qwen3.8-9B-Q4_K_M` (or Ornith)
- provider defined in `~/.pi/agent/models.json` (llama-local, OpenAI-completions)
- non-interactive: `pi -p "..." --provider llama-local --model Qwen3.8-9B-Q4_K_M`
- interactive `/llama` manager also works (auth entry in ~/.pi/agent/auth.json)

Note: pi has NO built-in MCP by design. Jarvis tools are available through
OpenCode (which speaks MCP) or a future pi extension bridging `jarvis mcp`.

## jarvis tools inside pi

`~/.pi/agent/extensions/jarvis-mcp.ts` bridges `jarvis mcp` (stdio MCP) into
11 native pi tools (briefing, what_now, add, done, grade, capture, search,
remember, inbox_promote, pipeline, sync).

- Child process spawns lazily on first jarvis_* call; auto-respawns on exit
- Conversational wrapper: `jarvis-pi` (zsh function; adds date + summary discipline)
- Coding mode: plain `pi` — jarvis tools still available but bash/read/edit lead
