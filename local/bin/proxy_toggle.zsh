PROXY_HOST="127.0.0.1"
PROXY_PORT="7890"
PROXY_BYPASS="localhost,127.0.0.1,::1,localaddress,.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"

proxy() {
  local action="$1"
  local address="${PROXY_HOST}:${PROXY_PORT}"
  local http_url="http://${address}"
  local socks_url="socks5://${address}"

  local set_proxy_internal() {
    export http_proxy="$http_url"
    export https_proxy="$http_url"
    export all_proxy="$socks_url"
    export no_proxy="$PROXY_BYPASS"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
    export ALL_PROXY="$all_proxy"
    export NO_PROXY="$no_proxy"

    echo "[>] 代理已启用: ${address}"
    echo "    http_proxy  = ${http_proxy}"
    echo "    https_proxy = ${https_proxy}"
    echo "    all_proxy   = ${all_proxy}"
    echo "    no_proxy    = ${no_proxy}"
  }

  local unset_proxy_internal() {
    unset http_proxy https_proxy all_proxy no_proxy
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
    echo "[x] 代理已禁用。"
  }

  local check_proxy_internal() {
    echo "[>] 当前代理变量状态:"
    echo "    http_proxy  : ${http_proxy:-未设置}"
    echo "    https_proxy : ${https_proxy:-未设置}"
    echo "    all_proxy   : ${all_proxy:-未设置}"
    echo "    no_proxy    : ${no_proxy:-未设置}"
  }

  case "$action" in
    "on")
      set_proxy_internal
      ;;
    "off")
      unset_proxy_internal
      ;;
    "check" | "")
      check_proxy_internal
      if [[ -z "$action" ]]; then
        echo ""
        echo "[>] 用法:"
        echo "  proxy on    : 启用代理 (${address})"
        echo "  proxy off   : 禁用代理"
        echo "  proxy check : 检查状态 (默认)"
      fi
      ;;
    *)
      echo "[x] 错误的参数: $action"
      echo ""
      echo "[>] 用法:"
      echo "  proxy on    : 启用代理 (${address})"
      echo "  proxy off   : 禁用代理"
      echo "  proxy check : 检查状态 (默认)"
      ;;
  esac
}
