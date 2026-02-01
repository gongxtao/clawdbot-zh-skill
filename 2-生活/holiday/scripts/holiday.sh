#!/usr/bin/env bash
# 节日查询脚本

set -e

# 节日数据
declare -A HOLIDAYS=(
  ["春节"]="01-01"
  ["除夕"]="12-30"
  ["元宵节"]="01-15"
  ["龙抬头"]="02-02"
  ["清明节"]="04-04"
  ["端午节"]="05-05"
  ["七夕节"]="07-07"
  ["中元节"]="07-15"
  ["中秋节"]="08-15"
  ["重阳节"]="09-09"
  ["寒衣节"]="10-01"
  ["冬至"]="12-21"
)

declare -A GONGHOLIDAYS=(
  ["元旦"]="01-01"
  ["春节"]="01-22"
  ["清明节"]="04-05"
  ["劳动节"]="05-01"
  ["端午节"]="06-10"
  ["中秋节"]="10-01"
  ["国庆节"]="10-01"
)

# 提取节日名
extract_holiday() {
  local text="$1"
  for holiday in "${!HOLIDAYS[@]}"; do
    if echo "$text" | grep -qi "$holiday"; then
      echo "$holiday"
      return
    fi
  done
  for holiday in "${!GONGHOLIDAYS[@]}"; do
    if echo "$text" | grep -qi "$holiday"; then
      echo "$holiday"
      return
    fi
  done
  echo ""
}

# 提取年份
extract_year() {
  local text="$1"
  local year=$(echo "$text" | grep -oE '202[5-9]' | head -1)
  if [ -z "$year" ]; then
    year=$(date +%Y)
  fi
  echo "$year"
}

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '放假|假期|休几天'; then
    echo "holiday"
  elif echo "$text" | grep -qiE '倒计时|还有几天|还有多少天'; then
    echo "countdown"
  elif echo "$text" | grep -qiE '是什么节日|今天节日|明天节日'; then
    echo "today"
  else
    echo "query"
  fi
}

# 查询节日
query_holiday() {
  local holiday="$1" year="$2"
  
  echo "🎊 节日查询：$holiday"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📅 年份：$year"
  echo ""
  
  # 检查是农历还是公历
  local lunar_date=""
  if [ -n "${HOLIDAYS[$holiday]}" ]; then
    lunar_date="${HOLIDAYS[$holiday]}"
    echo "📆 农历日期：${lunar_date}月${lunar_date#*-}日"
    echo "📅 公历日期：需查农历转换表"
  elif [ -n "${GONGHOLIDAYS[$holiday]}" ]; then
    lunar_date="${GONGHOLIDAYS[$holiday]}"
    echo "📅 公历日期：${year}-${lunar_date}"
    echo "📆 农历日期：需查公历转换表"
  fi
  echo ""
  
  echo "💡 提示：配置节日 API 可获取精确日期和放假安排"
  echo ""
  echo "示例放假安排（模拟）："
  echo ""
  case "$holiday" in
    "春节")
      echo "  🏮 春节（${year}年1月${lunar_date#*-}日）"
      echo "  📅 放假：1月${lunar_date#*-}日 ~ 1月${lunar_date#*-}日（共7天）"
      echo "  🔄 调休：1月${lunar_date#*-}日（周日）上班"
      ;;
    "国庆节"|"中秋节")
      echo "  🇨🇳 国庆节（${year}年10月1日）"
      echo "  📅 放假：10月1日 ~ 10月7日（共7天）"
      echo "  🔄 调休：9月28日（周日）、10月12日（周六）上班"
      ;;
    "劳动节")
      echo "  🏖️ 劳动节（${year}年5月1日）"
      echo "  📅 放假：5月1日 ~ 5月5日（共5天）"
      echo "  🔄 调休：4月28日（周日）上班"
      ;;
    *)
      echo "  📅 日期：${year}年相关日期"
      echo "  📅 放假：待公布"
      ;;
  esac
  echo ""
  
  echo "📱 配置 API 后可获取："
  echo "  - 精确放假安排"
  echo "  - 调休上班日"
  echo "  - 节日倒计时"
}

# 倒计时查询
query_countdown() {
  local holiday="$1"
  
  echo "⏰ 节日倒计时：$holiday"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取精确倒计时"
  echo ""
  echo "示例倒计时（模拟）："
  echo ""
  echo "  🏮 $holiday"
  echo "  ⏰ 距离节日：还有 15 天"
  echo "  📅 预计日期：${year}-XX-XX"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 精确到天数的倒计时"
  echo "  - 每日提醒"
  echo "  - 节日习俗介绍"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🎊 节日查询"
    echo ""
    echo "使用方法：查询节日信息"
    echo "示例："
    echo "  2026年春节是哪天"
    echo "  明天是什么节日"
    echo "  国庆节放几天假"
    echo "  距离元旦还有几天"
    echo ""
    echo "支持的节日："
    echo "  春节、元宵、清明、端午、七夕、中秋、重阳"
    echo "  元旦、劳动节、国庆节"
    return
  fi
  
  local holiday year query_type
  
  holiday=$(extract_holiday "$input")
  year=$(extract_year "$input")
  query_type=$(detect_type "$input")
  
  if [ -z "$holiday" ]; then
    echo "❌ 未识别到节日"
    echo ""
    echo "支持的节日："
    echo "  春节、元宵、清明、端午、七夕、中秋、重阳"
    echo "  元旦、劳动节、国庆节"
    return
  fi
  
  case "$query_type" in
    "holiday"|"query")
      query_holiday "$holiday" "$year"
      ;;
    "countdown")
      query_countdown "$holiday"
      ;;
    "today")
      echo "📅 今日/明日节日"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 可查询具体日期"
      echo ""
      echo "示例："
      echo "  2026年主要节日："
      echo "  - 春节：1月22日（正月初一）"
      echo "  - 清明：4月5日"
      echo "  - 劳动节：5月1日"
      echo "  - 国庆：10月1日"
      ;;
  esac
}

main "$@"
