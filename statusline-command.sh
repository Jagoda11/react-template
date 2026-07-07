#!/bin/bash
input=$(cat)
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty' | sed 's/ *([^)]*)//')
effort=$(echo "$input" | jq -r '.effort_level // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
name=$(echo "$input" | jq -r '.session_name // empty')
color=$(echo "$input" | jq -r '.session_color // .color // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
dir=$(basename "$cwd")
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

badge=""
if [ -n "$name" ] || [ -n "$color" ]; then
  key=$(echo "${color:-$name}" | tr '[:upper:]' '[:lower:]')
  label="${name:-$color}"
  case "$key" in
    blue)    badge="🐬 $label" ;;
    yellow)  badge="🌻 $label" ;;
    pink)    badge="🌸 $label" ;;
    green)   badge="🌿 $label" ;;
    orange)  badge="🦊 $label" ;;
    red)     badge="🍎 $label" ;;
    purple)  badge="🍇 $label" ;;
    cyan)    badge="🐠 $label" ;;
    *)       badge="📌 $label" ;;
  esac
fi

green=$'\033[32m'
yellow=$'\033[33m'
red=$'\033[31m'
cyan=$'\033[36m'
reset=$'\033[0m'

if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  remaining_int=$(printf "%.0f" "${remaining:-$((100 - used_int))}")
  if [ "$used_int" -lt 70 ]; then
    bar_color="$green"
  elif [ "$used_int" -lt 90 ]; then
    bar_color="$yellow"
  else
    bar_color="$red"
  fi
  filled=$((used_int / 10))
  empty=$((10 - filled))
  bar=""
  [ "$filled" -gt 0 ] && printf -v f "%${filled}s" && bar="${f// /█}"
  [ "$empty" -gt 0 ] && printf -v p "%${empty}s" && bar="${bar}${p// /░}"
  ctx_info="${bar_color}${bar}${reset} ${used_int}% used / ${remaining_int}% left"
else
  ctx_info="ctx: --"
fi

total_tokens=$((input_tokens + output_tokens))
tokens_fmt=$(awk -v t="$total_tokens" 'BEGIN {if (t >= 1000) printf "%.1fk", t/1000; else printf "%d", t}')
mins=$((duration_ms / 60000))
secs=$(((duration_ms % 60000) / 1000))

effort_info=""
[ -n "$effort" ] && effort_info="  |  /effort $effort"

branch_info=""
[ -n "$branch" ] && branch_info="  |  🌿 ${cyan}${branch}${reset}"

prefix=""
[ -n "$badge" ] && prefix="${badge}  |  "

echo -e "${prefix}${ctx_info}"
echo -e "📁 ${dir}${branch_info}"

cost_fmt=$(awk -v c="$cost_usd" 'BEGIN { printf "$%.2f", c }')
model_info=""
[ -n "$model" ] && model_info="  |  🤖 ${model}"
echo -e "🎫 ${tokens_fmt}  |  💵 ${cost_fmt}${model_info}${effort_info}"
