autoload -Uz add-zsh-hook
setopt prompt_subst

[[ -o interactive ]] || return 0

neil_stat_host() {
  scutil --get ComputerName 2>/dev/null || hostname
}

neil_stat_os() {
  local product_name product_version

  product_name="$(sw_vers -productName 2>/dev/null)"
  product_version="$(sw_vers -productVersion 2>/dev/null)"

  if [[ -n "$product_name" ]]; then
    printf "%s %s" "$product_name" "$product_version"
    return 0
  fi

  uname -s
}

neil_stat_uptime() {
  uptime 2>/dev/null | awk -F' up ' 'NF > 1 { print $2 }' | sed -E 's/, [0-9]+ users?.*$//'
}

neil_stat_cpu() {
  local cpu

  cpu="$(sysctl -n machdep.cpu.brand_string 2>/dev/null)"
  if [[ -n "$cpu" ]]; then
    printf "%s" "$cpu"
    return 0
  fi

  uname -m
}

neil_stat_memory() {
  if command -v top >/dev/null 2>&1; then
    local phys_mem
    phys_mem="$(top -l 1 2>/dev/null | awk -F': ' '/PhysMem/ { print $2; exit }')"
    if [[ -n "$phys_mem" ]]; then
      printf "%s" "$phys_mem"
      return 0
    fi
  fi

  printf "unknown"
}

neil_stat_disk() {
  df -h / 2>/dev/null | awk 'NR == 2 { print $3 " / " $2 " (" $5 ")" }'
}

neil_show_login_banner() {
  local art_file="$HOME/.config/neil-shell/login-banner-art.txt"

  if [[ -n "${NEIL_ZSH_LOGIN_BANNER_SHOWN:-}" ]]; then
    return 0
  fi
  export NEIL_ZSH_LOGIN_BANNER_SHOWN=1

  [[ -r "$art_file" ]] && cat "$art_file"
#  printf "    Host   : %s\n" "$(neil_stat_host)"
#  printf "    OS     : %s\n" "$(neil_stat_os)"
#  printf "    Kernel : %s\n" "$(uname -r)"
  printf "||[ -This machine has been on for: %s\n" "$(neil_stat_uptime)"
  printf "||[ -CPU: %s\n" "$(neil_stat_cpu)"
  printf "||[ -Memory: %s\n" "$(neil_stat_memory)"
#  printf "    Disk   : %s\n" "$(neil_stat_disk)"
  printf "\n"
}

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
neil_show_login_banner
neil_set_prompt
