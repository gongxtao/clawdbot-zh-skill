#!/usr/bin/env bash
# 天气预警脚本

set -e

# 提取城市
extract_city() {
  local text="$1"
  for city in 北京 上海 广州 深圳 杭州 成都 武汉 南京 西安 重庆 天津 厦门 福州 宁波 青岛 大连; do
    if echo "$text" | grep -qi "$city"; then
      echo "$city"
      return
    fi
  done
  echo ""
}

# 检测预警类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '台风|飓风'; then
    echo "typhoon"
  elif echo "$text" | grep -qiE '暴雨|大暴雨|特大暴雨'; then
    echo "rain"
  elif echo "$text" | grep -qiE '暴雪|大雪|特大雪'; then
    echo "snow"
  elif echo "$text" | grep -qiE '高温|中暑|热'; then
    echo "heat"
  elif echo "$text" | grep -qiE '寒潮|降温|冷'; then
    echo "cold"
  elif echo "$text" | grep -qiE '雷电|雷暴'; then
    echo "thunder"
  else
    echo "all"
  fi
}

# 预警等级图标
get_level_icon() {
  local level="$1"
  case "$level" in
    "蓝色") echo "🔵" ;;
    "黄色") echo "🟡" ;;
    "橙色") echo "🟠" ;;
    "红色") echo "🔴" ;;
    *) echo "⚪" ;;
  esac
}

# 查询天气预警
query_weather_alert() {
  local city="$1" alert_type="$2"
  
  echo "⚠️ 天气预警：$city"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置气象局 API 可获取实时预警"
  echo ""
  echo "当前预警（模拟）："
  echo ""
  echo "  ⚠️  无生效预警"
  echo ""
  echo "  📍 当前天气：晴转多云，25°C"
  echo "  🌬️ 风力：3-4 级"
  echo ""
  
  echo "📱 配置 API 后可："
  echo "  - 实时天气预警"
  echo "  - 预警推送"
  echo "  - 台风路径追踪"
  echo "  - 极端天气提醒"
}

# 台风预警
query_typhoon_alert() {
  echo "🌀 台风预警"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置气象局 API 可获取台风路径"
  echo ""
  echo "当前台风（模拟）："
  echo ""
  echo "  🌀 台风：玛瑙（2026-01）"
  echo "     - 等级：强台风（14 级）"
  echo "     - 位置：菲律宾以东洋面"
  echo "     - 移动方向：西北偏西"
  echo "     - 预计登陆：无（海上转向）"
  echo ""
  echo "  🌀 历史台风："
  echo "     - 2025年：生成 25 个，登陆 8 个"
  echo "     - 2024年：生成 28 个，登陆 10 个"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时台风路径"
  echo "  - 登陆地点预测"
  echo "  - 影响范围分析"
  echo "  - 防御指南"
}

# 暴雨预警
query_rain_alert() {
  echo "🌧️ 暴雨预警"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置气象局 API 可获取暴雨预警"
  echo ""
  echo "暴雨预警等级："
  echo ""
  echo "  🔵 蓝色：12小时雨量达 50mm"
  echo "  🟡 黄色：6小时雨量达 50mm"
  echo "  🟠 橙色：3小时雨量达 50mm"
  echo "  🔴 红色：3小时雨量达 100mm"
  echo ""
  echo "💡 防御指南："
  echo "  - 减少外出"
  echo "  - 远离低洼地区"
  echo "  - 防范山洪"
  echo "  - 关注交通管制"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    input="天气预警"
  fi
  
  local city alert_type
  
  city=$(extract_city "$input")
  alert_type=$(detect_type "$input")
  
  if [ -z "$city" ]; then
    city="全国"
  fi
  
  echo "🔍 正在查询天气预警..."
  echo ""
  
  case "$alert_type" in
    "typhoon")
      query_typhoon_alert
      ;;
    "rain"|"snow"|"heat"|"cold"|"thunder")
      query_rain_alert
      ;;
    *)
      query_weather_alert "$city" "$alert_type"
      ;;
  esac
}

main "$@"
