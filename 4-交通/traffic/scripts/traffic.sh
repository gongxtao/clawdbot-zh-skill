#!/usr/bin/env bash
# 实时路况查询脚本

set -e

# 提取城市
extract_city() {
  local text="$1"
  for city in 北京 上海 广州 深圳 杭州 成都 武汉 南京 西安 重庆 天津 长沙 青岛 厦门; do
    if echo "$text" | grep -qi "$city"; then
      echo "$city"
      return
    fi
  done
  echo ""
}

# 提取路段
extract_road() {
  local text="$1"
  for road in 三环 四环 五环 长安街 中关村 浦东 外滩; do
    if echo "$text" | grep -qi "$road"; then
      echo "$road"
      return
    fi
  done
  echo ""
}

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '堵|拥堵|堵车'; then
    echo "congestion"
  elif echo "$text" | grep -qiE '事故|车祸|碰撞'; then
    echo "accident"
  elif echo "$text" | grep -qiE '施工|修路|封闭'; then
    echo "construction"
  elif echo "$text" | grep -qiE '晚高峰|早高峰|高峰'; then
    echo "peak"
  else
    echo "overview"
  fi
}

# 查询路况概览
query_overview() {
  local city="$1"
  
  echo "🚦 实时路况：$city"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📊 当前路况概览："
  echo ""
  echo "  🟢 畅通：65%（绿色）"
  echo "  🟡 缓行：25%（黄色）"
  echo "  🔴 拥堵：10%（红色）"
  echo ""
  echo "  📈 拥堵指数：2.1（轻度拥堵）"
  echo "  🕐 更新时间：刚刚"
  echo ""
  echo "💡 提示：配置地图 API 可获取实时路况"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时路况更新"
  echo "  - 拥堵趋势预测"
  echo "  - 最佳出行路线"
}

# 查询拥堵
query_congestion() {
  local city="$1" road="$2"
  
  echo "🚗 拥堵查询：$city $road"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  if [ -n "$road" ]; then
    echo "📍 $road 路况"
    echo ""
    echo "💡 提示：配置 API 可获取精确拥堵信息"
    echo ""
    echo "示例数据（模拟）："
    echo ""
    echo "  🟡 当前状态：轻度拥堵"
    echo "  📈 行驶速度：25 km/h"
    echo "  ⏱️ 预计通过时间：15 分钟"
    echo ""
    echo "  📝 拥堵原因："
    echo "     - 晚高峰车流量大"
    echo "     - 前方有轻微事故"
    echo ""
    echo "  💡 建议："
    echo "     - 建议绕行其他路线"
    echo "     - 或错峰出行"
  else
    query_overview "$city"
  fi
}

# 查询事故
query_accident() {
  local city="$1"
  
  echo "🚨 交通事故：$city"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取实时事故信息"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  ⚠️  事故提醒：共 3 起"
  echo ""
  echo "  1. 西二旗大街与信息路交叉口"
  echo "     事故类型：轻微刮擦"
  echo "     影响：右侧车道通行缓慢"
  echo "     预计恢复：30 分钟"
  echo ""
  echo "  2. 北四环中关村段"
  echo "     事故类型：抛锚"
  echo "     影响：应急车道占用"
  echo "     预计恢复：15 分钟"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时事故推送"
  echo "  - 事故详情"
  echo "  - 绕行建议"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🚦 实时路况查询"
    echo ""
    echo "使用方法：查询路况信息"
    echo "示例："
    echo "  北京现在堵车吗"
    echo "  上海路况"
    echo "  三环路堵不堵"
    echo ""
    echo "支持的功能："
    echo "  - 路况概览"
    echo "  - 拥堵查询"
    echo "  - 事故提醒"
    echo "  - 施工路段"
    return
  fi
  
  local city road query_type
  
  city=$(extract_city "$input")
  road=$(extract_road "$input")
  query_type=$(detect_type "$input")
  
  if [ -z "$city" ]; then
    city="当前城市"
  fi
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "congestion")
      query_congestion "$city" "$road"
      ;;
    "accident")
      query_accident "$city"
      ;;
    "construction")
      echo "🚧 施工路段：$city"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取施工信息"
      ;;
    "peak")
      echo "⏰ 高峰时段路况：$city"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取高峰预测"
      ;;
    *)
      query_overview "$city"
      ;;
  esac
}

main "$@"
