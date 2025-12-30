# --- git auto fetch (on cd) ---

# Default auto-fetch interval (seconds)
: ${GIT_AUTO_FETCH_INTERVAL:=60}

# Needed for EPOCHSECONDS and zstat mtime
zmodload zsh/datetime
zmodload -F zsh/stat b:zstat

_git_autofetch_fetch() {
  # Are we in a git work tree?
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0

  local gitdir
  gitdir="$(command git rev-parse --git-dir 2>/dev/null)" || return 0

  # Guard file disables autofetch for this repo
  local guard="$gitdir/NO_AUTO_FETCH"
  [[ -f "$guard" ]] && return 0

  # Must be able to write into .git
  [[ -w "$gitdir" ]] || return 0

  local log="$gitdir/FETCH_LOG"
  [[ -e "$log" && ! -w "$log" ]] && return 0

  # Throttle
  local lastrun
  lastrun="$(zstat +mtime "$log" 2>/dev/null || echo 0)"
  (( EPOCHSECONDS - lastrun < GIT_AUTO_FETCH_INTERVAL )) && return 0

  # Avoid ssh prompts; run quietly in background
  date -R &>! "$log"
  GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
  GIT_TERMINAL_PROMPT=0 \
    command git fetch --all --prune --recurse-submodules=yes &>> "$log" 2>/dev/null &|
}

# Hook that runs after every directory change
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _git_autofetch_fetch

# Also run once for the initial directory when the shell starts
_git_autofetch_fetch

# Optional: per-repo toggle command (same behavior as OMZ)
git-auto-fetch() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0
  local guard="$(command git rev-parse --git-dir)/NO_AUTO_FETCH"
  if [[ -f "$guard" ]]; then
    command rm -f "$guard" && echo "enabled"
  else
    command touch "$guard" && echo "disabled"
  fi
}
