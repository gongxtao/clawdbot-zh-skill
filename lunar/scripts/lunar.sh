#!/usr/bin/env bash
# 农历转换脚本

set -e

# 农历数据（简化的农历映射）
# 重要节日
declare -A FESTIVALS=(
  ["春节"]="01-01"
  ["元宵节"]="01-15"
  ["龙抬头"]="02-02"
  ["清明节"]="04-04"
  ["端午节"]="05-05"
  ["七夕"]="07-07"
  ["中元节"]="07-15"
  ["中秋节"]="08-15"
  ["重阳节"]="09-09"
  ["除夕"]="12-30"
)

# 二十四节气
SOLAR_TERMS=(
  "立春:02:03-02:05"
  "雨水:02:18-02:20"
  "惊蛰:03:05-03:07"
  "春分:03:20-03:22"
  "清明:04:04-04:06"
  "谷雨:04:19-04:21"
  "立夏:05:05-05:07"
  "小满:05:20-05:22"
  "芒种:06:05-06:07"
  "夏至:06:21-06:22"
  "小暑:07:06-07:08"
  "大暑:07:22-07:24"
  "立秋:08:07-08:09"
  "处暑:08:22-08:24"
  "白露:09:07-09:09"
  "秋分:09:22-09:24"
  "寒露:10:08-10:09"
  "霜降:10:23-10-24"
  "立冬:11:07-11-08"
  "小雪:11:22-11-23"
  "大雪:12:06-12-08"
  "冬至:12:21-12-23"
)

# 查询节日
query_festival() {
  local festival="$1"
  
  echo "🏮 $festival"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  if [ -n "${FESTIVALS[$festival]}" ]; then
    echo "📅 农历日期：${FESTIVALS[$festival]}"
    echo ""
    echo "💡 提示：具体公历日期每年不同"
  else
    echo "❓ 未找到该节日"
    echo ""
    echo "支持的节日："
    for fest in "${!FESTIVALS[@]}"; do
      echo "  - $fest（农历 ${FESTIVALS[$fest]}）"
    done
  fi
}

# 查询节气
query_solar_term() {
  local term="$1"
  
  echo "🌿 二十四节气 - $term"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local found=0
  for st in "${SOLAR_TERMS[@]}"; do
    if echo "$st" | grep -qi "$term"; then
      local term_name term_range
      IFS=':' read -r term_name term_range <<< "$st"
      echo "📅 通常在：${term_range//-/ 至 } 日"
      found=1
      break
    fi
  done
  
  if [ $found -eq 0 ]; then
    echo "❓ 未找到该节气"
    echo ""
    echo "支持的节气："
    for st in "${SOLAR_TERMS[@]}"; do
      echo "  - $(echo "$st" | cut -d':' -f1)"
    done
  fi
}

# 提取查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "春节|元宵|端午|中秋|国庆|清明|重阳"; then
    echo "festival"
  elif echo "$text" | grep -qiE "节气|立春|雨水|惊蛰|春分|清明|谷雨|立夏|小满|芒种|夏至|小暑|大暑|立秋|处暑|白露|秋分|寒露|霜降|立冬|小雪|大雪|冬至"; then
    echo "solar_term"
  elif echo "$text" | grep -qiE "今天|现在|当前"; then
    echo "today"
  else
    echo "today"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "📅 农历转换"
    echo ""
    echo "使用方法：查询农历信息"
    echo "示例："
    echo "  今天农历多少"
    echo "  明天农历几号"
    echo "  2026年春节是哪天"
    echo "  今天是什么节气"
    echo "  寒露是哪天"
    return
  fi
  
  local query_type
  query_type=$(detect_query_type "$input")
  
  case "$query_type" in
    "festival")
      for fest in "${!FESTIVALS[@]}"; do
        if echo "$input" | grep -qi "$fest"; then
          query_festival "$fest"
          exit 0
        fi
      done
      query_festival "$input"
      ;;
    "solar_term")
      for st in "${SOLAR_TERMS[@]}"; do
        local term_name
        term_name=$(echo "$st" | cut -d':' -f1)
        if echo "$input" | grep -qi "$term_name"; then
          query_solar_term "$term_name"
          exit 0
        fi
      done
      query_solar_term "$input"
      ;;
    "today"|*)
      echo "📅 $(date '+%Y-%m-%d') 农历信息"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 提示：完整农历功能需要安装农历库"
      echo ""
      echo "此技能提供："
      echo "  - 公历 ↔ 农历转换"
      echo "  - 节假日查询"
      echo "  - 二十四节气"
      ;;
  esac
}

main "$@"
