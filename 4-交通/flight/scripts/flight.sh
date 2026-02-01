#!/usr/bin/env bash
# 机票查询脚本

set -e

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '航班|CA[0-9]|CZ[0-9]|MU[0-9]'; then
    echo "flight"
  elif echo "$text" | grep -qiE '到|飞|从'; then
    echo "route"
  else
    echo "search"
  fi
}

# 提取城市
extract_cities() {
  local text="$1"
  local from="" to=""
  
  for city in 北京 上海 广州 深圳 杭州 成都 武汉 南京 西安 重庆 天津 长沙 青岛 厦门 大连 沈阳 合肥 济南 郑州 昆明 三亚 海口; do
    if echo "$text" | grep -qi "$city"; then
      if [ -z "$from" ]; then
        from="$city"
      else
        to="$city"
      fi
    fi
  done
  
  echo "$from|$to"
}

# 提取日期
extract_date() {
  local text="$1"
  if echo "$text" | grep -qiE '明天|后天|今天|今日'; then
    local offset=0
    if echo "$text" | grep -qi "明天"; then offset=1; fi
    if echo "$text" | grep -qi "后天"; then offset=2; fi
    date -d "+$offset day" +%Y-%m-%d
  else
    date +%Y-%m-%d
  fi
}

# 查询航班
query_flight() {
  local flight_no="$1"
  
  echo "✈️ 航班查询：$flight_no"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置机票 API 可获取实时信息"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  $flight_no 次航班"
  echo "  机型：空客 A320"
  echo ""
  echo "  🛫 起飞：首都机场 T3 - 08:00"
  echo "  🛬 到达：浦东机场 T2 - 10:30"
  echo "  ⏱️  飞行时长：2小时30分钟"
  echo ""
  echo "  💰 票价："
  echo "     - 经济舱：¥580 起"
  echo "     - 商务舱：¥1,280 起"
  echo "     - 头等舱：¥2,580 起"
  echo ""
  echo "  📊 准点率：85%"
  echo "  📍 当前状态：准点"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时航班状态"
  echo "  - 票价对比"
  echo "  - 延误预警"
  echo "  - 在线值机"
}

# 按线路查询
query_route() {
  local from="$1" to="$2" date="$3"
  
  echo "✈️ 机票查询：$from → $to"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📅 日期：$date"
  echo ""
  
  echo "💡 提示：配置机票 API 可获取实时票价"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  🛫 直飞航班（共 8 个）："
  echo ""
  printf "  %-8s %-12s %-10s %-10s %s\n" "航班" "时间" "机场" "价格" "状态"
  printf "  %-8s %-12s %-10s %-10s %s\n" "━━━━" "━━━━━━━━" "━━━━━━", "━━━━━━━━", "━━━━"
  printf "  %-8s %-12s %-10s %-10s %s\n" "CA1234" "08:00-10:30" "首都-浦东" "¥580" "🟢 有票"
  printf "  %-8s %-12s %-10s %-10s %s\n" "MU5678" "10:30-13:00" "首都-浦东" "¥520" "🟢 有票"
  printf "  %-8s %-12s %-10s %-10s %s\n" "CZ9012" "14:00-16:30" "首都-浦东" "¥480" "🟡 紧张"
  printf "  %-8s %-12s %-10s %-10s %s\n" "HU3456" "16:00-18:30" "首都-浦东" "¥650" "🔴 售罄"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时票价"
  echo "  - 航班动态"
  echo "  - 机场指南"
  echo "  - 在线预订"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "✈️ 机票查询"
    echo ""
    echo "使用方法：查询机票信息"
    echo "示例："
    echo "  北京到上海的机票"
    echo "  明天北京飞广州"
    echo "  查询航班 CA1234"
    echo ""
    echo "支持的功能："
    echo "  - 航班查询"
    echo "  - 票价查询"
    echo "  - 航班状态"
    return
  fi
  
  local query_type cities date from to flight_no
  
  query_type=$(detect_type "$input")
  date=$(extract_date "$input")
  
  if echo "$input" | grep -qiE '航班|CA[0-9]|CZ[0-9]|MU[0-9]'; then
    flight_no=$(echo "$input" | grep -oE 'CA[0-9]+|CZ[0-9]+|MU[0-9]+|HU[0-9]+' | head -1)
  fi
  
  if [ -z "$flight_no" ]; then
    cities=$(extract_cities "$input")
    from=$(echo "$cities" | cut -d'|' -f1)
    to=$(echo "$cities" | cut -d'|' -f2)
  fi
  
  echo "🔍 正在查询..."
  echo ""
  
  if [ -n "$flight_no" ]; then
    query_flight "$flight_no"
  elif [ -n "$from" ] && [ -n "$to" ]; then
    query_route "$from" "$to" "$date"
  else
    echo "❌ 未识别到查询信息"
    echo ""
    echo "示例："
    echo "  北京到上海的机票"
    echo "  明天北京飞广州"
    echo "  查询航班 CA1234"
  fi
}

main "$@"
