#!/bin/bash
# dependencies: sudo apt install jq

# Define input parameters
UserMessage=""
SystemMessage=""
Model="gpt-3.5-turbo"
Temperature=1.0
Url="https://api.openai.com/v1/chat/completions"
Raw=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--user-message)
            UserMessage="$2"
            shift 2
            ;;
        -s|--system-message)
            SystemMessage="$2"
            shift 2
            ;;
        -m|--model)
            Model="$2"
            shift 2
            ;;
        -t|--temperature)
            Temperature="$2"
            shift 2
            ;;
        --raw)
            Raw=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Set the API key
ApiKey="$OPENAI_API_KEY"

# Create the request JSON
Request='{"model": "'"$Model"'","messages": [{"role": "user","content": "'"$UserMessage"'"}'
# Add system message if provided
if [ -n "$SystemMessage" ]; then
    Request+=',{"role": "system","content": "'"$SystemMessage"'"}'
fi
# Close the request JSON
Request+='],"temperature": '"$Temperature"'}'

# Make the API request
Response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $ApiKey" -d "$Request" "$Url")

# Handle errors
if [ $? -ne 0 ]; then
    echo "Error making API request."
    exit 1
fi

# Parse and display the response
if [ "$Raw" = true ]; then
    echo "$Response"
else
    ResponseMessage=$(echo "$Response" | jq -r '.choices[0].message.content' | sed 's/\\n/\n/g')
    PromptTokens=$(echo "$Response" | jq -r '.usage.prompt_tokens')
    CompletionTokens=$(echo "$Response" | jq -r '.usage.completion_tokens')
    TotalTokens=$(echo "$Response" | jq -r '.usage.total_tokens')

    echo "$ResponseMessage"
    echo -e "\nPrompt tokens: $PromptTokens" 
    echo "Completion tokens: $CompletionTokens"
    echo "Total tokens: $TotalTokens"
fi

