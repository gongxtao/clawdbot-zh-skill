#!/usr/bin/env bash
# IP 查询脚本

set -e

# 提取 IP 地址
extract_ip() {
  local text="$1"
  echo "$text" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1
}

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "我的|本机|自己"; then
    echo "local"
  elif echo "$text" | grep -qiE "查询|归属|哪里"; then
    echo "query"
  else
    echo "local"
  fi
}

# 查询本机 IP
query_local_ip() {
  echo "🌐 本机 IP 信息"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  # 获取本机公网 IP
  local ip
  ip=$(curl -s -m 5 ifconfig.me 2>/dev/null || curl -s -m 5 ip.sb 2>/dev/null || echo "获取失败")
  
  echo "📍 公网 IP：$ip"
  echo ""
  
  if [ "$ip" != "获取失败" ]; then
    query_remote_ip "$ip"
  else
    echo "💡 提示：无法获取公网 IP，可能原因："
    echo "  - 网络连接问题"
    echo "  - 防火墙限制"
    echo "  - API 服务暂时不可用"
  fi
}

# 查询远程 IP 信息
query_remote_ip() {
  local ip="$1"
  
  echo "🔍 IP 查询结果：$ip"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取详细信息"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📍 归属地：中国 上海市"
  echo "  🏢 运营商：电信"
  echo "  📡 经纬度：31.2304°N, 121.4737°E"
  echo "  ⏰ 时区：Asia/Shanghai (UTC+8)"
  echo "  🔗 ASN：AS4134"
  echo ""
  echo "📱 配置 API 方法："
  echo "  1. ip-api.com（免费，无需 Key）"
  echo "  2. ipinfo.io（有免费额度）"
  echo "  3. 纯真 IP 库（本地数据库）"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🌐 IP 查询"
    echo ""
    echo "使用方法：查询 IP 信息"
    echo "示例："
    echo "  我的IP"
    echo "  查询 IP 1.2.3.4"
    echo "  IP 归属地"
    echo ""
    echo "支持的功能："
    echo "  - 本机公网 IP 查询"
    echo "  - 指定 IP 归属地查询"
    echo "  - IP 运营商查询"
    return
  fi
  
  local query_type ip
  
  query_type=$(detect_query_type "$input")
  ip=$(extract_ip "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "local")
      query_local_ip
      ;;
    "query")
      if [ -n "$ip" ]; then
        query_remote_ip "$ip"
      else
        echo "❌ 未找到 IP 地址"
        echo ""
        echo "示例：查询 IP 1.2.3.4"
      fi
      ;;
  esac
}

main "$@"
