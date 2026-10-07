#!/usr/bin/env bash
# llama.cpp ROUTER mode — pairs with pi's /llama command.
# Discovers all GGUFs in ~/.llm/models, loads/unloads on demand (RAM-safe).
# Unlike serve.sh (single fixed model), this lets pi switch models per session.
set -euo pipefail
MODELS_DIR="${MODELS_DIR:-$HOME/.llm/models}"
CTX="${CTX:-12288}"
PORT="${PORT:-8080}"

exec llama-server \
  --models-dir "$MODELS_DIR" \
  --no-models-autoload \
  --jinja \
  --host 127.0.0.1 \
  --port "$PORT" \
  -ngl 999 \
  -c "$CTX" \
  -fa on \
  --cache-type-k q8_0 --cache-type-v q8_0
