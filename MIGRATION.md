# Mac migration audit — 2026-10-07

## Compared with this Mac

| Component | Current state and migration result |
| --- | --- |
| zsh | Active `.zshrc` already linked to the tracked config. Portable Homebrew paths added; duplicate Google Cloud initialization removed. |
| Login shell | Previously untracked `.zprofile` only initialized Apple Silicon Homebrew. Now tracked, portable, and linked. |
| Ghostty | Active macOS config already matched the repo. Both config locations now link to the same config. Font is included in Brewfile; launcher finds tmux on Apple Silicon and Intel. |
| tmux | Active config matched the repo. Inline navigation/copy bindings are current; TPM is disabled. Removed obsolete bootstrap plugin installation. |
| Neovim | Active config links to the pinned submodule. Working tree is clean. All installed lazy.nvim plugins match `lazy-lock.json`. Undo directory is provisioned. New setup restores plugins and waits for language servers/parsers. |
| Git | Active config matched repo. Global ignore rule from `.config/git/ignore` consolidated into the existing tracked ignore file. Removed the HTTPS-to-SSH rewrite so first-run plugin downloads work before SSH setup. Username-specific Git-AI socket setting lives in a local include. |
| Terminal.app | Captured 12 appearance profiles, including Basic (current default/startup). Background-image bookmark excluded; no profile has a custom launch command. Installer merges profiles with existing preferences and backs those preferences up. |
| Bash | Existing startup files are company managed and preserved. Added portable login fallback for a fresh Mac; shared env and aliases are linked. |
| Vim | Repo fallback was present but inactive. Setup now links it, alongside the Neovim undo directory. |
| C++ formatting | Previously untracked `.clang-format` copied into repo and linked. |
| OpenCode | RTK command-rewrite plugin captured and linked. Provider/MCP credentials and Git-AI integration are outside the setup scope. |
| Packages | Brewfile extended with installed terminal tools, pi/Cline npm CLIs, Google Cloud SDK, and missing Neovim dependencies. Reference versions captured in `migration-inventory.txt`. |

Before editing, the main repo and Neovim submodule were clean. Live GitHub heads
matched local HEADs: dotfiles `559c8d8e543b5431c16512869497c4a1412e356e`,
Neovim `ed2b472e445c250fe14a3b7def987f9b84ae2397`.
The existing setup changes still need to be committed and pushed before a new
Mac clone can receive them.

## Verification completed

- Shell syntax checks passed for bootstrap, wrapper, checker, Ghostty launcher,
  Bash login fallback and zsh startup files.
- Neovim starts headlessly with the active config. Setup Lua parses successfully.
- Every installed Neovim plugin matches the recorded lockfile commit.
- All 12 managed config links pass the read-only checker on this Mac.
- `--links-only` reruns are idempotent. Existing `.zprofile`, `.clang-format`,
  and OpenCode RTK plugin were backed up before linking.
- Captured Terminal plist parses, contains 12 profiles and selects Basic.
- Python Terminal restoration helper parses successfully.
- Git diff whitespace checks passed.

Four commands are currently absent on this Mac: `fd`, `g++-15`, `dlv` and
`tree-sitter`. Their packages are in the updated Brewfile (`fd`, `gcc@15`,
`delve`, `tree-sitter-cli`). They will install during full bootstrap.

A full fresh-Mac installation has not been executed. Homebrew installations,
Terminal preference restoration and fresh Mason/Treesitter downloads remain
unverified end to end. This Mac's packages were not upgraded or reinstalled.
Homebrew installs currently available versions rather than exact binary
versions from the old Mac. Config submodules and Neovim plugin commits are pinned.

## Separate from terminal setup

Account logins, private tokens and company-managed Git hooks are intentionally
excluded. The existing hook remains configured locally on this Mac.
Project checkouts, local model files, Hermes/Jarvis installations, Git-AI itself,
and runtime/session/history data are not terminal config files. Lockbook's CLI
was absent on this Mac; its existing optional bindings are preserved.
The legacy Terraform 0.13.5 installation/default is machine state and is not
restored automatically; use `tfenv install`/`tfenv use` for project requirements.

## New Mac

Install Apple's Command Line Tools if prompted, then:

```bash
git clone https://github.com/mohitpalsingh/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
```

Close Terminal.app while the script restores its profiles, then reopen your
terminal. Ghostty starts/attaches the `ghostty` tmux session automatically.
Run `~/dotfiles/bootstrap.sh --check` for read-only readiness checks.
