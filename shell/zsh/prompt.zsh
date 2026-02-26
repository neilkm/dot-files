autoload -Uz add-zsh-hook
setopt prompt_subst

neil_git_prompt_segment() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch dirty
  dirty=""
  branch="$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)" || return 0

  if [[ -n "$(command git status --porcelain --untracked-files=normal 2>/dev/null)" ]]; then
    dirty="*"
  fi

  printf ' %%F{214}[%s]%%f%s' "$branch" "$dirty"
}

neil_set_prompt() {
  PROMPT='%n@%m %/$(neil_git_prompt_segment) '
}

add-zsh-hook precmd neil_set_prompt
neil_set_prompt
