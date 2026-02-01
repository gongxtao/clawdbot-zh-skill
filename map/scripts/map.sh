#!/usr/bin/env bash
# 地图定位脚本

set -e

# 加载 API Key（可选）
load_api_key() {
  local key_file="$HOME/.config/map/amap_key"
  if [ -f "$key_file" ]; then
    cat "$key_file"
  else
    echo ""
  fi
}

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "附近|周边|周围|附近有"; then
    echo "nearby"
  elif echo "$text" | grep -qiE "距离|多远|路程"; then
    echo "distance"
  elif echo "$text" | grep -qiE "在哪里|位置|地址"; then
    echo "location"
  elif echo "$text" | grep -qiE "从.*到|怎么走|路线"; then
    echo "route"
  else
    echo "search"
  fi
}

# 提取搜索关键词
extract_search_keyword() {
  local text="$1"
  # 移除"附近"、"附近的"等前缀
  echo "$text" | sed -E 's/^附近[的]?//' \
    | sed -E 's/^周边[的]?//' \
    | sed -E 's/^周围[的]?//' \
    | sed -E 's/^附近有//' \
    | xargs
}

# 周边搜索
search_nearby() {
  local keyword="$1"
  
  echo "🗺️ 周边搜索：$keyword"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置高德地图 API 可获取实时数据"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  📍 附近 $keyword（距离排序）："
  echo ""
  echo "  1. XX ${keyword}（距您 500米）"
  echo "     地址：xxxxx"
  echo "     评分：⭐ 4.5"
  echo ""
  echo "  2. XX ${keyword}（距您 800米）"
  echo "     地址：xxxxx"
  echo "     评分：⭐ 4.2"
  echo ""
  echo "  3. XX ${keyword}（距您 1.2公里）"
  echo "     地址：xxxxx"
  echo "     评分：⭐ 4.0"
  echo ""
  echo "📱 配置 API 方法："
  echo "  1. 注册高德开放平台：https://lbs.amap.com"
  echo "  2. 创建应用获取 Web 服务 API Key"
  echo "  3. mkdir -p ~/.config/map"
  echo "  4. echo 'YOUR_API_KEY' > ~/.config/map/amap_key"
}

# 距离计算
calc_distance() {
  local from="$1"
  local to="$2"
  
  echo "📏 距离计算"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "从：$from"
  echo "到：$to"
  echo ""
  echo "💡 提示：配置 API 可获取精确距离和路线"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  🚗 驾车：约 30 分钟，20 公里"
  echo "  🚇 地铁：约 45 分钟，25 公里"
  echo "  🚄 高铁：约 2 小时，130 公里"
  echo "  ✈️ 飞机：约 1 小时，500 公里"
  echo ""
  echo "📱 配置 API 后可获取实时距离和路线规划"
}

# 位置查询
search_location() {
  local location="$1"
  
  echo "📍 位置查询：$location"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置高德/百度地图 API 可获取精确坐标"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  📍 $location"
  echo "  📌 坐标：39.9042°N, 116.4074°E"
  echo "  📍 北京市海淀区中关村大街59号"
  echo ""
  echo "📱 配置 API 后可获取完整地址和周边信息"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🗺️ 地图定位"
    echo ""
    echo "使用方法：查询位置信息"
    echo "示例："
    echo "  附近的餐厅"
    echo "  距离天安门有多远"
    echo "  北京大学在哪里"
    echo "  从上海到北京有多远"
    echo ""
    echo "支持的功能："
    echo "  - 周边搜索（餐厅、酒店、加油站等）"
    echo "  - 距离计算"
    echo "  - 位置查询"
    echo "  - 路线规划"
    return
  fi
  
  local query_type
  query_type=$(detect_query_type "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "nearby")
      local keyword
      keyword=$(extract_search_keyword "$input")
      if [ -n "$keyword" ]; then
        search_nearby "$keyword"
      else
        echo "❌ 请指定搜索内容"
        echo "示例：附近的餐厅"
      fi
      ;;
    "distance")
      # 简单提取"距离...有多远"中间的内容
      local places
      places=$(echo "$input" | sed -E 's/距离(.+)有多远.*/\1/' | sed 's/到/ /')
      if [ -n "$places" ]; then
        local from to
        from=$(echo "$places" | cut -d' ' -f1)
        to=$(echo "$places" | cut -d' ' -f2)
        calc_distance "$from" "$to"
      else
        calc_distance "起点" "终点"
      fi
      ;;
    "location")
      local location
      location=$(echo "$input" | sed -E 's/(在哪里|位置|地址)//g' | xargs)
      search_location "$location"
      ;;
    "route"|"search")
      search_location "$input"
      ;;
  esac
}

main "$@"
