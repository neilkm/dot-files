autoload -Uz add-zsh-hook
autoload -Uz compinit
setopt prompt_subst

[[ -o interactive ]] || return 0

if command ls -G . >/dev/null 2>&1; then
  export CLICOLOR=1
  export LSCOLORS='ExFxBxDxCxegedabagacad'
  alias la='ls -laG'
  alias ll='ls -lG'
elif command ls --color=auto . >/dev/null 2>&1; then
  alias la='ls -la --color=auto'
  alias ll='ls -l --color=auto'
fi

alias gs='git status'
alias gl='git log'
alias gc='git commit'
alias ga='git add --all'
alias gp='git push'
alias gg='git gui'

if [[ -z "${_NEIL_ZSH_COMPINIT_DONE:-}" ]]; then
  typeset -g _NEIL_ZSH_COMPINIT_DONE=1
  compinit -i
fi

neil_update_terminal_cwd() {
  local cwd url_path

  cwd="${PWD:A}"
  url_path="${cwd// /%20}"
  url_path="${url_path//#/%23}"
  printf '\e]7;file://%s%s\a' "${HOST:-localhost}" "$url_path"
}

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

neil_parse_size_to_bytes() {
  local value="$1"
  local number unit multiplier

  number="${value%[KMGT]}"
  if [[ "$number" == "$value" ]]; then
    unit=""
  else
    unit="${value#$number}"
  fi

  case "$unit" in
    K) multiplier=1024 ;;
    M) multiplier=$((1024 ** 2)) ;;
    G) multiplier=$((1024 ** 3)) ;;
    T) multiplier=$((1024 ** 4)) ;;
    "") multiplier=1 ;;
    *) return 1 ;;
  esac

  awk -v number="$number" -v multiplier="$multiplier" 'BEGIN { printf "%.0f", number * multiplier }'
}

neil_format_bytes_human() {
  local bytes="$1"

  awk -v bytes="$bytes" '
    function fmt(value, unit) {
      if (value >= 10 || value == int(value)) {
        printf "%.0f%s", value, unit
      } else {
        printf "%.1f%s", value, unit
      }
    }
    BEGIN {
      if (bytes >= 1024 ^ 4) {
        fmt(bytes / (1024 ^ 4), "T")
      } else if (bytes >= 1024 ^ 3) {
        fmt(bytes / (1024 ^ 3), "G")
      } else if (bytes >= 1024 ^ 2) {
        fmt(bytes / (1024 ^ 2), "M")
      } else if (bytes >= 1024) {
        fmt(bytes / 1024, "K")
      } else {
        printf "%dB", bytes
      }
    }
  '
}

neil_banner_stat_line() {
  local label="$1"
  local value="$2"
  local plain_text

  plain_text=$(printf '%-13s %s' "$label" "$value")
  printf '\033[38;2;222;195;109m || \033[0m'
  printf '%-13s ' "$label"
  printf '\033[38;5;46m%s\033[0m' "$value"
  printf '%*s' "$((51 - ${#plain_text}))" ''
  printf '\033[38;2;222;195;109m ||\033[0m\n'
}

neil_stat_memory() {
  if command -v top >/dev/null 2>&1 && command -v sysctl >/dev/null 2>&1; then
    local used_raw total_bytes used_bytes total_human used_human

    used_raw="$(top -l 1 2>/dev/null | sed -nE 's/^PhysMem: ([0-9.]+[KMGT]?) used.*$/\1/p' | head -n 1)"
    total_bytes="$(sysctl -n hw.memsize 2>/dev/null)"

    if [[ -n "$used_raw" && -n "$total_bytes" ]]; then
      used_bytes="$(neil_parse_size_to_bytes "$used_raw")"
      if [[ -n "$used_bytes" ]]; then
        used_human="$(neil_format_bytes_human "$used_bytes")"
        total_human="$(neil_format_bytes_human "$total_bytes")"
        printf "%s/%s" "$used_human" "$total_human"
        return 0
      fi
    fi
  fi

  printf "unknown"
}

neil_stat_disk() {
  df -h / 2>/dev/null | awk 'NR == 2 { print $3 "/" $2 }'
}

neil_show_login_banner() {
  local art_file="$HOME/.config/neil-shell/login-banner-art.txt"

  if [[ -n "${NEIL_ZSH_LOGIN_BANNER_SHOWN:-}" ]]; then
    return 0
  fi
  export NEIL_ZSH_LOGIN_BANNER_SHOWN=1

  if [[ -r "$art_file" ]]; then
    printf '\033[38;2;237;21;176m'
    cat -- "$art_file"
    printf '\033[0m'
  fi
  printf '\033[38;2;222;195;109m __                                                     __\n\033[0m'
  printf '\033[38;2;222;195;109m{||}==================================================={||}\n\033[0m'
  neil_banner_stat_line "  Uptime:" "$(neil_stat_uptime)"
  neil_banner_stat_line "  CPU:" "$(neil_stat_cpu)"
  neil_banner_stat_line "  Memory:" "$(neil_stat_memory)"
  neil_banner_stat_line "  Storage:" "$(neil_stat_disk)"
  printf '\033[38;2;222;195;109m{||}==================================================={||}\n\033[0m'
  printf '\033[38;2;222;195;109m ¯¯                                                     ¯¯\n\033[0m'
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

neil_truncated_pwd() {
  local -a parts tail_parts
  local path prefix

  path="${PWD/#$HOME/~}"
  parts=(${(s:/:)path})

  if (( ${#parts[@]} <= 3 )); then
    printf "%s" "$path"
    return 0
  fi

  tail_parts=("${parts[@]: -3}")
  prefix="..."

  if [[ "$path" == /* ]]; then
    prefix=".../"
  elif [[ "$path" == ~/* ]]; then
    prefix=".../"
  fi

  printf "%s%s" "$prefix" "${(j:/:)tail_parts}"
}

neil_set_prompt() {
  PROMPT='%F{12}┌─[%n@%m]%f%F{205} $(neil_truncated_pwd)$(neil_git_prompt_segment)%f
%F{12}└─%f$ '
}

add-zsh-hook precmd neil_set_prompt
add-zsh-hook precmd neil_update_terminal_cwd
add-zsh-hook chpwd neil_update_terminal_cwd
neil_show_login_banner
neil_update_terminal_cwd
neil_set_prompt
