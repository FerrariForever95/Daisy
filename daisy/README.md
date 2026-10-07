# Daisy AI Agent

A friendly, supportive female AI agent that runs locally using Ollama with the qwen3:4b model. Daisy can listen to your questions, speak responses, and even help you search the web.

## Features

- 💬 Conversational interface in the terminal (classic version)
- 🖥️ **Optional**: Whiptail/Dialog UI version (`daisy_ui.sh`) for a more interactive terminal experience
- 🔊 Text-to-speech responses using `espeak`
- 🌐 Web search integration (opens browser with search query)
- 🖱️ Application opening via CLI (e.g., `open vscode`, `open chrome`)
- 🤖 Powered by local Ollama qwen3:4b model (no internet required for AI)
- 🖥️ Runs entirely locally on your machine

## Requirements

- [Ollama](https://ollama.com/) installed and running
- qwen3:4b model pulled: `ollama pull qwen3:4b`
- `curl`, `jq` installed
- `espeak` installed (optional, for speech output)
- `whiptail` or `dialog` installed (for UI version)
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
   sudo apt install -y ollama curl jq espeak whiptail

   # On macOS with Homebrew:
   brew install ollama curl jq espeak
   # For whiptail on macOS: brew install newt (provides whiptail)
   ```

3. Start Ollama and pull the model:
   ```bash
   ollama serve &
   ollama pull qwen3:4b
   ```

4. Make the scripts executable:
   ```bash
   chmod +x daisy.sh daisy_ui.sh
   ```

## Usage

### Classic Terminal Version
Run Daisy in simple terminal mode:
```bash
./daisy.sh
```

### Whiptail/Dialog UI Version
Run Daisy with a more interactive terminal UI:
```bash
./daisy_ui.sh
```

### Commands (in both versions)

- Type your questions or statements normally
- To search the web: `search for [your query]` or `search [your query]`
  - Example: `search for latest AI news`
- To open applications: `open [application]` (e.g., `open vscode`, `open chrome`, `open file manager`)
  - You can also specify arguments: `open vscode myproject`
- To exit: type `exit`, `quit`, `goodbye`, or `bye` (or use the Cancel button in UI version)

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

1. **Input**: You type your message in the terminal (or inputbox in UI version)
2. **Processing**: Daisy sends your message to the local Ollama API running the qwen3:4b model
3. **Response**: The AI generates a response which is displayed in the terminal (or msgbox in UI version)
4. **Speech**: The response is spoken aloud using `espeak` with a female voice (if installed)
5. **Search/Open**: Special commands open your default browser or applications

## Customization

- **Voice**: Adjust the `TTS_COMMAND` in the scripts to change voice/speed
  - Example: `espeak -s 150 -v female2` for faster, different voice
- **Model**: Change the `MODEL` variable to use a different Ollama model
- **Browser**: Set the `BROWSER` environment variable or modify the script to use a specific browser
  - Example: `BROWSER=firefox ./daisy.sh`

## Notes

- The first response may take a moment as the model loads
- Ensure Ollama is running (`ollama serve`) before using Daisy
- All processing happens locally - no data leaves your machine unless you perform a web search or open an application
- For best speech quality, consider installing additional espeak voices
- The UI version uses whiptail by default, falling back to dialog if whiptail is not available

## Troubleshooting

- **"Ollama model not found"**: Make sure you've pulled the model with `ollama pull qwen3:4b`
- **espeak not working**: Try installing additional voice packages: `sudo apt install espeak-ng-espeak`
- **No audio output**: Check your system's audio settings and ensure espeak can access audio devices
- **UI not found**: Install whiptail (`sudo apt install whiptail`) or dialog (`sudo apt install dialog`)
- **Ollama not responding**: Verify Ollama is running with `curl http://localhost:11434/api/tags`

## License

MIT License - feel free to modify and distribute as you wish.

---

Enjoy chatting with Daisy! 🌼