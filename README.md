# MyAICLI-Assistant

A command‑line AI assistant with two modes:

- **Local** – runs a lightweight LLM (`gemma2:2b`) via Ollama  
- **Cloud** – uses the OpenRouter API to access powerful models (e.g., `openrouter/owl-alpha`)

Both scripts render Markdown output beautifully using `mdcat`.

---

## Features

- 🧠 **Local mode** – full privacy, no internet required once the model is pulled  
- 🌐 **Cloud mode** – access to many state‑of‑the‑art models via OpenRouter  
- ⏳ **Spinner animation** – shows “Thinking…” while the cloud model generates a response  
- 📄 **Markdown rendering** – outputs nicely formatted text in your terminal  
- 🛠 **Process management** – start, stop, and check the status of the local LLM  
- 🔄 **Automatic start** – if the local model isn’t running, `ai.sh` starts it for you  

---

## Requirements

### Common

- `bash` or `zsh` (the scripts use shebangs for `zsh` and `bash`)  
- `mdcat` – for Markdown rendering
  Ccargo install mdcat   # or use your package manager  
- `curl` and `jq` – for the cloud script  

### Local mode (`ai.sh`)

- Ollama installed and running  
- The model `gemma2:2b` pulled (or change the `ai` variable in the script)  

### Cloud mode (`ai-net.sh`)

- An OpenRouter API key  
- The model `openrouter/owl-alpha` (default) – you can change it in the `curl` payload  

### Python Virtual Environment (optional)

Both scripts source a Python virtual environment (`.venv/bin/activate`).  
If you don’t need Python packages, you can remove or comment out the `source $pyenv` lines.

---

## Installation

1. **Clone the repository**  
   ```bash
   git clone https://github.com/yourusername/MyAICLI-Assistant.git
   cd MyAICLI-Assistant  
   ```
   
2. **Make the scripts executable**  
   ```bash
   chmod +x ai.sh ai-net.sh  
   ```
   
3. **(Optional) Set up the virtual environment**  
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   # install any needed packages (none are required by default)
   deactivate  
   ```
   
5. **Pull the local model (for `ai.sh`)**  
    ```bash
   ollama pull gemma2:2b  
    ```
---

## Configuration

### Local mode (`ai.sh`)

- Change the model by editing the `ai` variable at the top of the script.  
- The `pyenv` variable points to the virtual environment – adjust if needed.

### Cloud mode (`ai-net.sh`)

- Set your OpenRouter token – replace `YOUR_OPENROUTER_TOCKEN` with your actual API key.  
- You can also change the model and other parameters (like `stream`) inside the `curl` payload.

---

## Usage

### Local mode – `./ai.sh`
```bash
./ai.sh [OPTION | PROMPT]
```

| Option        | Description                                 |
|---------------|---------------------------------------------|
| `start`       | Start the Ollama model in the background    |
| `stop`        | Stop the running model                      |
| `ps`          | Show the status of the model (running/not)  |
| `<prompt>`    | Send a prompt to the model (auto‑starts if needed) |

**Examples:**  
```bash
./ai.sh "Explain quantum computing in simple terms"
./ai.sh start
./ai.sh ps
./ai.sh stop  
```

If you run `./ai.sh` with no arguments, it prints the help message.

### Cloud mode – `./ai-net.sh`
```bash
./ai-net.sh "Your prompt here"  
```
**Example:**  
./ai-net.sh "Write a haiku about autumn"  

The script shows a spinner while waiting for the API response, then streams the output in real time, formatted with `mdcat`.

---

## Script Details

### `ai.sh` (Ollama local)

- Uses `zsh` (but works with `bash` too if you change the shebang).  
- Defines functions:  
  - `f_start` – starts the model with `--keepalive -1m` (keeps it alive for 1 minute after the last request).  
  - `f_stop` – stops the model.  
  - `f_ps` – checks if the model is running; if called with `s` argument, it returns silently (used internally).  
- When you provide a prompt, it first checks if the model is running; if not, it starts it automatically.  
- The response is piped through `md2term` (provided by `mdcat`) for Markdown rendering.

### `ai-net.sh` (OpenRouter)

- Uses `bash`.  
- Defines a spinner function that displays an animated cursor while the API request is in progress.  
- Sends a POST request to `https://openrouter.ai/api/v1/chat/completions` with a JSON payload.  
- Parses the Server‑Sent Events (SSE) stream, extracts the content chunks, and prints them.  
- The full output is piped through `md2term` for formatting.  
- If the prompt is missing, it prints an error and exits.

---

## Troubleshooting

- **`mdcat` not found** – install it via `cargo install mdcat` or your package manager (e.g., `brew install mdcat` on macOS).  
- **Ollama not running** – start the Ollama service with `ollama serve` (or ensure it’s running as a daemon).  
- **Permission denied** – make the scripts executable with `chmod +x`.  
- **OpenRouter errors** – check that your token is valid and that you have credits/access to the chosen model.  
- **Virtual environment path** – if you don’t use a venv, remove the `source` lines or update the path.

---

## Credits

- [Ollama](https://ollama.com/) – local LLM runner  
- [OpenRouter](https://openrouter.ai/) – unified API for many models  
- [`mdcat`](https://github.com/swsnr/mdcat) – terminal Markdown renderer  
- [`jq`](https://stedolan.github.io/jq/) – JSON processor  

---

## License

This project is open source – feel free to use, modify, and share.
