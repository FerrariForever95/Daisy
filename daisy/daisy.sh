#!/bin/bash
# Daisy AI Agent - Shell Version
# A friendly, supportive female bot that listens, speaks, and answers questions using Ollama qwen3:4b
# Features:
#   - Text input via terminal
#   - Text-to-speech using espeak
#   - Optional web search via browser
#   - Uses local Ollama with qwen3:4b model

# Configuration
OLLAMA_HOST="http://localhost:11434"
MODEL="qwen3:4b"
TTS_COMMAND="espeak -s 130 -v female3"  # Adjust voice/speed as needed
BROWSER="${BROWSER:-xdg-open}"  # Use xdg-open to open default browser, or set to firefox/chrome etc.

# Check dependencies
check_dependencies() {
    local deps=(curl jq espeak)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is not installed. Please install it."
            echo "On Ubuntu/Debian: sudo apt install $dep"
            exit 1
        fi
    done

    # Check if Ollama is running and model is available
    if ! curl -s "${OLLAMA_HOST}/api/tags" | jq -e '.models[] | select(.name == "'"$MODEL"'")' &> /dev/null; then
        echo "Error: Ollama model '$MODEL' not found or Ollama not running."
        echo "Please ensure Ollama is running and you have pulled the model:"
        echo "  ollama pull $MODEL"
        exit 1
    fi
}

# Speak text using espeak
speak() {
    local text="$1"
    echo "$text" | $TTS_COMMAND 2>/dev/null
}

# Send message to Ollama and get response
get_ollama_response() {
    local prompt="$1"
    local response

    response=$(curl -s -X POST "${OLLAMA_HOST}/api/generate" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$MODEL\",
            \"prompt\": \"$prompt\",
            \"stream\": false
        }" | jq -r '.response // empty')

    echo "$response"
}

# Handle special commands like search
handle_special_command() {
    local input="$1"
    # Check for search commands
    if [[ "$input" =~ ^search[[:space:]]+for[[:space:]]+(.+)$ ]] || [[ "$input" =~ ^search[[:space:]]+(.+)$ ]]; then
        local query="${BASH_REMATCH[1]}"
        query=$(echo "$query" | sed 's/ /+/g')  # Simple URL encoding for spaces
        local url="https://www.google.com/search?q=${query}"
        echo "Daisy: Opening browser to search for: $query"
        speak "Opening browser to search for $query"
        $BROWSER "$url" 2>/dev/null &
        return 0
    fi
    return 1
}

# Main loop
main() {
    check_dependencies
    echo "Daisy: Hello! I'm Daisy, your friendly AI assistant. How can I help you today?"
    speak "Hello! I'm Daisy, your friendly AI assistant. How can I help you today?"

    while true; do
        echo -n "You: "
        read -r user_input

        # Check for exit
        if [[ "$user_input" =~ ^(exit|quit|goodbye|bye)$ ]]; then
            echo "Daisy: Goodbye! Have a wonderful day!"
            speak "Goodbye! Have a wonderful day!"
            break
        fi

        # Handle special commands (like search)
        if handle_special_command "$user_input"; then
            continue
        fi

        # Get response from Ollama
        echo "Daisy: Thinking..."
        response=$(get_ollama_response "$user_input")

        if [[ -z "$response" ]]; then
            response="I'm sorry, I couldn't generate a response. Please try again."
        fi

        echo "Daisy: $response"
        speak "$response"
    done
}

# Run main
main "$@"