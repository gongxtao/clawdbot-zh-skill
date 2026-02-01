#!/usr/bin/env bash
# 公交地铁查询脚本

set -e

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "地铁|1号线|2号线"; then
    echo "subway"
  elif echo "$text" | grep -qiE "公交|路|公交车"; then
    echo "bus"
  elif echo "$text" | grep -qiE "怎么坐车|换乘|从.*到.*怎么走"; then
    echo "route"
  elif echo "$text" | grep -qiE "附近|最近.*站"; then
    echo "nearby"
  else
    echo "search"
  fi
}

# 提取线路号
extract_line_number() {
  local text="$1"
  echo "$text" | grep -oE '[0-9]+号线' | head -1
}

# 提取公交号
extract_bus_number() {
  local text="$1"
  echo "$text" | grep -oE '[0-9]+路' | head -1 | sed 's/路//'
}

# 地铁线路查询
query_subway() {
  local line="$1"
  
  echo "🚇 地铁 $line"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时信息"
  echo ""
  echo "示例信息（模拟）："
  echo ""
  echo "  运营时间：05:00 - 23:00"
  echo "  途经站点：xx 站"
  echo "  换乘站：xxx、xxx、xxx"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 完整站点列表"
  echo "  - 首末班车时间"
  echo "  - 实时拥挤度"
  echo "  - 故障延误信息"
}

# 公交线路查询
query_bus() {
  local line="$1"
  
  echo "🚌 公交 $line 路"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时信息"
  echo ""
  echo "示例信息（模拟）："
  echo ""
  echo "  运营时间：05:30 - 22:30"
  echo "  票价：2 元"
  echo "  途经：xx 站"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 完整站点列表"
  echo "  - 实时到站时间"
  echo "  - 首末班车时间"
}

# 换乘查询
query_route() {
  local from="$1"
  local to="$2"
  
  echo "🗺️ 换乘方案：$from → $to"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置高德/百度地图 API 可获取实时方案"
  echo ""
  echo "示例方案（模拟）："
  echo ""
  echo "  🚇 方案一（推荐）：地铁"
  echo "     路线：xx站 → xx站 → xx站"
  echo "     耗时：约 45 分钟"
  echo "     费用：5 元"
  echo ""
  echo "  🚌 方案二：公交"
  echo "     路线：xx路 → xx路"
  echo "     耗时：约 60 分钟"
  echo "     费用：4 元"
  echo ""
  echo "  🚇+🚌 方案三：地铁+公交"
  echo "     路线：xx站 → xx路"
  echo "     耗时：约 50 分钟"
  echo "     费用：6 元"
  echo ""
  echo "📱 配置 API 后可获取实时路线和到站时间"
}

# 附近站点查询
query_nearby_station() {
  local location="$1"
  
  echo "🚏 附近站点：$location"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "示例结果（模拟）："
  echo ""
  echo "  🚌 公交站（距您 200米）："
  echo "     - xx路（前往 xx 方向）"
  echo "     - xx路（前往 xx 方向）"
  echo ""
  echo "  🚇 地铁站（距您 500米）："
  echo "     - xx站（1号线、2号线）"
  echo ""
  echo "📱 配置 API 后可获取实时到站时间和首末班车"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🚌 公交地铁查询"
    echo ""
    echo "使用方法：查询公交/地铁信息"
    echo "示例："
    echo "  北京地铁1号线"
    echo "  上海公交911路"
    echo "  从望京到国贸怎么坐车"
    echo "  最近的地铁站在哪"
    echo ""
    echo "支持的功能："
    echo "  - 地铁线路查询"
    echo "  - 公交线路查询"
    echo "  - 换乘规划"
    echo "  - 附近站点"
    return
  fi
  
  local query_type
  query_type=$(detect_query_type "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "subway")
      local line
      line=$(extract_line_number "$input")
      if [ -n "$line" ]; then
        query_subway "$line"
      else
        echo "❌ 未识别到地铁线路"
        echo "示例：北京地铁1号线"
      fi
      ;;
    "bus")
      local bus_num
      bus_num=$(extract_bus_number "$input")
      if [ -n "$bus_num" ]; then
        query_bus "$bus_num"
      else
        echo "❌ 未识别到公交线路"
        echo "示例：上海公交911路"
      fi
      ;;
    "route")
      # 提取"从...到..."中间的地点
      local route_text
      route_text=$(echo "$input" | sed -E 's/怎么坐车|怎么走|怎么去//g')
      local from to
      from=$(echo "$route_text" | sed -E 's/从(.+)到.+/\1/' | xargs)
      to=$(echo "$route_text" | sed -E 's/从.+到(.+)/\1/' | xargs)
      query_route "$from" "$to"
      ;;
    "nearby")
      local location
      location=$(echo "$input" | sed -E 's/(附近|最近).*站//g' | xargs)
      if [ -z "$location" ]; then
        location="当前位置"
      fi
      query_nearby_station "$location"
      ;;
    *)
      echo "❓ 未识别查询类型"
      echo ""
      echo "支持的查询："
      echo "  - 地铁线路：北京地铁1号线"
      echo "  - 公交线路：上海公交911路"
      echo "  - 换乘规划：从望京到国贸怎么坐车"
      echo "  - 附近站点：最近的地铁站在哪"
      ;;
  esac
}

main "$@"
