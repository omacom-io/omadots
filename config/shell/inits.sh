_shell_name="${ZSH_VERSION:+zsh}"
_shell_name="${_shell_name:-bash}"

if command -v mise &>/dev/null; then
  eval "$(mise activate "$_shell_name")"
fi

if command -v starship &>/dev/null; then
  if [[ "$_shell_name" == "bash" ]]; then
    # clear stale readline state before rendering prompt (prevents artifacts in prompt after abnormal exits like SIGQUIT)
    __sanitize_prompt() { printf '\r\033[K'; }
    PROMPT_COMMAND="__sanitize_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi
  eval "$(starship init "$_shell_name")"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init "$_shell_name")"
fi

if command -v try &>/dev/null; then
  eval "$(try init ~/Work/tries)"
fi

if command -v fzf &>/dev/null; then
  if [[ "$_shell_name" == "bash" ]]; then
    if [[ -f /usr/share/fzf/completion.bash ]]; then
      source /usr/share/fzf/completion.bash
    fi
    if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
      source /usr/share/fzf/key-bindings.bash
    fi
  elif [[ "$_shell_name" == "zsh" ]]; then
    if [[ -f /usr/share/fzf/completion.zsh ]]; then
      source /usr/share/fzf/completion.zsh
    fi
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
      source /usr/share/fzf/key-bindings.zsh
    fi
  fi
fi

unset _shell_name
