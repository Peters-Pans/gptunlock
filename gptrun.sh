#!/bin/bash

# 假设smedia数组已经定义
smedia=([yes]="Yes" [no]="No" [web]="Web" [app]="App" [bad]="Bad" [nodata]="No Data")

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
    echo $response
}

get_unlock_type() {
    # 示例：根据 DNS 和 HTTP 请求结果决定解锁类型的逻辑
    echo "Unlock type determined based on DNS and HTTP checks."
}

OpenAITest() {
    chatgpt=()
    
    # 检查 chat.openai.com
    local checkunlockurl="chat.openai.com"
    local result1=$(check_dns $checkunlockurl)
    local http_status1=$(check_http "https://$checkunlockurl")
    
    # 检查 ios.chat.openai.com
    checkunlockurl="ios.chat.openai.com"
    local result4=$(check_dns $checkunlockurl)
    local http_status2=$(check_http "https://$checkunlockurl")
    
    # 检查 api.openai.com
    checkunlockurl="api.openai.com"
    local result7=$(check_dns $checkunlockurl)
    local http_status3=$(check_http "https://$checkunlockurl")
    
    # 解锁类型决定
    local resultunlocktype=$(get_unlock_type $result1 $http_status1 $result4 $http_status2 $result7 $http_status3)

    # 获取国家代码
    local countryCode="$(curl -sS --max-time 10 https://chat.openai.com/cdn-cgi/trace | grep 'loc=' | awk -F= '{print $2}')"

    # 根据结果设置状态
    if [ "$http_status2" != "403" ] && [ "$http_status1" != "403" ] && [[ "$http_status1" != "curl"* ]] && [[ "$http_status2" != "curl"* ]]; then
        chatgpt[ustatus]="${smedia[yes]}"
        chatgpt[uregion]="[$countryCode]"
        chatgpt[utype]="$resultunlocktype"
    elif [ "$http_status2" == "403" ] && [ "$http_status1" == "403" ]; then
        chatgpt[ustatus]="${smedia[no]}"
        chatgpt[uregion]="${smedia[nodata]}"
        chatgpt[utype]="${smedia[nodata]}"
    elif [ "$http_status1" != "403" ] && [ "$http_status2" == "403" ] && [[ "$http_status1" != "curl"* ]]; then
        chatgpt[ustatus]="${smedia[web]}"
        chatgpt[uregion]="[$countryCode]"
        chatgpt[utype]="$resultunlocktype"
    elif [ "$http_status1" == "403" ] && [ "$http_status2" != "403" ]; then
        chatgpt[ustatus]="${smedia[app]}"
        chatgpt[uregion]="[$countryCode]"
        chatgpt[utype]="$resultunlocktype"
    elif [[ "$http_status1" == "curl"* ]] && [ "$http_status2" == "403" ]; then
        chatgpt[ustatus]="${smedia[no]}"
        chatgpt[uregion]="${smedia[nodata]}"
        chatgpt[utype]="${smedia[nodata]}"
    else
        chatgpt[ustatus]="${smedia[bad]}"
        chatgpt[uregion]="${smedia[nodata]}"
        chatgpt[utype]="${smedia[nodata]}"
    fi
}

# 调用 OpenAITest 函数以测试其功能
OpenAITest

# 输出结果
echo "Status: ${chatgpt[ustatus]}"
echo "Region: ${chatgpt[uregion]}"
echo "Type: ${chatgpt[utype]}"

