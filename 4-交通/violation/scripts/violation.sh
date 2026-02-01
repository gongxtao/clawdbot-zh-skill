#!/usr/bin/env bash
# 车辆违章查询脚本

set -e

# 提取车牌号
extract_plate() {
  local text="$1"
  # 匹配车牌格式：京A12345、沪A12345、粤A12345等
  echo "$text" | grep -oE '[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][0-9A-Z]{5,6}' | head -1
}

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '违章|违法|扣分'; then
    echo "violation"
  elif echo "$text" | grep -qiE '罚款|罚金|多少钱'; then
    echo "fine"
  elif echo "$text" | grep -qiE '处理|已处理|未处理'; then
    echo "status"
  else
    echo "query"
  fi
}

# 查询违章
query_violation() {
  local plate="$1"
  
  echo "🚫 违章查询：$plate"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置交管12123 API 可查询真实违章"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📅 查询时间：2026年2月1日"
  echo ""
  echo "  ⚠️  违章记录：共 2 条"
  echo ""
  echo "  1. 2026年1月15日 14:30"
  echo "     🚗 地点：XX路与XX路交叉口"
  echo "     📝 违章：机动车违反禁止标线指示"
  echo "     💰 罚款：¥200"
  echo "     📊 扣分：3 分"
  echo "     ✅ 状态：已处理"
  echo ""
  echo "  2. 2026年1月20日 09:15"
  echo "     🚗 地点：XX高速 XX公里处"
  echo "     📝 违章：超速10%以上未达20%"
  echo "     💰 罚款：¥200"
  echo "     📊 扣分：3 分"
  echo "     ❌ 状态：未处理"
  echo ""
  echo "  📊 汇总："
  echo "     - 总罚款：¥400"
  echo "     - 总扣分：6 分"
  echo "     - 已处理：1 条"
  echo "     - 未处理：1 条"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时违章查询"
  echo "  - 在线处理违章"
  echo "  - 缴纳罚款"
  echo "  - 违章提醒"
}

# 查询罚款
query_fine() {
  local plate="$1"
  
  echo "💰 罚款查询：$plate"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可查询罚款详情"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📊 罚款统计："
  echo "     - 未处理罚款：¥200"
  echo "     - 已处理罚款：¥200"
  echo "     - 总罚款：¥400"
  echo ""
  echo "  💡 常见罚款："
  echo "     - 违停：¥200"
  echo "     - 超速：¥200-2000"
  echo "     - 闯红灯：¥200"
  echo "     - 不按导向：¥100-200"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 罚款明细"
  echo "  - 在线缴费"
  echo "  - 缴费记录"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🚫 车辆违章查询"
    echo ""
    echo "使用方法：查询违章信息"
    echo "示例："
    echo "  查询违章京A12345"
    echo "  车辆违章记录"
    echo "  有没有违章"
    echo ""
    echo "支持的功能："
    echo "  - 违章查询"
    echo "  - 罚款查询"
    echo "  - 处理状态"
    return
  fi
  
  local plate query_type
  
  plate=$(extract_plate "$input")
  query_type=$(detect_type "$input")
  
  if [ -z "$plate" ]; then
    echo "❌ 未识别到车牌号"
    echo ""
    echo "示例格式："
    echo "  京A12345"
    echo "  沪A12345"
    echo "  粤A12345"
    return
  fi
  
  echo "🔍 正在查询 $plate ..."
  echo ""
  
  case "$query_type" in
    "fine")
      query_fine "$plate"
      ;;
    *)
      query_violation "$plate"
      ;;
  esac
}

main "$@"
