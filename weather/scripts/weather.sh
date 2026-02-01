#!/usr/bin/env bash
# 天气查询脚本

set -e

# 和风天气 API
WEATHER_API="https://devapi.qweather.com/v7/weather/3d"

# 读取 API Key
load_api_key() {
  local key_file="$HOME/.config/weather/api_key"
  if [ -f "$key_file" ]; then
    cat "$key_file"
  else
    echo ""
  fi
}

# 城市到城市 ID 映射（常用城市）
declare -A CITY_CODES=(
  ["北京"]="101010100"
  ["上海"]="101020100"
  ["广州"]="101280101"
  ["深圳"]="101280601"
  ["杭州"]="101210101"
  ["成都"]="101270101"
  ["武汉"]="101200101"
  ["南京"]="101190101"
  ["西安"]="101110101"
  ["重庆"]="101040100"
  ["苏州"]="101190401"
  ["天津"]="101030100"
  ["郑州"]="101180101"
  ["长沙"]="101250101"
  ["青岛"]="101120201"
  ["厦门"]="101230201"
  ["大连"]="101070201"
  ["沈阳"]="101070101"
  ["合肥"]="101220101"
  ["济南"]="101120101"
)

# 提取城市名
extract_city() {
  local text="$1"
  for city in "${!CITY_CODES[@]}"; do
    if echo "$text" | grep -qi "$city"; then
      echo "$city"
      return
    fi
  done
  # 默认返回空
  echo ""
}

# 解析时间（今天/明天/后天）
extract_day() {
  local text="$1"
  if echo "$text" | grep -qi "明天"; then
    echo "1"
  elif echo "$text" | grep -qi "后天"; then
    echo "2"
  elif echo "$text" | grep -qi "未来"; then
    echo "all"
  elif echo "$text" | grep -qi "周"; then
    echo "all"
  else
    echo "0"  # 今天
  fi
}

# 查询天气
query_weather() {
  local city_code="$1" day_index="$2"
  local api_key
  api_key=$(load_api_key)
  
  if [ -z "$api_key" ]; then
    echo "⚠️  天气 API 未配置"
    echo ""
    echo "请设置 API Key："
    echo "  mkdir -p ~/.config/weather"
    echo "  echo 'YOUR_API_KEY' > ~/.config/weather/api_key"
    echo ""
    echo "注册地址：https://console.qweather.com"
    return 1
  fi
  
  local url="${WEATHER_API}?location=${city_code}&key=${api_key}"
  local response
  response=$(curl -s -m 10 "$url" 2>/dev/null)
  
  if [ -z "$response" ]; then
    echo "❌ 查询失败，请稍后重试"
    return 1
  fi
  
  # 检查错误
  local code
  code=$(echo "$response" | grep -oE '"code":"[^"]*"' | head -1 | cut -d'"' -f4)
  if [ "$code" != "200" ]; then
    echo "❌ 查询失败，错误码：$code"
    return 1
  fi
  
  # 解析天气数据
  local day_count
  day_count=$(echo "$response" | grep -oE '"daily":\[[^\]]*\]' | grep -oE '"fxDate"' | wc -l)
  
  if [ "$day_index" = "all" ]; then
    # 显示全部 3 天
    echo "$response" | grep -oE '"fxDate":"[^"]*","tempMin":[0-9]+,"tempMax":[0-9]+,"textDay":"[^"]*","windDirDay":"[^"]*","windLevel":"[^"]*"' | while read -r day; do
      local date temp_min temp_max text wind_dir wind_level
      date=$(echo "$day" | grep -oE '"fxDate":"[^"]*"' | cut -d'"' -f4)
      temp_min=$(echo "$day" | grep -oE '"tempMin":[0-9]+' | cut -d':' -f2)
      temp_max=$(echo "$day" | grep -oE '"tempMax":[0-9]+' | cut -d':' -f2)
      text=$(echo "$day" | grep -oE '"textDay":"[^"]*"' | cut -d'"' -f4)
      wind_dir=$(echo "$day" | grep -oE '"windDirDay":"[^"]*"' | cut -d'"' -f4)
      wind_level=$(echo "$day" | grep -oE '"windLevel":"[^"]*"' | cut -d'"' -f4)
      
      # 格式化日期
      local display_date
      if [ "$date" = "$(date +%Y-%m-%d)" ]; then
        display_date="今天"
      elif [ "$date" = "$(date -d '+1 day' +%Y-%m-%d)" ]; then
        display_date="明天"
      elif [ "$date" = "$(date -d '+2 day' +%Y-%m-%d)" ]; then
        display_date="后天"
      else
        display_date="$date"
      fi
      
      echo "📅 $display_date | 🌡️ ${temp_min}°C ~ ${temp_max}°C | ☀️ $text | 💨 $wind_dir$wind_level"
    done
  else
    # 显示指定天
    local day_data
    day_data=$(echo "$response" | grep -oE '"fxDate":"[^"]*","tempMin":[0-9]+,"tempMax":[0-9]+,"textDay":"[^"]*","windDirDay":"[^"]*","windLevel":"[^"]*"' | sed -n "$((day_index + 1))p")
    
    if [ -z "$day_data" ]; then
      echo "❌ 未找到该日期的天气"
      return 1
    fi
    
    local date temp_min temp_max text wind_dir wind_level
    date=$(echo "$day_data" | grep -oE '"fxDate":"[^"]*"' | cut -d'"' -f4)
    temp_min=$(echo "$day_data" | grep -oE '"tempMin":[0-9]+' | cut -d':' -f2)
    temp_max=$(echo "$day_data" | grep -oE '"tempMax":[0-9]+' | cut -d':' -f2)
    text=$(echo "$day_data" | grep -oE '"textDay":"[^"]*"' | cut -d'"' -f4)
    wind_dir=$(echo "$day_data" | grep -oE '"windDirDay":"[^"]*"' | cut -d'"' -f4)
    wind_level=$(echo "$day_data" | grep -oE '"windLevel":"[^"]*"' | cut -d'"' -f4)
    
    echo "🌤️  $text"
    echo "🌡️  温度：${temp_min}°C ~ ${temp_max}°C"
    echo "💨  风力：$wind_dir$wind_level"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🌤️  天气查询"
    echo ""
    echo "使用方法：<城市名>天气"
    echo "示例：北京天气、杭州明天天气、上海后天天气"
    echo ""
    echo "支持的查询："
    echo "  - 北京今天天气"
    echo "  - 上海明天天气"
    echo "  - 广州未来一周天气"
    return
  fi
  
  local city day_index
  city=$(extract_city "$input")
  day_index=$(extract_day "$input")
  
  if [ -z "$city" ]; then
    echo "❌ 未识别到城市，请输入城市名称"
    echo ""
    echo "支持的格式："
    echo "  - 北京天气"
    echo "  - 上海明天天气"
    echo "  - 杭州后天天气"
    return
  fi
  
  local city_code="${CITY_CODES[$city]}"
  if [ -z "$city_code" ]; then
    echo "❌ 暂不支持查询 $city"
    return
  fi
  
  echo "🔍 正在查询 $city 天气..."
  echo ""
  query_weather "$city_code" "$day_index"
}

main "$@"
