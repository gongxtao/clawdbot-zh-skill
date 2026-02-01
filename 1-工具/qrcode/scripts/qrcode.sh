#!/usr/bin/env bash
# 二维码生成脚本

set -e

# 提取文本内容
extract_content() {
  local text="$1"
  # 移除"生成"、"二维码"等前缀
  echo "$text" | sed -E 's/^生成(的)?二维码(是)?//' | sed 's/是//' | xargs
}

# 检测内容类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE 'http|https|www\.'; then
    echo "url"
  elif echo "$text" | grep -qiE '微信|wechat'; then
    echo "wechat"
  elif echo "$text" | grep -qiE '支付宝|alipay'; then
    echo "alipay"
  elif echo "$text" | grep -qiE '名片|姓名|电话|手机|邮箱|email'; then
    echo "contact"
  else
    echo "text"
  fi
}

# 生成二维码
generate_qrcode() {
  local content="$1" type="$2"
  
  echo "▢ 二维码生成"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📝 内容：$content"
  echo "📐 类型：$type"
  echo ""
  
  echo "💡 提示：配置 QRCode API 可生成真实二维码"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  ┌─────────────────────────────────┐"
  echo "  │ ████████  ████████  ████      │"
  echo "  │ ██    ██  ██    ██  ██  ██    │"
  echo "  │ ████████  ████████  ██  ██    │"
  echo "  │ ██    ██  ██    ██  ██  ██    │"
  echo "  │ ████████  ████████  ████████  │"
  echo "  └─────────────────────────────────┘"
  echo ""
  echo "  📥 下载链接：https://qrcode.api.com/xxx.png"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 生成实时二维码图片"
  echo "  - 自定义颜色和大小"
  echo "  - 保存到本地"
  echo "  - 直接显示二维码"
}

# 生成名片二维码
generate_contact_qr() {
  local content="$1"
  
  echo "▢ 名片二维码生成"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📝 联系人信息：$content"
  echo ""
  
  echo "💡 提示：配置 API 可生成 vCard 名片二维码"
  echo ""
  echo "示例 vCard 格式："
  echo ""
  echo "  BEGIN:VCARD"
  echo "  VERSION:3.0"
  echo "  FN:张三"
  echo "  TEL:13800138000"
  echo "  EMAIL:zhangsan@example.com"
  echo "  END:VCARD"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 生成标准 vCard 二维码"
  echo "  - 扫描后直接保存联系人"
  echo "  - 支持多平台（微信/手机）"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "▢ 二维码生成"
    echo ""
    echo "使用方法：生成二维码"
    echo "示例："
    echo "  生成二维码 https://example.com"
    echo "  二维码 hello world"
    echo "  生成名片二维码 张三 13800138000"
    echo ""
    echo "支持的类型："
    echo "  - 网址链接"
    echo "  - 纯文本"
    echo "  - 名片信息"
    echo "  - 微信/支付宝"
    return
  fi
  
  local content type
  
  content=$(extract_content "$input")
  type=$(detect_type "$content")
  
  if [ -z "$content" ]; then
    echo "❌ 未找到二维码内容"
    echo ""
    echo "示例："
    echo "  生成二维码 https://example.com"
    echo "  二维码 hello world"
    return
  fi
  
  case "$type" in
    "url"|"text"|"wechat"|"alipay")
      generate_qrcode "$content" "$type"
      ;;
    "contact")
      generate_contact_qr "$content"
      ;;
  esac
}

main "$@"
