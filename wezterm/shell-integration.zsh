# WezTerm Shell Integration for Zsh
# ─────────────────────────────────
# Source this in your ~/.zshrc:
#   source ~/.config/wezterm/shell-integration.zsh
#
# What this enables:
#   - ScrollToPrompt (ctrl+shift+up/down) — jump between shell prompts in scrollback
#   - New tabs/panes open in the same CWD as current pane
#   - Right status bar shows the current working directory
#   - Semantic zones: select entire command output as a block
#   - WEZTERM_PROG / WEZTERM_HOST / WEZTERM_USER user vars

# Only activate inside WezTerm
[[ "$TERM_PROGRAM" == "WezTerm" ]] || return

# ── OSC 7: Tell WezTerm the current working directory ──────────────────────────
# Used for: new tab/pane inherits CWD, CWD shown in status bar
__wezterm_osc7() {
  printf "\033]7;file://%s%s\033\\" "${HOSTNAME}" "${PWD}"
}
# Fire after every prompt
precmd_functions+=(__wezterm_osc7)

# ── OSC 133: Semantic prompt zones ─────────────────────────────────────────────
# Marks prompt start/end and command output start/end.
# Used for: ScrollToPrompt, selecting command output as a zone.
__wezterm_prompt_start() {
  printf "\033]133;A\033\\"
}
__wezterm_prompt_end() {
  printf "\033]133;B\033\\"
}
__wezterm_output_start() {
  printf "\033]133;C\033\\"
}
__wezterm_output_end() {
  printf "\033]133;D\033\\"
}

precmd_functions+=(__wezterm_prompt_start)
preexec_functions+=(__wezterm_output_start)

# Wrap PROMPT so prompt-end fires just before input
__wezterm_setup_prompt() {
  PROMPT="%{$(__wezterm_prompt_end)%}${PROMPT}"
}
# Only wrap once
[[ -z "$_WEZTERM_PROMPT_WRAPPED" ]] && {
  __wezterm_setup_prompt
  _WEZTERM_PROMPT_WRAPPED=1
}

# ── OSC 1337: User vars (WEZTERM_PROG, WEZTERM_HOST, WEZTERM_USER) ─────────────
# Used for: showing current command in status bar, user/host info
__wezterm_set_user_var() {
  local key="$1" val="$2"
  printf "\033]1337;SetUserVar=%s=%s\033\\" "$key" "$(printf '%s' "$val" | base64)"
}

__wezterm_user_vars() {
  __wezterm_set_user_var "WEZTERM_USER" "$(id -un)"
  __wezterm_set_user_var "WEZTERM_HOST" "$(hostname)"
}
precmd_functions+=(__wezterm_user_vars)

__wezterm_prog_vars() {
  __wezterm_set_user_var "WEZTERM_PROG" "$1"
}
preexec_functions+=(__wezterm_prog_vars)
