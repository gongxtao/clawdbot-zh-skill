#!/usr/bin/env bash
# 短链接生成脚本

set -e

# 提取 URL
extract_url() {
  local text="$1"
  echo "$text" | grep -oE 'https?://[^[:space:]]+' | head -1
}

# 生成短链接
generate_shorturl() {
  local url="$1"
  
  echo "🔗 短链接生成"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📌 原始链接：$url"
  echo ""
  
  echo "💡 提示：配置短链接 API 可生成真实短链接"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  🔗 短链接服务："
  echo "     - T.cn：https://t.cn/AbCdEf"
  echo "     - Sina.lt：https://sina.lt/AbCdEf"
  echo "     - Suo.im：https://suo.im/AbCdEf"
  echo ""
  echo "  📊 短链接信息："
  echo "     - 点击次数：0 次"
  echo "     - 有效期：永久"
  echo "     - 创建时间：刚刚"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时生成短链接"
  echo "  - 查看点击统计"
  echo "  - 自定义短链接"
  echo "  - 链接还原"
}

# 还原短链接
expand_shorturl() {
  local url="$1"
  
  echo "🔗 短链接还原"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📌 短链接：$url"
  echo ""
  
  echo "💡 提示：配置 API 可查询原始链接"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  📍 原始链接：https://example.com/very/long/path..."
  echo "  📊 还原状态：成功"
  echo "  ⏰ 创建时间：2026-01-15"
  echo "  👁️  点击次数：1,234 次"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时还原短链接"
  echo "  - 查看完整跳转路径"
  echo "  - 安全检测（钓鱼链接）"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🔗 短链接生成"
    echo ""
    echo "使用方法：生成/还原短链接"
    echo "示例："
    echo "  生成短链接 https://example.com/long/url"
    echo "  短链接 https://t.cn/AbCdEf"
    echo ""
    echo "支持的功能："
    echo "  - 长链接转短链接"
    echo "  - 短链接还原"
    echo "  - 点击统计"
    return
  fi
  
  local url
  url=$(extract_url "$input")
  
  if [ -z "$url" ]; then
    echo "❌ 未找到链接"
    echo ""
    echo "示例格式："
    echo "  https://example.com"
    echo "  http://example.com/long/path"
    return
  fi
  
  # 判断是生成还是还原
  if echo "$url" | grep -qE 'sina\.lt|t\.cn|suo\.im|bit\.ly|goo\.gl|tinyurl'; then
    expand_shorturl "$url"
  else
    generate_shorturl "$url"
  fi
}

main "$@"
