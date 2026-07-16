<<<<<<< HEAD
#!/bin/env zsh

ai="gemma2:2b"
pyenv="/home/nyx/Documents/TerminalAI/.venv/bin/activate"

source $pyenv

if [[ $# < 1 ]]; then
    echo "Usage: $0 OPTION"
    echo "Options:"
    echo "  start    - to start gemma2:2b"
    echo "  stop     - to stop LLM"
    echo "  ps       - to check process of LLM"
    echo "  <prompt> - to prompt LLM"
fi

function f_start {
    ollama run $ai --keepalive -1m ""
}

function f_stop {
    ollama stop $ai
}

function f_ps {
    local ollama=$(ollama ps | awk '{print $1" " $3 $4}' | tail -n1)
    if [[ $ollama == "NAME SIZEPROCESSOR" ]]; then
        echo "❌ LLM isn't running"
        return 1
    fi

    if [[ $1 != "s" ]]; then
        echo $ollama
    fi
    return 0
}


if [[ $1 == "start" ]]; then
    f_start
elif [[ $1 == "stop" ]]; then
    f_stop
elif [[ $1 == "ps" ]]; then
    f_ps
else
    f_ps "s"
    if [[ $? == 1 ]]; then
        echo "✅ Running LLM"
        f_start
    fi
    ollama run $ai $(echo $@) | md2term
fi

deactivate

