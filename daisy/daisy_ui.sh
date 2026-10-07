#!/bin/bash
# Daisy AI Agent - Whiptail UI Version
# A friendly, supportive female bot that runs in a terminal UI using whiptail/dialog
# Uses Ollama qwen3:4b for AI responses
# Features:
#   - Text input via whiptail inputbox
#   - Responses displayed in whiptail msgbox
#   - Optional web search via browser
#   - Application opening via CLI
#   - Uses local Ollama with qwen3:4b model

# Configuration
OLLAMA_HOST="http://localhost:11434"
MODEL="qwen3:4b"
TTS_COMMAND="espeak -s 130 -v female3"  # Adjust voice/speed as needed
BROWSER="${BROWSER:-xdg-open}"  # Use xdg-open to open default browser, or set to firefox/chrome etc.
UI_CMD="whiptail"  # Prefer whiptail, fallback to dialog
if ! command -v whiptail &> /dev/null; then
    if command -v dialog &> /dev/null; then
        UI_CMD="dialog"
    else
        echo "Error: Neither whiptail nor dialog is installed. Please install one of them."
        echo "On Ubuntu/Debian: sudo apt install whiptail"
        exit 1
    fi
fi

# Check dependencies
check_dependencies() {
    local deps=(curl jq)
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

# Speak text using espeak (if available)
speak() {
    local text="$1"
    if command -v espeak &> /dev/null; then
        echo "$text" | $TTS_COMMAND 2>/dev/null
    fi
}

# Open application or file
open_application() {
    local app="$1"
    local arg="$2"

    # Common application mappings
    case "$app" in
        "vscode"|"code"|"visual studio code")
            if command -v code &> /dev/null; then
                code "$arg" 2>/dev/null &
                ui_msgbox "Daisy: Opening Visual Studio Code${arg:+ with project: $arg}"
                speak "Opening Visual Studio Code"
                return 0
            else
                ui_msgbox "Daisy: Visual Studio Code not found. Please install it or make sure 'code' command is available."
                speak "Visual Studio Code not found"
                return 1
            fi
            ;;
        "chrome"|"google chrome")
            if command -v google-chrome &> /dev/null; then
                google-chrome "$arg" 2>/dev/null &
                ui_msgbox "Daisy: Opening Google Chrome${arg:+ with URL: $arg}"
                speak "Opening Google Chrome"
                return 0
            elif command -v chromium-browser &> /dev/null; then
                chromium-browser "$arg" 2>/dev/null &
                ui_msgbox "Daisy: Opening Chromium Browser${arg:+ with URL: $arg}"
                speak "Opening Chromium Browser"
                return 0
            else
                echo "Daisy: Chrome/Chromium not found. Trying default browser..."
                if [[ -n "$arg" ]]; then
                    xdg-open "$arg" 2>/dev/null &
                else
                    xdg-open "https://www.google.com" 2>/dev/null &
                fi
                ui_msgbox "Daisy: Opening default browser${arg:+ with URL: $arg}"
                speak "Opening default browser"
                return 0
            fi
            ;;
        "firefox"|"mozilla firefox")
            if command -v firefox &> /dev/null; then
                firefox "$arg" 2>/dev/null &
                ui_msgbox "Daisy: Opening Firefox${arg:+ with URL: $arg}"
                speak "Opening Firefox"
                return 0
            else
                echo "Daisy: Firefox not found. Trying default browser..."
                if [[ -n "$arg" ]]; then
                    xdg-open "$arg" 2>/dev/null &
                else
                    xdg-open "https://www.google.com" 2>/dev/null &
                fi
                ui_msgbox "Daisy: Opening default browser${arg:+ with URL: $arg}"
                speak "Opening default browser"
                return 0
            fi
            ;;
        "browser"|"web")
            if [[ -n "$arg" ]]; then
                xdg-open "$arg" 2>/dev/null &
            else
                xdg-open "https://www.google.com" 2>/dev/null &
            fi
            ui_msgbox "Daisy: Opening default browser${arg:+ with URL: $arg}"
            speak "Opening default browser"
            return 0
            ;;
        "terminal"|"console")
            if command -v gnome-terminal &> /dev/null; then
                gnome-terminal 2>/dev/null &
                ui_msgbox "Daisy: Opening terminal"
                speak "Opening terminal"
                return 0
            elif command -v konsole &> /dev/null; then
                konsole 2>/dev/null &
                ui_msgbox "Daisy: Opening terminal"
                speak "Opening terminal"
                return 0
            elif command -v xterm &> /dev/null; then
                xterm 2>/dev/null &
                ui_msgbox "Daisy: Opening terminal"
                speak "Opening terminal"
                return 0
            else
                ui_msgbox "Daisy: Could not find a terminal emulator"
                speak "Could not find terminal"
                return 1
            fi
            ;;
        "file manager"|"files"|"finder")
            local dir="$arg"
            if [[ -z "$dir" ]]; then
                dir="$HOME"
            fi
            if command -v nautilus &> /dev/null; then
                nautilus "$dir" 2>/dev/null &
                ui_msgbox "Daisy: Opening file manager${dir:+ at: $dir}"
                speak "Opening file manager"
                return 0
            elif command -v dolphin &> /dev/null; then
                dolphin "$dir" 2>/dev/null &
                ui_msgbox "Daisy: Opening file manager${dir:+ at: $dir}"
                speak "Opening file manager"
                return 0
            elif command -v thunar &> /dev/null; then
                thunar "$dir" 2>/dev/null &
                ui_msgbox "Daisy: Opening file manager${dir:+ at: $dir}"
                speak "Opening file manager"
                return 0
            else
                xdg-open "$dir" 2>/dev/null &
                ui_msgbox "Daisy: Opening file manager${dir:+ at: $dir}"
                speak "Opening file manager"
                return 0
            fi
            ;;
        *)
            # Try to open with xdg-open for URLs, files, or unknown applications
            if [[ "$app" =~ ^https?:// ]]; then
                xdg-open "$app" 2>/dev/null &
                ui_msgbox "Daisy: Opening URL: $app"
                speak "Opening URL"
                return 0
            elif [[ -n "$arg" && (-f "$arg" || -d "$arg") ]]; then
                xdg-open "$arg" 2>/dev/null &
                ui_msgbox "Daisy: Opening file/directory: $arg"
                speak "Opening file"
                return 0
            elif [[ -f "$app" || -d "$app" ]]; then
                xdg-open "$app" 2>/dev/null &
                ui_msgbox "Daisy: Opening file/directory: $app"
                speak "Opening file"
                return 0
            else
                # Try as a command
                if command -v "$app" &> /dev/null; then
                    "$app" "$arg" 2>/dev/null &
                    ui_msgbox "Daisy: Opening $app${arg:+ with arguments: $arg}"
                    speak "Opening $app"
                    return 0
                else
                    ui_msgbox "Daisy: I don't know how to open '$app'. Try specifying a file, URL, or known application."
                    speak "Don't know how to open that"
                    return 1
                fi
            fi
            ;;
    esac
}

# Show message box
ui_msgbox() {
    local title="$1"
    local text="$2"
    local height=${3:-10}
    local width=${4:-50}
    $UI_CMD --title "$title" --msgbox "$text" $height $width
}

# Get input from user
ui_inputbox() {
    local title="$1"
    local prompt="$2"
    local init="${3:-}"
    local height=${4:-10}
    local width=${5:-50}
    local result
    result=$($UI_CMD --title "$title" --inputbox "$prompt" $height $width "$init" 3>&1 1>&2 2>&3)
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "$result"
    else
        # User pressed Cancel or ESC
        echo "__CANCEL__"
    fi
}

# Show yes/no dialog
ui_yesno() {
    local title="$1"
    local text="$2"
    local height=${3:-10}
    local width=${4:-50}
    $UI_CMD --title "$title" --yesno "$text" $height $width
    return $?
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

# Handle special commands like search, open, etc.
handle_special_command() {
    local input="$1"

    # Check for search commands
    if [[ "$input" =~ ^search[[:space:]]+for[[:space:]]+(.+)$ ]] || [[ "$input" =~ ^search[[:space:]]+(.+)$ ]]; then
        local query="${BASH_REMATCH[1]}"
        query=$(echo "$query" | sed 's/ /+/g')  # Simple URL encoding for spaces
        local url="https://www.google.com/search?q=${query}"
        ui_msgbox "Daisy: Opening browser to search for: $query"
        speak "Opening browser to search for $query"
        $BROWSER "$url" 2>/dev/null &
        return 0
    fi

    # Check for open commands
    if [[ "$input" =~ ^open[[:space:]]+(.+)$ ]]; then
        local app_query="${BASH_REMATCH[1]}"

        # Check if it's a search query within open command
        if [[ "$app_query" =~ ^search[[:space:]]+for[[:space:]]+(.+)$ ]] || [[ "$app_query" =~ ^search[[:space:]]+(.+)$ ]]; then
            local search_term="${BASH_REMATCH[1]}"
            search_term=$(echo "$search_term" | sed 's/ /+/g')
            local url="https://www.google.com/search?q=${search_term}"
            ui_msgbox "Daisy: Opening browser to search for: $search_term"
            speak "Opening browser to search for $search_term"
            $BROWSER "$url" 2>/dev/null &
            return 0
        fi

        # Parse the application and optional argument
        local app="$app_query"
        local arg=""

        # Check if there's a second argument (like "open vscode myproject")
        if [[ "$app_query" =~ ^([^[:space:]]+)[[:space:]]+(.*)$ ]]; then
            app="${BASH_REMATCH[1]}"
            arg="${BASH_REMATCH[2]}"
        fi

        ui_msgbox "Daisy: Opening $app${arg:+ with argument: $arg}"
        speak "Opening $app"
        open_application "$app" "$arg"
        return 0
    fi

    # If we get here, no special command was matched
    return 1
}

# Main loop
main() {
    check_dependencies
    ui_msgbox "Welcome to Daisy" "Hello! I'm Daisy, your friendly AI assistant. How can I help you today?" 8 50
    speak "Hello! I'm Daisy, your friendly AI assistant. How can I help you today?"

    while true; do
        local user_input
        user_input=$(ui_inputbox "Daisy AI Agent" "Enter your question or command (type 'exit' to quit):" "" 10 60)

        # Check if user cancelled or pressed ESC
        if [[ "$user_input" == "__CANCEL__" ]]; then
            if ui_yesno "Daisy" "Do you really want to exit?" 8 50; then
                break
            else
                continue
            fi
        fi

        # Check for exit
        if [[ "$user_input" =~ ^(exit|quit|goodbye|bye)$ ]]; then
            ui_msgbox "Daisy" "Goodbye! Have a wonderful day!" 8 50
            speak "Goodbye! Have a wonderful day!"
            break
        fi

        # Handle special commands (like search, open)
        if handle_special_command "$user_input"; then
            continue
        fi

        # Get response from Ollama
        ui_msgbox "Daisy" "Thinking..." 6 40 &
        local thinking_pid=$!
        local response
        response=$(get_ollama_response "$user_input")
        kill $thinking_pid 2>/dev/null
        wait $thinking_pid 2>/dev/null

        if [[ -z "$response" ]]; then
            response="I'm sorry, I couldn't generate a response. Please try again."
        fi

        # Truncate response if too long for msgbox (whiptail has limits)
        if [ ${#response} -gt 2000 ]; then
            response="${response:0:2000}... [Response truncated]"
        fi

        ui_msgbox "Daisy's Response" "$response" 12 70
        speak "$response"
    done
}

# Run main
main "$@"