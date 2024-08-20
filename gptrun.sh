#!/bin/bash

# 定义要检查的域名列表
domains=(
    "challenges.cloudflare.com"
    "ai.com"
    "openai.com"
    "cdn.oaistatic.com"
    "chatgpt.com"
    "auth0.com"
    "oaistatic.com"
    "stripe.com"
    "arkoselabs.com"
    "openaiapi-site.azureedge.net"
)

# 检查每个域名是否可以访问
check_access() {
    for domain in "${domains[@]}"; do
        echo "Checking access to $domain..."
        response=$(curl -s -o /dev/null -w "%{http_code}" https://$domain)
        
        if [ "$response" -eq 200 ] || [ "$response" -eq 308 ] || [ "$response" -eq 301 ]; then
            echo "$domain: Access Allowed"
        else
            echo "$domain: Access Blocked or Restricted (HTTP Status: $response)"
        fi
    done
}

# 执行检查
check_access
