#!/usr/bin/env bash
# Re-provision local LLM stack on a fresh machine.
set -euo pipefail

# 1. engine
command -v llama-server >/dev/null || brew install llama.cpp

# 2. models (bandwidth-gated: winner first, alternates optional)
BASE="https://huggingface.co"
DEST="$HOME/Documents/personal/engineering/experiments/local-llm-bench/models"
mkdir -p "$DEST"/qwen38-9b-gguf "$DEST"/ornith-9b-gguf "$DEST"/qwen38-4b-gguf

fetch() { # fetch <url> <out>
  [ -f "$2" ] && { echo "have $(basename "$2")"; return 0; }
  curl -L -C - --retry 8 --retry-delay 3 -o "$2" "$1"
}

fetch "$BASE/empero-ai/Qwen3.8-9B-Distill-GGUF/resolve/main/Qwen3.8-9B-Q4_K_M.gguf" \
      "$DEST/qwen38-9b-gguf/Qwen3.8-9B-Q4_K_M.gguf"                       # primary (5.8GB)
fetch "$BASE/ornith-ai/Ornith-1.5-9B-GGUF/resolve/main/Ornith-1.5-9B-Q4_K_M.gguf" \
      "$DEST/ornith-9b-gguf/Ornith-1.5-9B-Q4_K_M.gguf"                   # A/B alternate (5.6GB)
fetch "$BASE/empero-ai/Qwen3.8-4B-Distill-GGUF/resolve/main/Qwen3.8-4B-Q4_K_M.gguf" \
      "$DEST/qwen38-4b-gguf/Qwen3.8-4B-Q4_K_M.gguf"                     # draft-model candidate (2.8GB)

echo "done. start with: ~/dotfiles/local-llm/serve.sh"
