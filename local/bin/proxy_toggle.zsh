# ======================================
# Zsh 代理设置函数 (proxy)
# 用法: proxy [on|off|check]
# --------------------------------------

# --- 代理服务器配置 ---
# 更改为代理地址和端口
PROXY_HOST="127.0.0.1"
PROXY_PORT="7897"
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

proxy() {
  local action="$1"

  # --- 1. 设置代理函数 (内部实现) ---
  local set_proxy_internal() {
    echo "[>] 正在设置代理到: ${PROXY_URL}"

    # 导出 HTTP/HTTPS/All 代理变量 (小写用于大多数工具)
    export http_proxy=$PROXY_URL
    export https_proxy=$PROXY_URL
    export all_proxy=$PROXY_URL
    
    # 导出大写变量 (用于部分工具如 apt)
    export HTTP_PROXY=$PROXY_URL
    export HTTPS_PROXY=$PROXY_URL
    export ALL_PROXY=$PROXY_URL

    # 可选: 如果需要 SOCKS 代理 (很多科学上网工具也提供)
    export ALL_PROXY="socks5://${PROXY_HOST}:${PROXY_PORT}"

    echo "[>] 代理变量已设置:"
    echo "    http_proxy  = ${http_proxy}"
    echo "    https_proxy = ${https_proxy}"
    echo "    all_proxy   = ${all_proxy}"
  }

  # --- 2. 取消代理函数 (内部实现) ---
  local unset_proxy_internal() {
    echo "[x] 正在清除代理变量..."

    # 清除所有代理变量 (包括大小写)
    unset http_proxy
    unset https_proxy
    unset all_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY

    echo "[x] 代理变量已清除 (http_proxy, https_proxy, all_proxy)。"
  }

  # --- 3. 检查代理状态函数 (内部实现) ---
  local check_proxy_internal() {
    echo "[>] 当前代理变量状态:"
    
    local http_status="未设置 ([x] 禁用)"
    if [[ -n "$http_proxy" ]]; then
      http_status="${http_proxy} ([>] 启用)"
    fi
    echo "    http_proxy  : ${http_status}"
    
    local https_status="未设置"
    if [[ -n "$https_proxy" ]]; then
      https_status="${https_proxy}"
    fi
    echo "    https_proxy : ${https_status}"
    
    local all_status="未设置"
    if [[ -n "$all_proxy" ]]; then
      all_status="${all_proxy}"
    fi
    echo "    all_proxy   : ${all_status}"
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
        echo -e "\n[>] 用法:"
        echo "  proxy on    : 启用代理 ($PROXY_URL)"
        echo "  proxy off   : 禁用代理"
        echo "  proxy check : 检查状态 (默认)"
      fi
      ;;
    *)
      echo "[x] 错误的参数: $action"
      echo -e "\n[>] 用法:"
      echo "  proxy on    : 启用代理 ($PROXY_URL)"
      echo "  proxy off   : 禁用代理"
      echo "  proxy check : 检查状态 (默认)"
      ;;
  esac
}
# ======================================
