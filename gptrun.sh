#!/bin/bash

check_chatgpt_web_access() {
    echo "Checking ChatGPT Web Access..."
    
    response=$(curl -s -o /dev/null -w "%{http_code}" https://chat.openai.com/)
    
    if [ "$response" -eq 200 ] || [ "$response" -eq 308 ]; then
        echo "ChatGPT Web Access: Allowed"
    else
        echo "ChatGPT Web Access: Blocked or Restricted"
    fi
}

check_chatgpt_web_access
