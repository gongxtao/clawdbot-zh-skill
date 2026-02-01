#!/usr/bin/env bash
# 密码生成脚本

set -e

# 提取密码长度
extract_length() {
  local text="$1"
  local length=$(echo "$text" | grep -oE '[0-9]+' | head -1)
  
  if [ -z "$length" ] || [ "$length" -lt 6 ]; then
    echo "12"
  elif [ "$length" -gt 64 ]; then
    echo "64"
  else
    echo "$length"
  fi
}

# 检测密码类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "纯数字|数字|number"; then
    echo "number"
  elif echo "$text" | grep -qiE "字母|letter"; then
    echo "letter"
  elif echo "$text" | grep -qiE "强|complex|strong"; then
    echo "strong"
  elif echo "$text" | grep -qiE "弱|simple|easy"; then
    echo "simple"
  else
    echo "normal"
  fi
}

# 生成随机密码
generate_password() {
  local length="$1" type="$2"
  
  local chars=""
  local result=""
  
  case "$type" in
    "number")
      chars="0123456789"
      result=$(head -c /dev/urandom | tr -dc "$chars" | head -c "$length")
      ;;
    "letter")
      chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
      result=$(head -c /dev/urandom | tr -dc "$chars" | head -c "$length")
      ;;
    "strong")
      chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
      result=$(head -c /dev/urandom | tr -dc "$chars" | head -c "$length")
      ;;
    "simple")
      chars="abcdefghijklmnopqrstuvwxyz0123456789"
      result=$(head -c /dev/urandom | tr -dc "$chars" | head -c "$length")
      ;;
    "normal"|*)
      chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      result=$(head -c /dev/urandom | tr -dc "$chars" | head -c "$length")
      ;;
  esac
  
  echo "$result"
}

# 评估密码强度
assess_strength() {
  local password="$1"
  local score=0
  
  # 长度检查
  if [ ${#password} -ge 8 ]; then
    score=$((score + 1))
  fi
  if [ ${#password} -ge 12 ]; then
    score=$((score + 1))
  fi
  if [ ${#password} -ge 16 ]; then
    score=$((score + 1))
  fi
  
  # 复杂度检查
  if echo "$password" | grep -qE '[A-Z]'; then
    score=$((score + 1))
  fi
  if echo "$password" | grep -qE '[a-z]'; then
    score=$((score + 1))
  fi
  if echo "$password" | grep -qE '[0-9]'; then
    score=$((score + 1))
  fi
  if echo "$password" | grep -qE '[!@#$%^&*]'; then
    score=$((score + 1))
  fi
  
  # 返回强度等级
  if [ $score -ge 6 ]; then
    echo "🟢 强"
  elif [ $score -ge 4 ]; then
    echo "🟡 中等"
  elif [ $score -ge 2 ]; then
    echo "🟠 弱"
  else
    echo "🔴 极弱"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    input="生成12位密码"
  fi
  
  local length type password strength
  
  length=$(extract_length "$input")
  type=$(detect_type "$input")
  password=$(generate_password "$length" "$type")
  strength=$(assess_strength "$password")
  
  echo "🔐 密码生成"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📏 长度：$length 位"
  echo "🔒 类型：$type"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "🔑 生成密码："
  echo ""
  echo "  $password"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📊 强度评估：$strength"
  echo ""
  echo "💡 安全建议："
  echo "  - 不要在不同网站使用相同密码"
  echo "  - 定期更换密码"
  echo "  - 使用密码管理器存储"
  echo "  - 开启双因素认证"
}

main "$@"
