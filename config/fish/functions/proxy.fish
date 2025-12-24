function proxy --description "Manage proxy. Usage: proxy [off|port|ip:port]"
    # --- 默认配置 ---
    set -l default_ip "127.0.0.1"
    set -l default_port 7890
    # ----------------

    # 1. 判断是否为关闭指令 (proxy off)
    if test (count $argv) -eq 1
        if contains -- $argv[1] off down unset disable
            set -e http_proxy
            set -e https_proxy
            set -e all_proxy
            set -e no_proxy
            set -e HTTP_PROXY
            set -e HTTPS_PROXY
            set -e ALL_PROXY
            set -e NO_PROXY
            echo -e "Proxy Disabled (OFF)"
            return
        end
    end

    # 2. 开启代理的逻辑
    set -l address ""

    if test (count $argv) -eq 0
        # 无参数 -> 使用默认值
        set address "$default_ip:$default_port"
    else if string match -q "*:*" "$argv[1]"
        # 包含冒号 -> 视为 IP:Port
        set address "$argv[1]"
    else
        # 只有数字 -> 视为端口
        set address "$default_ip:$argv[1]"
    end

    # 设置环境变量
    set -gx http_proxy "http://$address"
    set -gx https_proxy "http://$address"
    set -gx all_proxy "socks5://$address"
    set -gx no_proxy "localhost,127.0.0.1,::1,localaddress,.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

    # 设置大写变量
    set -gx HTTP_PROXY "http://$address"
    set -gx HTTPS_PROXY "http://$address"
    set -gx ALL_PROXY "socks5://$address"
    set -gx NO_PROXY "$no_proxy"

    echo -e "Proxy Enabled: $address"
end
