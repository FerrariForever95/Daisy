# Daisy AI Agent

A friendly, supportive female AI agent that runs locally using Ollama with the qwen3:4b model. Daisy can listen to your questions, speak responses with high-quality local TTS (Piper), and even help you search the web.

## Features

- 💬 Conversational interface in the terminal
- 🔊 **High-quality text-to-speech** using Piper TTS (natural sounding voices) with fallback to espeak
- 🌐 Web search integration (opens browser with search query)
- 🖱️ Application opening via CLI (e.g., `open vscode`, `open chrome`)
- 🤖 Powered by local Ollama qwen3:4b model (no internet required for AI)
- 🖥️ Runs entirely locally on your machine

## Requirements

- [Ollama](https://ollama.com/) installed and running
- qwen3:4b model pulled: `ollama pull qwen3:4b`
- `curl`, `jq`, `aplay` (for audio playback) installed
- **Optional but recommended**: Piper TTS for high-quality voice output
  - Piper model files (we'll guide you through setup)
- A web browser (for search functionality)

## Installation

1. Clone this repository:
   ```bash
   git clone git@github.com:FerrariForever95/Daisy.git
   cd Daisy
   ```

2. Install dependencies:
   ```bash
   # On Ubuntu/Debian:
   sudo apt update
   sudo apt install -y ollama curl jq aplay

   # For Piper TTS (highly recommended for natural voice):
   # Method 1: Download pre-built binary (Linux x86_64)
   mkdir -p ~/.local/bin
   curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/piper-linux-amd64.tar.gz
   tar xzf piper-linux-amd64.tar.gz
   mv piper ~/.local/bin/
   chmod +x ~/.local/bin/piper
   export PATH="$HOME/.local/bin:$PATH"

   # Method 2: Or install via cargo (if you have Rust)
   # cargo install piper-tts

   # Download a high-quality voice model (example: en_US-lessac-medium)
   mkdir -p ~/.local/share/piper
   curl -LO https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx
   curl -LO https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json
   mv en_US-lessac-medium.onnx ~/.local/share/piper/
   mv en_US-lessac-medium.onnx.json ~/.local/share/piper/

   # On macOS with Homebrew:
   brew install ollama curl jq
   # For Piper on macOS: follow similar steps as above using the appropriate binary
   ```

3. Start Ollama and pull the model:
   ```bash
   ollama serve &
   ollama pull qwen3:4b
   ```

4. Make the script executable:
   ```bash
   chmod +x daisy.sh
   ```

## Usage

Run Daisy:
```bash
./daisy.sh
```

### Commands

- Type your questions or statements normally
- To search the web: `search for [your query]` or `search [your query]`
  - Example: `search for latest AI news`
- To open applications: `open [application]` (e.g., `open vscode`, `open chrome`, `open file manager`)
  - You can also specify arguments: `open vscode myproject`
- To exit: type `exit`, `quit`, `goodbye`, or `bye`

### Example Interaction

```
Daisy: Hello! I'm Daisy, your friendly AI assistant. How can I help you today?
You: What's the weather like today?
Daisy: I don't have access to real-time weather data, but you can check a weather website or app for the most current information.
You: search for today's weather in New York
Daisy: Opening browser to search for today's weather in New York
# Browser opens with Google search results
You: Tell me a joke
Daisy: Why don't scientists trust atoms anymore? Because they make up everything!
You: open vscode
Daisy: Opening Visual Studio Code
# VS Code opens
```

## How It Works

1. **Input**: You type your message in the terminal
2. **Processing**: Daisy sends your message to the local Ollama API running the qwen3:4b model
3. **Response**: The AI generates a response which is displayed in the terminal
4. **Speech**: The response is spoken aloud using **Piper TTS** (if installed) for natural voice quality, falling back to espeak if Piper is not available
5. **Search/Open**: Special commands open your default browser or applications

## Customization

- **Voice**: To change the Piper voice model, download different `.onnx` and `.json` files from [Hugging Face Piper voices](https://huggingface.co/rhasspy/piper-voices) and update the paths in the script:
  - `PIPER_MODEL="${HOME}/.local/share/piper/your-model.onnx"`
  - `PIPER_CONFIG="${HOME}/.local/share/piper/your-model.onnx.json"`
- **Speech rate/pitch**: Piper doesn't support rate/pitch via command line in this simple integration; choose different voice models for variation
- **Model**: Change the `MODEL` variable to use a different Ollama model
- **Browser**: Set the `BROWSER` environment variable or modify the script to use a specific browser
  - Example: `BROWSER=firefox ./daisy.sh`

## Notes

- The first response may take a moment as the model loads
- Ensure Ollama is running (`ollama serve`) before using Daisy
- All processing happens locally - no data leaves your machine unless you perform a web search or open an application
- Piper TTS runs entirely locally and produces high-quality, natural-sounding speech
- If Piper is not installed/found, the script automatically falls back to espeak (still functional but less natural)

## Troubleshooting

- **"Ollama model not found"**: Make sure you've pulled the model with `ollama pull qwen3:4b`
- **Piper not found**: Ensure `piper` is in your PATH and the model files exist at the paths specified in the script
- **No audio output**: 
  - Check that `aplay` is installed (part of alsa-utils)
  - Verify your system's audio is working with `aplay /usr/share/sounds/alsa/Front_Center.wav`
  - For Piper: test directly with `echo "test" | piper --model ~/.local/share/piper/en_US-lessac-medium.onnx --config ~/.local/share/piper/en_US-lessac-medium.onnx.json --output_raw | aplay -`
- **espeak not working**: Try installing additional voice packages: `sudo apt install espeak-ng-espeak`
- **Ollama not responding**: Verify Ollama is running with `curl http://localhost:11434/api/tags`

## License

MIT License - feel free to modify and distribute as you wish.

---

Enjoy chatting with Daisy! 🌼 (Now with much nicer voice!)