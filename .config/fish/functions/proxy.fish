function proxy --description "Manage proxy. Usage: proxy [off|port|ip:port]"
    set -l default_ip "127.0.0.1"
    set -l default_port 7890
    set -l bypass "localhost,127.0.0.1,::1,localaddress,.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

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
            echo "Proxy Disabled (OFF)"
            return
        end
    end

    set -l address ""

    if test (count $argv) -eq 0
        set address "$default_ip:$default_port"
    else if string match -q "*:*" "$argv[1]"
        set address "$argv[1]"
    else
        set address "$default_ip:$argv[1]"
    end

    set -gx http_proxy "http://$address"
    set -gx https_proxy "http://$address"
    set -gx all_proxy "socks5://$address"
    set -gx no_proxy "$bypass"

    set -gx HTTP_PROXY "$http_proxy"
    set -gx HTTPS_PROXY "$https_proxy"
    set -gx ALL_PROXY "$all_proxy"
    set -gx NO_PROXY "$no_proxy"

    echo "Proxy Enabled: $address"
end
