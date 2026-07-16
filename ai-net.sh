#!/usr/bin/env bash

# And don't forget to change json and url contents of curl for your AI in OpenRouter
# Just save stream: true for better output

TOKEN=YOUR_OPENROUTER_TOCKEN
pyenv="/home/nyx/Documents/TerminalAI/.venv/bin/activate"

spinner () {
  local pid=$1
  local delay=0.1
  local spinstr='⠧⠏⠹⠼'
  tput civis # hide cursor wow
  while kill -0 "$pid" 2>/dev/null; do
    for (( i=0; i<${#spinstr}; i++ )); do
      printf "\r%s Thinking... " "${spinstr:$i:1}" >&2
      sleep $delay
    done
  done
  printf "\r\033[K" >&2
  tput cnorm # show cursor
}

source $pyenv

if [[ $# < 1 ]]; then
	echo "Please make a promt"
	exit 2
fi

spinner $$ &
SPINNER_PID=$!

first_chunk=0

curl -N -s https://openrouter.ai/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "$(jq -n --arg content "$(echo -n $@)" '{
  "model": "openrouter/owl-alpha",
  "messages": [
      {
        "role": "user",
        "content": $content
      }
    ], 
  "stream": true
}')" | while IFS= read -r line; do
  if [[ "$line" =~ ^: ]]; then
    continue
  fi

  if [[ "$line" =~ ^data:\ (.*)$ ]]; then
    data="${BASH_REMATCH[1]}"

    if [ "$data" = "[DONE]" ]; then
      break
    fi

    content=$(echo "$data" | jq -r '.choices[0].delta.content // empty')
    if [ -n "$content" ]; then
      if [ $first_chunk -eq 0 ]; then
        kill $SPINNER_PID 2>/dev/null
        wait $SPINNER_PID 2>/dev/null
        
        printf "\r\033[K" >&2
        tput cnorm
        first_chunk=1
      fi
      printf "%s" "$content"
    fi
  fi
done | md2term

deactivate

