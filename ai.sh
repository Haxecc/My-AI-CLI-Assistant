#!/usr/bin/env bash

TOKEN=#YOUR OPENROUTER TOKEN

if [[ $# < 1 ]]; then
	echo "Please make a promt"
	exit 2
fi

echo "==========ANSWER=========="
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "$(jq -n --arg content "$(echo -n $@)" '{
  "model": "tngtech/tng-r1t-chimera:free",
  "messages": [
      {
        "role": "user",
        "content": $content
      }
    ]
  
}')" -s | jq -r '.choices[0].message.content' | mdcat
echo "=========================="

