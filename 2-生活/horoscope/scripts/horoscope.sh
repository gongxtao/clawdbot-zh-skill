#!/usr/bin/env bash
# 星座运势脚本

set -e

# 星座代码映射
declare -A STAR_CODES=(
  ["白羊"]="aries"
  ["金牛"]="taurus"
  ["双子"]="gemini"
  ["巨蟹"]="cancer"
  ["狮子"]="leo"
  ["处女"]="virgo"
  ["天秤"]="libra"
  ["天蝎"]="scorpio"
  ["射手"]="sagittarius"
  ["摩羯"]="capricorn"
  ["水瓶"]="aquarius"
  ["双鱼"]="pisces"
)

# 星座图标
declare -A STAR_ICONS=(
  ["aries"]="♈"
  ["taurus"]="♉"
  ["gemini"]="♊"
  ["cancer"]="♋"
  ["leo"]="♌"
  ["virgo"]="♍"
  ["libra"]="♎"
  ["scorpio"]="♏"
  ["sagittarius"]="♐"
  ["capricorn"]="♑"
  ["aquarius"]="♒"
  ["pisces"]="♓"
)

# 提取星座
extract_star() {
  local text="$1"
  for star in "${!STAR_CODES[@]}"; do
    if echo "$text" | grep -qiE "$star|座"; then
      echo "${STAR_CODES[$star]}"
      return
    fi
  done
  echo ""
}

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '配对|匹配|合不合适|在一起'; then
    echo "match"
  elif echo "$text" | grep -qiE '性格|特点|优缺点'; then
    echo "personality"
  elif echo "$text" | grep -qiE '今日|今天|明日|本周|本月|今年'; then
    echo "fortune"
  else
    echo "fortune"
  fi
}

# 运势查询
query_fortune() {
  local star="$1" icon
  
  icon="${STAR_ICONS[$star]}"
  local star_name=$(echo "$star" | sed 's/.*/\u&/')
  
  echo "♈ $star_name 今日运势 $icon"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置星座 API 可获取实时运势"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📊 综合运势：★★★☆☆"
  echo "  💕 爱情运势：★★★☆☆"
  echo "  💼 事业运势：★★★★☆"
  echo "  💰 财运运势：★★★☆☆"
  echo ""
  echo "  📝 今日建议："
  echo "     适合处理积压的工作，"
  echo "     爱情运势平稳，"
  echo "     财运一般，建议理性消费。"
  echo ""
  echo "  🔮 幸运数字：7"
  echo "  🔮 幸运颜色：蓝色"
  echo "  🔮 贵人星座：狮子座"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 每日实时运势"
  echo "  - 本周/本月运势"
  echo "  - 详细解读"
}

# 性格分析
query_personality() {
  local star="$1"
  
  echo "♈ $star 性格分析"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取详细性格分析"
  echo ""
  echo "示例性格（模拟）："
  echo ""
  echo "  🌟 性格优点："
  echo "     自信、热情、慷慨、领导力强"
  echo ""
  echo "  ⚠️ 性格缺点："
  echo "     固执、急躁、自我为中心"
  echo ""
  echo "  💪 适合职业："
  echo "     领导者、企业家、运动员"
  echo ""
  echo "  ❤️ 最佳配对："
  echo "     狮子座、射手座"
}

# 配对查询
query_match() {
  local star1="$1" star2="$2"
  
  echo "♈ 星座配对：$star1 + $star2"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取详细配对分析"
  echo ""
  echo "示例配对（模拟）："
  echo ""
  echo "  💕 匹配度：75%"
  echo ""
  echo "  📝 分析："
  echo "     你们在一起充满活力，"
  echo "     性格互补，沟通顺畅，"
  echo "     有望成为长久伴侣。"
  echo ""
  echo "  💡 建议："
  echo "     学会包容对方的缺点，"
  echo "     多沟通减少误会，"
  echo "     保持新鲜感。"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "♈ 星座运势"
    echo ""
    echo "使用方法：查询星座信息"
    echo "示例："
    echo "  今天运势怎么样"
    echo "  天秤座今日运势"
    echo "  狮子座性格分析"
    echo "  双子和天蝎座配不配"
    echo ""
    echo "支持的星座："
    echo "  白羊、金牛、双子、巨蟹、狮子、处女"
    echo "  天秤、天蝎、射手、摩羯、水瓶、双鱼"
    return
  fi
  
  local star1 star2 query_type
  
  star1=$(extract_star "$input")
  query_type=$(detect_type "$input")
  
  # 提取第二个星座（配对查询）
  if [ "$query_type" = "match" ]; then
    local temp_input="$input"
    for star in "${!STAR_CODES[@]}"; do
      temp_input=$(echo "$temp_input" | sed "s/$star//gI")
    done
    star2=$(extract_star "$temp_input")
  fi
  
  if [ -z "$star1" ]; then
    echo "❌ 未识别到星座"
    echo ""
    echo "支持的星座："
    echo "  白羊、金牛、双子、巨蟹、狮子、处女"
    echo "  天秤、天蝎、射手、摩羯、水瓶、双鱼"
    return
  fi
  
  case "$query_type" in
    "fortune")
      query_fortune "$star1"
      ;;
    "personality")
      query_personality "$star1"
      ;;
    "match")
      if [ -n "$star2" ]; then
        query_match "$star1" "$star2"
      else
        echo "❌ 请提供两个星座"
        echo "示例：双子和天蝎座配对"
      fi
      ;;
  esac
}

main "$@"
