#!/usr/bin/env bash
# 信用卡账单查询脚本

set -e

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '账单|消费'; then
    echo "bill"
  elif echo "$text" | grep -qiE '还款|还钱|还款日'; then
    echo "repayment"
  elif echo "$text" | grep -qiE '积分|积分兑换'; then
    echo "points"
  elif echo "$text" | grep -qiE '额度|额度查询'; then
    echo "limit"
  else
    echo "bill"
  fi
}

# 提取信用卡名
extract_card() {
  local text="$1"
  for card in 招商 交通 工商 建设 农业 中国 民生 中信 浦发 光大 兴业 平安; do
    if echo "$text" | grep -qi "$card"; then
      echo "${card}银行信用卡"
      return
    fi
  done
  echo "信用卡"
}

# 查询账单
query_bill() {
  local card="$1"
  
  echo "💳 账单查询：$card"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置银行 API 可获取实时账单"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📅 账单周期：2026年1月1日 - 1月31日"
  echo ""
  echo "  💰 本期账单："
  echo "     - 消费总额：¥3,456.78"
  echo "     - 最低还款：¥345.68"
  echo "     - 免息期：20-50天"
  echo ""
  echo "  💳 消费明细 TOP 5："
  echo "     1. 超市消费：¥1,234.56"
  echo "     2. 餐饮：¥567.89"
  echo "     3. 网购：¥456.78"
  echo "     4. 加油：¥345.67"
  echo "     5. 其他：¥234.56"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时账单查询"
  echo "  - 消费明细"
  echo "  - 账单分期"
  echo "  - 自动还款设置"
}

# 查询还款
query_repayment() {
  local card="$1"
  
  echo "💰 还款信息：$card"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置银行 API 可获取还款信息"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  📅 还款日：2026年2月15日"
  echo "  ⏰ 剩余天数：14 天"
  echo ""
  echo "  💰 应还金额："
  echo "     - 最低还款：¥345.68"
  echo "     - 全额还款：¥3,456.78"
  echo "     - 分期还款：可选 3/6/12/24 期"
  echo ""
  echo "  ⚠️  温馨提示："
  echo "     - 逾期将产生滞纳金"
  echo "     - 影响个人信用记录"
  echo "     - 建议设置自动还款"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 还款提醒"
  echo "  - 自动扣款"
  echo "  - 分期计算"
}

# 查询积分
query_points() {
  local card="$1"
  
  echo "🎁 积分查询：$card"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置银行 API 可获取实时积分"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  🎯 当前积分：12,345 分"
  echo "  📅 积分到期：2026年12月31日"
  echo "  📈 本月新增：1,234 分"
  echo ""
  echo "  💡 积分兑换："
  echo "     - 1000积分 = ¥1"
  echo "     - 可兑换：京东卡、话费等"
  echo "     - 积分商城：积分商城链接"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 实时积分查询"
  echo "  - 积分兑换"
  echo "  - 积分明细"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "💳 信用卡查询"
    echo ""
    echo "使用方法：查询信用卡信息"
    echo "示例："
    echo "  信用卡账单"
    echo "  什么时候还款"
    echo "  信用卡积分"
    echo ""
    echo "支持的功能："
    echo "  - 账单查询"
    echo "  - 还款信息"
    echo "  - 积分查询"
    return
  fi
  
  local card query_type
  
  card=$(extract_card "$input")
  query_type=$(detect_type "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "bill")
      query_bill "$card"
      ;;
    "repayment")
      query_repayment "$card"
      ;;
    "points")
      query_points "$card"
      ;;
    "limit")
      echo "💳 额度查询：$card"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可查询："
      echo "  - 当前可用额度"
      echo "  - 永久额度"
      echo "  - 临时额度"
      echo "  - 提额记录"
      ;;
  esac
}

main "$@"
