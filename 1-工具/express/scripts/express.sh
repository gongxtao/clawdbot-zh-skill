#!/usr/bin/env bash
# 快递查询脚本

set -e

# 快递100免费API
KUAIDIA100_API="https://poll.kuaidi100.com/api/query"

# 快递公司代码映射
declare -A EXPRESS_CODES=(
  ["顺丰"]="sf"
  ["申通"]="sto"
  ["圆通"]="yto"
  ["中通"]="zto"
  ["韵达"]="yd"
  ["京东"]="jd"
  ["德邦"]="db"
  ["邮政"]="yz"
  ["天天"]="tt"
  ["极兔"]="jt"
)

# 提取快递单号
extract_tracking_number() {
  local text="$1"
  # 匹配12-20位数字或以SF/STO/YTO等开头的单号
  echo "$text" | grep -oE '[A-Za-z]{2,4}[0-9]{10,}' | head -1
}

# 提取快递公司
extract_express_company() {
  local text="$1"
  for company in "${!EXPRESS_CODES[@]}"; do
    if echo "$text" | grep -qi "$company"; then
      echo "${EXPRESS_CODES[$company]}"
      return
    fi
  done
  # 默认返回空，让API自动识别
  echo ""
}

# 查询快递
query_express() {
  local tracking_num="$1"
  local company_code="$2"
  
  # 调用快递100 API
  local url="${KUAIDIA100_API}?postid=${tracking_num}&com=${company_code}&resultv2=1"
  
  local response
  response=$(curl -s -m 10 "$url" 2>/dev/null)
  
  if [ -z "$response" ]; then
    echo "❌ 查询失败，请稍后重试"
    return 1
  fi
  
  # 解析结果
  local status message
  status=$(echo "$response" | grep -oE '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
  message=$(echo "$response" | grep -oE '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
  
  # 判断状态
  if [ "$status" = "200" ] || [ "$message" = "ok" ]; then
    # 提取最新物流信息
    local last_trace
    last_trace=$(echo "$response" | grep -oE '"time":"[^"]*","context":"[^"]*"' | tail -1)
    
    if [ -n "$last_trace" ]; then
      local time context
      time=$(echo "$last_trace" | grep -oE '"time":"[^"]*"' | cut -d'"' -f4)
      context=$(echo "$last_trace" | grep -oE '"context":"[^"]*"' | cut -d'"' -f4)
      echo "📦 最新物流："
      echo "⏰ $time"
      echo "📍 $context"
    else
      echo "📭 暂无物流信息，可能还在揽收中"
    fi
  else
    echo "❌ 查询失败：$message"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "📦 快递查询"
    echo ""
    echo "使用方法：查询快递单号 <单号>"
    echo "示例：查询快递单号 SF1234567890"
    return
  fi
  
  local tracking_num company_code
  tracking_num=$(extract_tracking_number "$input")
  company_code=$(extract_express_company "$input")
  
  if [ -z "$tracking_num" ]; then
    echo "❌ 未找到快递单号，请检查输入"
    echo ""
    echo "支持的格式："
    echo "  - SF1234567890"
    echo "  - 申运单号 8888888888"
    echo "  - 查询快递 1234567890"
    return
  fi
  
  echo "🔍 正在查询快递：$tracking_num"
  echo ""
  query_express "$tracking_num" "$company_code"
}

main "$@"
