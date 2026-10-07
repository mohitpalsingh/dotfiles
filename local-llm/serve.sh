#!/usr/bin/env bash
# Local LLM server — winning config for M3 Pro 18GB (see SCORECARD.md in
# engineering/experiments/local-llm-bench).
#
# Usage:
#   serve.sh                 # Jarvis/agentic mode (thinking OFF, 6/6 tool-calls)
#   serve.sh --think         # deep code-review mode (thinking ON)
#   PORT=8081 serve.sh       # custom port
set -euo pipefail

MODELS_DIR="$HOME/Documents/personal/engineering/experiments/local-llm-bench/models"
MODEL="${MODEL:-$MODELS_DIR/qwen38-9b-gguf/Qwen3.8-9B-Q4_K_M.gguf}"
CTX="${CTX:-12288}"            # 16K OOMs when desktop apps are open — keep 8K
PORT="${PORT:-8080}"

[ -f "$MODEL" ] || { echo "model missing: $MODEL (run install.sh)" >&2; exit 1; }

ARGS=(llama-server -m "$MODEL" --port "$PORT" -c "$CTX"
  -ngl 99 -fa on                                   # full GPU offload + flash attention
  --cache-type-k q8_0 --cache-type-v q8_0          # half-size KV cache
  --jinja                                          # native OpenAI tool-calling
  --threads "$(sysctl -n hw.ncpu)"
  --temp 0.6 --top-p 0.95 --top-k 20)              # Qwen3.8 recommended sampling

# Default: thinking OFF (perfect tool-call reliability, fast agent loops).
if [ "${1:-}" != "--think" ]; then
  ARGS+=(--reasoning off)
fi

echo "serving $(basename "$MODEL") ctx=$CTX think=$([ "${1:-}" = "--think" ] && echo on || echo off) :$PORT"
exec "${ARGS[@]}"
