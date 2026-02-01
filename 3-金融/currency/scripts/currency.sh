#!/usr/bin/env bash
# 汇率查询脚本

set -e

# 货币代码映射
declare -A CURRENCY_CODES=(
  ["美元"]="USD"
  ["美金"]="USD"
  ["刀"]="USD"
  ["人民币"]="CNY"
  ["元"]="CNY"
  ["块"]="CNY"
  ["欧元"]="EUR"
  ["欧罗"]="EUR"
  ["英镑"]="GBP"
  ["磅"]="GBP"
  ["日元"]="JPY"
  ["日圆"]="JPY"
  ["港币"]="HKD"
  ["港元"]="HKD"
  ["澳元"]="AUD"
  ["澳币"]="AUD"
  ["加元"]="CAD"
  ["加拿大"]="CAD"
  ["瑞郎"]="CHF"
  ["瑞士法郎"]="CHF"
  ["韩元"]="KRW"
  ["韩币"]="KRW"
  ["新加坡元"]="SGD"
  ["新加坡币"]="SGD"
)

# 常用汇率（模拟数据，实际需要 API）
# 更新时间：2026-02-01
declare -A EXCHANGE_RATES=(
  ["USD_CNY"]="7.24"
  ["EUR_CNY"]="7.82"
  ["GBP_CNY"]="9.12"
  ["JPY_CNY"]="0.048"
  ["HKD_CNY"]="0.93"
  ["AUD_CNY"]="4.56"
  ["CAD_CNY"]="5.02"
  ["CHF_CNY"]="8.12"
  ["KRW_CNY"]="0.0048"
  ["SGD_CNY"]="5.42"
  ["USD_EUR"]="0.92"
  ["USD_GBP"]="0.79"
  ["USD_JPY"]="150.5"
  ["EUR_GBP"]="0.86"
)

# 提取货币对
extract_currency_pair() {
  local text="$1"
  local from="" to=""
  
  # 检测"X换Y"或"X对Y"格式
  if echo "$text" | grep -qiE "换|对|等于|成"; then
    # 提取第一个货币
    for curr in "${!CURRENCY_CODES[@]}"; do
      if echo "$text" | grep -qiE "$curr"; then
        from="${CURRENCY_CODES[$curr]}"
        break
      fi
    done
    
    # 移除已识别的货币，再次检测
    local remaining_text="$text"
    for curr in "${!CURRENCY_CODES[@]}"; do
      remaining_text=$(echo "$remaining_text" | sed "s/$curr//gI")
    done
    
    # 检测第二个货币
    for curr in "${!CURRENCY_CODES[@]}"; do
      if echo "$remaining_text" | grep -qiE "$curr"; then
        to="${CURRENCY_CODES[$curr]}"
        break
      fi
    done
  fi
  
  echo "$from|$to"
}

# 提取金额
extract_amount() {
  local text="$1"
  echo "$text" | grep -oE '[0-9.]+' | head -1
}

# 获取汇率
get_rate() {
  local from="$1" to="$2"
  local key="${from}_${to}"
  
  if [ -n "${EXCHANGE_RATES[$key]}" ]; then
    echo "${EXCHANGE_RATES[$key]}"
  else
    # 尝试反向汇率
    local reverse_key="${to}_${from}"
    if [ -n "${EXCHANGE_RATES[$reverse_key]}" ]; then
      local rate
      rate=$(echo "scale=6; 1 / ${EXCHANGE_RATES[$reverse_key]}" | bc)
      echo "$rate"
    else
      echo ""
    fi
  fi
}

# 汇率查询
query_exchange_rate() {
  local from="$1" to="$2"
  
  echo "💱 汇率查询：$from → $to"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local rate
  rate=$(get_rate "$from" "$to")
  
  if [ -n "$rate" ]; then
    echo "📊 当前汇率：1 $from = $rate $to"
    echo ""
    echo "📈 参考银行汇率（模拟）："
    echo "  买入价：$(echo "scale=4; $rate * 0.998" | bc) $to"
    echo "  卖出价：$(echo "scale=4; $rate * 1.002" | bc) $to"
    echo "  中间价：$rate $to"
    echo ""
    echo "💡 实际汇率以银行/平台为准"
  else
    echo "❌ 暂不支持 $from → $to 的汇率查询"
    echo ""
    echo "支持的货币："
    for curr in 美元 人民币 欧元 英镑 日元 港币 澳元 加元 瑞郎; do
      echo "  - $curr"
    done
  fi
}

# 货币换算
convert_currency() {
  local amount="$1" from="$2" to="$3"
  
  echo "💱 货币换算"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💰 金额：$amount $from"
  echo "目标：$to"
  echo ""
  
  local rate
  rate=$(get_rate "$from" "$to")
  
  if [ -n "$rate" ]; then
    local result
    result=$(echo "scale=2; $amount * $rate" | bc)
    echo "🟢 换算结果：$result $to"
    echo ""
    echo "📊 计算方式：$amount × $rate = $result"
  else
    echo "❌ 暂不支持该货币对"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "💱 汇率查询"
    echo ""
    echo "使用方法：查询汇率或换算"
    echo "示例："
    echo "  1美元等于多少人民币"
    echo "  欧元汇率"
    echo "  100日元换人民币"
    echo "  英镑对人民币汇率"
    echo ""
    echo "支持的货币："
    echo "  美元(USD)、人民币(CNY)、欧元(EUR)"
    echo "  英镑(GBP)、日元(JPY)、港币(HKD)"
    echo "  澳元(AUD)、加元(CAD)、瑞郎(CHF)"
    return
  fi
  
  local amount from to currency_pair
  
  amount=$(extract_amount "$input")
  currency_pair=$(extract_currency_pair "$input")
  from=$(echo "$currency_pair" | cut -d'|' -f1)
  to=$(echo "$currency_pair" | cut -d'|' -f2)
  
  # 判断是纯汇率查询还是换算
  if [ -n "$amount" ] && [ -n "$from" ] && [ -n "$to" ]; then
    # 有金额，换算
    convert_currency "$amount" "$from" "$to"
  elif [ -n "$from" ] && [ -n "$to" ]; then
    # 无金额，纯汇率
    query_exchange_rate "$from" "$to"
  elif [ -n "$from" ]; then
    # 单货币，查对人民币汇率
    query_exchange_rate "$from" "CNY"
  else
    echo "❌ 未识别货币"
    echo ""
    echo "示例："
    echo "  1美元等于多少人民币"
    echo "  欧元汇率"
    echo "  100日元换人民币"
  fi
}

main "$@"
