#!/usr/bin/env bash
# 单位换算脚本

set -e

# 提取数字
extract_number() {
  echo "$1" | grep -oE '[0-9.]+' | head -1
}

# 提取源单位
extract_from_unit() {
  local text="$1"
  
  # 长度
  if echo "$text" | grep -qiE '米|公分'; then
    echo "meter"
  elif echo "$text" | grep -qiE '厘米|公分'; then
    echo "cm"
  elif echo "$text" | grep -qiE '毫米'; then
    echo "mm"
  elif echo "$text" | grep -qiE '公里|千米'; then
    echo "km"
  elif echo "$text" | grep -qiE '英里'; then
    echo "mile"
  elif echo "$text" | grep -qiE '英尺|foot'; then
    echo "ft"
  elif echo "$text" | grep -qiE '英寸|inch'; then
    echo "inch"
    
  # 重量
  elif echo "$text" | grep -qiE '公斤|千克|kg'; then
    echo "kg"
  elif echo "$text" | grep -qiE '克|g'; then
    echo "g"
  elif echo "$text" | grep -qiE '毫克|mg'; then
    echo "mg"
  elif echo "$text" | grep -qiE '斤'; then
    echo "jin"
  elif echo "$text" | grep -qiE '磅|lb'; then
    echo "lb"
  elif echo "$text" | grep -qiE '盎司|oz'; then
    echo "oz"
    
  # 温度
  elif echo "$text" | grep -qiE '摄氏度|度|c'; then
    echo "celsius"
  elif echo "$text" | grep -qiE '华氏度|f'; then
    echo "fahrenheit"
  elif echo "$text" | grep -qiE '开尔文|k'; then
    echo "kelvin"
    
  # 时间
  elif echo "$text" | grep -qiE '秒|s$'; then
    echo "second"
  elif echo "$text" | grep -qiE '分钟|分|m'; then
    echo "minute"
  elif echo "$text" | grep -qiE '小时|时|h'; then
    echo "hour"
  elif echo "$text" | grep -qiE '天|日|d'; then
    echo "day"
  elif echo "$text" | grep -qiE '周|星期|礼拜|w'; then
    echo "week"
  elif echo "$text" | grep -qiE '月|m'; then
    echo "month"
  elif echo "$text" | grep -qiE '年|y'; then
    echo "year"
    
  # 货币
  elif echo "$text" | grep -qiE '美元|美金|刀|usd'; then
    echo "usd"
  elif echo "$text" | grep -qiE '人民币|元|块|cny|rmb'; then
    echo "cny"
  elif echo "$text" | grep -qiE '日元|jpy'; then
    echo "jpy"
  elif echo "$text" | grep -qiE '欧元|欧罗|eur'; then
    echo "eur"
  elif echo "$text" | grep -qiE '英镑|磅|gbp'; then
    echo "gbp"
  elif echo "$text" | grep -qiE '港币|hkd|港'; then
    echo "hkd"
  else
    echo ""
  fi
}

# 提取目标单位
extract_to_unit() {
  local text="$1"
  
  if echo "$text" | grep -qiE '等于|换算成|改成|to'; then
    extract_from_unit "$text"
  else
    echo "default"
  fi
}

# 单位换算
convert_unit() {
  local value="$1" from="$2" to="$3"
  local result=""
  
  # 长度换算
  case "$from" in
    "cm")
      case "$to" in
        "meter"|"") result=$(echo "scale=4; $value / 100" | bc); echo "$value 厘米 = $result 米" ;;
        "mm") result=$(echo "scale=2; $value * 10" | bc); echo "$value 厘米 = $result 毫米" ;;
        "km") result=$(echo "scale=6; $value / 100000" | bc); echo "$value 厘米 = $result 公里" ;;
        "inch") result=$(echo "scale=2; $value / 2.54" | bc); echo "$value 厘米 = $result 英寸" ;;
        "ft") result=$(echo "scale=3; $value / 30.48" | bc); echo "$value 厘米 = $result 英尺" ;;
        *) echo "$value 厘米" ;;
      esac
      ;;
    "meter")
      case "$to" in
        "cm") result=$(echo "scale=2; $value * 100" | bc); echo "$value 米 = $result 厘米" ;;
        "km") result=$(echo "scale=6; $value / 1000" | bc); echo "$value 米 = $result 公里" ;;
        "mile") result=$(echo "scale=4; $value / 1609.344" | bc); echo "$value 米 = $result 英里" ;;
        "ft") result=$(echo "scale=2; $value * 3.28084" | bc); echo "$value 米 = $result 英尺" ;;
        "inch") result=$(echo "scale=1; $value * 39.3701" | bc); echo "$value 米 = $result 英寸" ;;
        *) echo "$value 米" ;;
      esac
      ;;
    "km")
      case "$to" in
        "meter") result=$(echo "scale=0; $value * 1000" | bc); echo "$value 公里 = $result 米" ;;
        "mile") result=$(echo "scale=2; $value / 1.60934" | bc); echo "$value 公里 = $result 英里" ;;
        *) echo "$value 公里" ;;
      esac
      ;;
    "mile")
      case "$to" in
        "km"|"") result=$(echo "scale=2; $value * 1.60934" | bc); echo "$value 英里 = $result 公里" ;;
        "meter") result=$(echo "scale=0; $value * 1609.344" | bc); echo "$value 英里 = $result 米" ;;
        *) echo "$value 英里" ;;
      esac
      ;;
      
    # 重量换算
    "kg")
      case "$to" in
        "g") result=$(echo "scale=0; $value * 1000" | bc); echo "$value 公斤 = $result 克" ;;
        "jin"|"") result=$(echo "scale=1; $value * 2" | bc); echo "$value 公斤 = $result 斤" ;;
        "lb") result=$(echo "scale=2; $value * 2.20462" | bc); echo "$value 公斤 = $result 磅" ;;
        *) echo "$value 公斤" ;;
      esac
      ;;
    "jin")
      case "$to" in
        "kg"|"") result=$(echo "scale=2; $value / 2" | bc); echo "$value 斤 = $result 公斤" ;;
        "g") result=$(echo "scale=0; $value * 500" | bc); echo "$value 斤 = $result 克" ;;
        *) echo "$value 斤" ;;
      esac
      ;;
    "lb")
      case "$to" in
        "kg"|"") result=$(echo "scale=2; $value / 2.20462" | bc); echo "$value 磅 = $result 公斤" ;;
        "jin") result=$(echo "scale=2; $value * 0.907185" | bc | xargs printf "%.1f"); echo "$value 磅 ≈ $result 斤" ;;
        *) echo "$value 磅" ;;
      esac
      ;;
      
    # 温度换算
    "celsius")
      case "$to" in
        "fahrenheit"|"") 
          local f=$(echo "scale=1; $value * 9 / 5 + 32" | bc)
          echo "$value°C = ${f}°F"
          ;;
        "kelvin")
          local k=$(echo "scale=1; $value + 273.15" | bc)
          echo "$value°C = ${k}K"
          ;;
        *) echo "$value°C" ;;
      esac
      ;;
    "fahrenheit")
      case "$to" in
        "celsius"|"")
          local c=$(echo "scale=1; ($value - 32) * 5 / 9" | bc)
          echo "$value°F = ${c}°C"
          ;;
        *) echo "$value°F" ;;
      esac
      ;;
      
    # 时间换算
    "hour")
      case "$to" in
        "minute"|"") result=$(echo "scale=0; $value * 60" | bc); echo "$value 小时 = $result 分钟" ;;
        "second") result=$(echo "scale=0; $value * 3600" | bc); echo "$value 小时 = $result 秒" ;;
        "day") result=$(echo "scale=3; $value / 24" | bc); echo "$value 小时 = $result 天" ;;
        *) echo "$value 小时" ;;
      esac
      ;;
    "minute")
      case "$to" in
        "second"|"") result=$(echo "scale=0; $value * 60" | bc); echo "$value 分钟 = $result 秒" ;;
        "hour") result=$(echo "scale=3; $value / 60" | bc); echo "$value 分钟 = $result 小时" ;;
        *) echo "$value 分钟" ;;
      esac
      ;;
    "day")
      case "$to" in
        "hour"|"") result=$(echo "scale=0; $value * 24" | bc); echo "$value 天 = $result 小时" ;;
        *) echo "$value 天" ;;
      esac
      ;;
      
    # 货币换算（示例汇率）
    "usd")
      case "$to" in
        "cny"|"") 
          local rate=7.2
          result=$(echo "scale=2; $value * $rate" | bc)
          echo "$value 美元 ≈ ¥$result 人民币"
          ;;
        *) echo "$value 美元" ;;
      esac
      ;;
    "cny")
      case "$to" in
        "usd"|"") 
          local rate=7.2
          result=$(echo "scale=2; $value / $rate" | bc)
          echo "¥$value 人民币 ≈ $result 美元"
          ;;
        *) echo "¥$value" ;;
      esac
      ;;
      
    *)
      echo "❌ 暂不支持该单位换算"
      ;;
  esac
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🔄 单位换算"
    echo ""
    echo "使用方法：<数值><单位>等于多少<目标单位>"
    echo "示例："
    echo "  100厘米等于多少米"
    echo "  1公里等于多少英里"
    echo "  37度等于多少摄氏度"
    echo "  1公斤等于多少斤"
    echo "  100美元等于多少人民币"
    echo ""
    echo "支持的换算："
    echo "  长度：米、厘米、毫米、公里、英里、英尺、英寸"
    echo "  重量：公斤、克、斤、磅、盎司"
    echo "  温度：摄氏度、华氏度"
    echo "  时间：秒、分钟、小时、天"
    echo "  货币：美元、人民币、日元、欧元"
    return
  fi
  
  local value from to
  value=$(extract_number "$input")
  from=$(extract_from_unit "$input")
  to=$(extract_to_unit "$input")
  
  if [ -z "$value" ]; then
    echo "❌ 未识别到数值"
    return
  fi
  
  if [ -z "$from" ]; then
    echo "❌ 未识别到单位"
    echo ""
    echo "支持的单位："
    echo "  长度：米、厘米、毫米、公里、英里"
    echo "  重量：公斤、克、斤、磅"
    echo "  温度：摄氏度、华氏度"
    echo "  时间：秒、分钟、小时、天"
    echo "  货币：美元、人民币"
    return
  fi
  
  convert_unit "$value" "$from" "$to"
}

main "$@"
