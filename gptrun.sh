#!/bin/bash

check_dns() {
    local url=$1
    if nslookup "$url" >/dev/null 2>&1; then
        echo "DNS for $url resolved successfully."
    else
        echo "DNS for $url failed to resolve."
        return 1
    fi
}

check_http() {
    local url=$1
    local response=$(curl -sS --max-time 10 -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" == "200" ]; then
        echo "HTTP request to $url succeeded (HTTP 200)."
        return 0
    elif [ "$response" == "403" ]; then
        echo "HTTP request to $url returned 403 Forbidden."
        return 1
    else
        echo "HTTP request to $url failed with code $response."
        return 1
    fi
}

check_chatgpt_access() {
    local url_list=("chat.openai.com" "ios.chat.openai.com" "api.openai.com")
    local all_accessible=true

    for url in "${url_list[@]}"; do
        check_dns "$url"
        if ! check_http "https://$url"; then
            all_accessible=false
        fi
    done

    if [ "$all_accessible" == true ]; then
        echo "All ChatGPT services are accessible."
    else
        echo "One or more ChatGPT services are not accessible."
    fi
}

# 调用检查函数
check_chatgpt_access

