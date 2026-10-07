# Local LLM helpers — LaunchAgent router (pi/llama.cpp) + single-model serve
alias llm-router-start='launchctl kickstart gui/$(id -u)/com.mohit.llama-router'
alias llm-router-stop='launchctl bootout gui/$(id -u)/com.mohit.llama-router 2>/dev/null; echo stopped'
alias llm-models='curl -s http://127.0.0.1:8080/models | python3 -c "import json,sys; [print(m[\"id\"],\"->\",m[\"status\"][\"value\"]) for m in json.load(sys.stdin)[\"data\"]]"'
llm-load() { curl -s -X POST http://127.0.0.1:8080/models/load -H 'Content-Type: application/json' -d "{\"model\":\"$1\"}"; }
llm-unload() { curl -s -X POST http://127.0.0.1:8080/models/unload -H 'Content-Type: application/json' -d "{\"model\":\"$1\"}"; }
alias llm-serve='~/dotfiles/local-llm/serve.sh'          # fixed single-model mode
alias llm-review='~/dotfiles/local-llm/serve.sh --think'
alias llm-stop='pkill -f llama-server && echo stopped || echo "not running"'
# Jarvis conversational mode inside pi (local model + jarvis tools)
jarvis-pi() {
  cd ~/Documents/personal/engineering && pi --provider llama-local \\
    --model "${1:-Qwen3.8-9B-Q4_K_M}" \\
    --append-system-prompt 'You are Jarvis, Mohit'\''s personal assistant. Current date: $(date '+%a %b %d %Y'). When you use jarvis_* tools, ALWAYS finish your turn with a brief warm one-paragraph summary of the results for Mohit. Never invent facts not present in tool results.' \\
    "$@"
}
