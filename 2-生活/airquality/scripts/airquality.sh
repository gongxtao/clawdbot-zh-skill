#!/usr/bin/env bash
# 空气质量查询脚本

set -e

# 提取城市名
extract_city() {
  local text="$1"
  for city in 北京 上海 广州 深圳 杭州 成都 武汉 南京 西安 重庆 天津 长沙 青岛 厦门 大连 沈阳 合肥 济南 郑州 石家庄 太原 南昌 南宁 贵阳 昆明 兰州 银川 西宁 拉萨 呼和浩特; do
    if echo "$text" | grep -qi "$city"; then
      echo "$city"
      return
    fi
  done
  echo ""
}

# 检测查询内容
detect_content() {
  local text="$1"
  
  if echo "$text" | grep -qiE 'PM2\.5|pm2\.5'; then
    echo "pm25"
  elif echo "$text" | grep -qiE 'PM10|pm10'; then
    echo "pm10"
  elif echo "$text" | grep -qiE 'AQI|aqi|空气指数'; then
    echo "aqi"
  else
    echo "all"
  fi
}

# 获取 AQI 等级
get_aqi_level() {
  local aqi="$1"
  
  if [ "$aqi" -le 50 ]; then
    echo "🟢 优"
  elif [ "$aqi" -le 100 ]; then
    echo "🟡 良"
  elif [ "$aqi" -le 150 ]; then
    echo "🟠 轻度污染"
  elif [ "$aqi" -le 200 ]; then
    echo "🔴 中度污染"
  elif [ "$aqi" -le 300 ]; then
    echo "🟣 重度污染"
  else
    echo "⚫ 严重污染"
  fi
}

# 查询空气质量
query_airquality() {
  local city="$1"
  
  echo "🌬️ 空气质量查询：$city"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置空气质量 API 可获取实时数据"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📊 AQI 指数：85 $(get_aqi_level 85)"
  echo "  📍 首要污染物：PM2.5"
  echo ""
  echo "  📈 具体指标："
  echo "     - PM2.5：55 μg/m³"
  echo "     - PM10：78 μg/m³"
  echo "     - SO₂：12 μg/m³"
  echo "     - NO₂：35 μg/m³"
  echo "     - CO：0.8 mg/m³"
  echo "     - O₃：65 μg/m³"
  echo ""
  echo "  💡 健康建议："
  echo "     - 敏感人群减少户外活动"
  echo "     - 外出佩戴口罩"
  echo "     - 室内开启空气净化器"
  echo ""
  echo "📱 配置 API 后可：："
  echo "  - 实时空气质量数据"
  echo "  - 未来 24 小时预报"
  echo "  - 历史数据查询"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🌬️ 空气质量查询"
    echo ""
    echo "使用方法：查询空气质量"
    echo "示例："
    echo "  北京空气质量"
    echo "  上海 PM2.5"
    echo "  今天空气质量怎么样"
    echo ""
    echo "支持的功能："
    echo "  - AQI 指数查询"
    echo "  - PM2.5/PM10 查询"
    echo "  - 健康建议"
    return
  fi
  
  local city content_type
  
  city=$(extract_city "$input")
  content_type=$(detect_content "$input")
  
  if [ -z "$city" ]; then
    city="当前城市"
  fi
  
  query_airquality "$city"
}

main "$@"
