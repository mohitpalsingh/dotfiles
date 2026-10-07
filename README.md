# dotfiles

Personal macOS setup: zsh + tmux + neovim + ghostty, Gruvbox everywhere.
Terminal configs live in this repo; active configs are symlinked from `$HOME`.

## Layout

```
dotfiles/
├── bootstrap.sh          # One-shot fresh-machine setup (idempotent)
├── Brewfile              # Every brew formula/cask/app this machine needs
├── zsh/                  # Shell config
│   ├── zshrc.sh          # Main config — ~/.zshrc symlinks here directly
│   ├── keybindings.sh    # Ctrl-key widgets
│   ├── prompt.sh         # [path, exit-code, git-branch+dirty, SUDO]: prompt
│   ├── lockbook.sh       # Lockbook note-app integration
│   └── plugins/          # fixls + git submodules (autosuggest, completions, syntax-highlight)
├── nvim/.config/init.lua # Neovim config (separate repo, git submodule)
├── tmux/
│   ├── tmux.conf         # Main config — ~/.tmux.conf symlinks here
│   ├── tmux-keybindings.conf
│   └── plugins/          # TPM-managed (gitignored, NOT in repo)
├── ghostty/config        # Symlinked into ~/Library/Application Support/com.mitchellh.ghostty/
├── git/.gitconfig        # Aliases, diff-so-fancy, LFS
├── git/.gitignore_global
├── env/.env              # Shared bash/zsh env (EDITOR, locale, colors)
├── bash/.bashrc          # Legacy/minimal bash setup
└── vim/vimrc.vim         # Plain-vim fallback settings
```

## Fresh Mac: one command after cloning

```bash
git clone https://github.com/mohitpalsingh/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
```

Open a new Ghostty window after completion. Use HTTPS for the initial clone;
it works before your personal SSH alias exists. macOS Command Line Tools must
be installed: if missing, bootstrap opens Apple's installer and asks you to
finish it and rerun. Homebrew installation may request your macOS password.

The script installs the Brewfile (including desktop apps, fonts, npm and Go
CLIs), initializes pinned submodules, backs up conflicting files, links configs,
restores Terminal.app profiles, restores Neovim plugins using `lazy-lock.json`,
and waits for Mason language servers and Treesitter parsers. It creates the
Neovim undo directory and NVM directory. tmux uses the current inline bindings;
TPM is disabled and no plugin installation is needed.

Re-running is safe. Existing config files and broken symlinks are moved to
`~/.dotfiles-backups/<timestamp>-<pid>/`. Existing Bash startup files are
preserved; portable Bash fallbacks are installed if they are absent. Both
Ghostty config locations link to the same file to prevent competing settings.
Terminal.app should be closed during setup and reopened afterwards.

```bash
./bootstrap.sh --check       # Read-only config links and dependency checks
./bootstrap.sh --links-only  # Config links only; no downloads or package installs
./bootstrap.sh --skip-nvim   # Install everything except Neovim plugin/server/parser downloads
./install.sh                # Compatibility wrapper for bootstrap.sh
```

A clone outside `~/dotfiles` is supported by creating a `~/dotfiles` alias.
An existing unrelated checkout there is never overwritten.

Homebrew installs available versions, with upgrades disabled on reruns. It does
not restore exact old binary versions. `migration-inventory.txt` captures the
old machine's versions for reference. Git submodules and Neovim plugins are
pinned to their recorded commits.

Account logins, private tokens and company-managed Git hooks are outside this
setup. Existing optional shell secrets loading remains available. Local LLM
model files and Hermes/Jarvis project installations are also separate from
terminal dotfiles; see `local-llm/README.md` for the optional model setup.
Lockbook aliases are preserved; its CLI was absent on the audited Mac.

C++ formatting and the OpenCode RTK plugin are also tracked and linked.

See [migration audit](MIGRATION.md) for the comparison and verification results.

## Shell quick reference

### Keybindings (insert & normal where noted)

| Key | Action |
|-----|--------|
| `Ctrl-K` | Type `cd ..` + enter |
| `Ctrl-O` | Accept line (like Enter) |
| `Ctrl-S` | Prefix `sudo ` on current command |
| `Ctrl-H` | cd to current git repo root |
| `Ctrl-L` | New Lockbook doc (pick folder via fzf) |
| `Ctrl-F` | Edit Lockbook doc + sync |
| `Ctrl-R` | fzf history search |
| `Ctrl-T` | fzf file picker into command line |
| `Alt-C` | fzf cd into directory |

### Aliases

| Alias | Expands to |
|-------|-----------|
| `vi` / `vim` | `nvim` |
| `ll` / `la` / `l` | ls variants |
| `..` / `...` | `cd ..` / `cd ../..` |
| `tmux` | `tmux -2` (256-color) |

History: 50k lines, shared across sessions, dedup'd, space-prefixed commands ignored.
`cd` auto-lists directory contents. Vi mode enabled.

Note: `~/.zshrc` links **directly** to `zsh/zshrc.sh`; the old auto-update manager
(`zshrc_manager.sh`) is kept but unused. To update manually:
`git -C ~/dotfiles pull && git -C ~/dotfiles submodule update --init --recursive`.

## Tmux

Prefix: **`Ctrl-a`** (not `Ctrl-b`). Windows start at 1.

| Key | Action |
|-----|--------|
| `Ctrl-a Ctrl-a` | Send prefix through |
| `Alt-H` / `Alt-L` | Prev / next window |
| `" ` and `%` | Split panes **in current dir** |
| `c` | New window in current dir |
| `v` / `C-v` / `y` | Copy-mode: select / rectangle / yank |
| `Ctrl-h/j/k/l` | Navigate nvim ↔ tmux panes seamlessly |

TPM is currently disabled. Navigation and clipboard bindings are implemented
in `tmux-keybindings.conf`; no plugin download is required.

## Neovim

Config: [mohitpalsingh/init.lua](https://github.com/mohitpalsingh/init.lua) (submodule).
LazyVim-style with lazy.nvim. Leader = **space**.

### Everyday

| Key | Action |
|-----|--------|
| `<space>pf` / `Ctrl-p` | Find files / git files (telescope) |
| `<space>ps` | Live grep project |
| `<space>pws` / `<space>pWs` | Grep word under cursor |
| `-` | Oil file explorer |
| `<space>y` / `<space>p` | Yank to clipboard / paste w/o losing register |
| `<space>s` | Replace symbol under cursor everywhere |
| `<space>x` | chmod +x current file |
| `J`/`K` (visual) | Move block down/up |
| `Ctrl-d`/`Ctrl-u`, `n`/`N` | Scroll/search centered |
| `Ctrl-j`/`Ctrl-k` | Quickfix next/prev |
| `<space>q` / `<space>c` | Open/close quickfix |
| `<space><space>` | Reload init.lua |
| `<space>cc` / `<space>cC` | Claude Code in tmux split (+ file context) |

### LSP (attached per-buffer)

`gd` definition · `gD` declaration · `gr` references · `gi` implementation ·
`K` hover · `Ctrl-k` signature · `<space>rn` rename · `<space>ca` code action ·
`<space>f` format · `[d`/`]d` diagnostic nav · `<space>d` diag float ·
`<space>lsp` restart LSP

Servers (Mason): lua_ls, clangd, jdtls, pyright, gopls, kotlin_language_server.

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `F5` | Continue / start |
| `F9` / `F10` / `F11` / `F12` | Breakpoint / step over / into / out |
| `<space>dv` | Eval under cursor |
| `<leader>dpt` | Python: debug test method (uses project `.venv`) |

Go uses delve; Python uses debugpy from the opened project's `.venv/bin/python`.

### Competitive programming (C++)

| Key | Action |
|-----|--------|
| `F6` | Compile (`g++-15 -std=c++17 -O2`) + run `< input.txt > output.txt` |
| `F7` | Compile + run interactively |
| `F8` | Open output.txt in vertical split |

Copilot auto-disables under `~/Documents/personal/cp/`.

## Git aliases

| Alias | Command |
|-------|---------|
| `st` `co` `br` `ci` `cm` | status / checkout / branch / commit / commit -m |
| `df` `dc` `ds` | diff / diff --cached / diff --stat |
| `graph` | pretty all-branches log graph |
| `wip` | branches by last-used date |
| `today` | your commits since midnight |
| `recent` `last` | last 10 oneline / last commit +stat |
| `unstage` `discard` | reset HEAD-- / checkout -- |
| `cleanup` | delete merged local branches (keeps main/master) |

Pager: diff-so-fancy. Editor: nvim. Default branch: main. Fetch prunes.

## Ghostty

Theme Gruvbox Dark Hard, IosevkaTerm Nerd Font Mono 16, auto-attaches tmux
session "ghostty" on launch (`tmux_script.sh`). Config is a symlink into dotfiles.

## Inference-engineering workspace

Learning repo at `~/Documents/personal/engineering/inference-engineering`
(plan in its README/ROADMAP). Q1 toolchain ready in `q1-transformer/`:

```bash
cd q1-transformer && nvim      # pyright + dap pick up .venv automatically
uv run python <file>           # run scripts
uv run pytest                  # tests from tests/
uv run ruff check .            # lint/format
uv add <pkg>                   # add dependency
```

Stack: numpy, torch (MPS on M3), matplotlib; dev: pytest, ruff, debugpy.
No starter code by design — ACQUIRE MODE: every line typed by hand.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Shell slow on startup | gcloud completion is the usual suspect; comment its block in zshrc.sh |
| Missing completions/colors | `rm ~/.zcompdump* && exec zsh` |
| nvim LSP not attaching | `:Mason` → check server installed; open nvim from project root so `.venv`/roots resolve |
| Python DAP says no debugpy | `cd <project> && uv sync` (dev group includes it) |
| Tmux navigation bindings missing | Check `~/dotfiles/tmux/tmux-keybindings.conf`; TPM is disabled |
| Ghostty ignores theme edits | You edited the backup; real file: `~/dotfiles/ghostty/config` |
