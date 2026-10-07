# Daisy AI Agent

A friendly, supportive female AI agent that runs locally using Ollama with the qwen3:4b model. Daisy can listen to your questions, speak responses, and even help you search the web.

## Features

- 💬 Conversational interface in the terminal
- 🔊 Text-to-speech responses using `espeak`
- 🌐 Web search integration (opens browser with search query)
- 🤖 Powered by local Ollama qwen3:4b model (no internet required for AI)
- 🖥️ Runs entirely locally on your machine

## Requirements

- [Ollama](https://ollama.com/) installed and running
- qwen3:4b model pulled: `ollama pull qwen3:4b`
- `curl`, `jq`, `espeak` installed
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
   sudo apt install -y ollama curl jq espeak

   # On macOS with Homebrew:
   brew install ollama curl jq espeak
   ```

3. Start Ollama and pull the model:
   ```bash
   ollama serve &
   ollama pull qwen3:4b
   ```

4. Make the script executable (already done):
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
```

## How It Works

1. **Input**: You type your message in the terminal
2. **Processing**: Daisy sends your message to the local Ollama API running the qwen3:4b model
3. **Response**: The AI generates a response which is displayed in the terminal
4. **Speech**: The response is spoken aloud using `espeak` with a female voice
5. **Search**: Special search commands open your default browser with a Google search

## Customization

- **Voice**: Adjust the `TTS_COMMAND` in `daisy.sh` to change voice/speed
  - Example: `espeak -s 150 -v female2` for faster, different voice
- **Model**: Change the `MODEL` variable to use a different Ollama model
- **Browser**: Set the `BROWSER` environment variable or modify the script to use a specific browser
  - Example: `BROWSER=firefox ./daisy.sh`

## Notes

- The first response may take a moment as the model loads
- Ensure Ollama is running (`ollama serve`) before using Daisy
- All processing happens locally - no data leaves your machine unless you perform a web search
- For best speech quality, consider installing additional espeak voices

## Troubleshooting

- **"Ollama model not found"**: Make sure you've pulled the model with `ollama pull qwen3:4b`
- **espeak not working**: Try installing additional voice packages: `sudo apt install espeak-ng-espeak`
- **No audio output**: Check your system's audio settings and ensure espeak can access audio devices
- **Ollama not responding**: Verify Ollama is running with `curl http://localhost:11434/api/tags`

## License

MIT License - feel free to modify and distribute as you wish.

---

Enjoy chatting with Daisy! 🌼