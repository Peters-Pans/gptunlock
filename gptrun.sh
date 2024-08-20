check_chatgpt_access() {
    # 检测 ChatGPT 网页访问
    web_result=$(curl -s -o /dev/null -w "%{http_code}" https://chat.openai.com/)
    if [ "$web_result" == "200" ]; then
        echo "ChatGPT Web Access: Allowed"
    else
        echo "ChatGPT Web Access: Blocked or Restricted"
    fi

    # 检测 ChatGPT App 访问 (可以通过API端点模拟检测)
    app_result=$(curl -s -o /dev/null -w "%{http_code}" https://api.openai.com/v1/completions)
    if [ "$app_result" == "401" ]; then
        echo "ChatGPT App Access: Allowed (Unauthorized but reachable)"
    else
        echo "ChatGPT App Access: Blocked or Restricted"
    fi
}

main() {
    # 调用检测函数
    check_chatgpt_access
}

# 运行主程序
main
