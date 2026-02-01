#!/usr/bin/env bash
# 基金查询脚本

set -e

# 基金代码映射（示例）
declare -A FUND_CODES=(
  ["易方达蓝筹"]="161039"
  ["易方达中小盘"]="161130"
  ["富国天惠"]="161035"
  ["景顺长城"]="260108"
  ["兴全合润"]="163406"
  ["中欧时代先锋"]="001938"
  ["交银精选"]="519680"
  ["诺安成长"]="320007"
  ["银河创新成长"]="519674"
  ["易方达消费"]="110022"
)

# 提取基金名称或代码
extract_fund() {
  local text="$1"
  
  # 先检查是否有基金代码（6位数字）
  local code
  code=$(echo "$text" | grep -oE '[0-9]{6}' | head -1)
  if [ -n "$code" ]; then
    echo "code:$code"
    return
  fi
  
  # 检查基金名称
  for fund in "${!FUND_CODES[@]}"; do
    if echo "$text" | grep -qiE "$fund"; then
      echo "name:${fund}"
      return
    fi
  done
  
  echo ""
}

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "净值|价格|多少钱"; then
    echo "nav"
  elif echo "$text" | grep -qiE "收益|赚|赔|涨|跌"; then
    echo "return"
  elif echo "$text" | grep -qiE "持仓|重仓|股票"; then
    echo "position"
  elif echo "$text" | grep -qiE "推荐|热门|定投"; then
    echo "recommend"
  else
    echo "nav"
  fi
}

# 净值查询
query_nav() {
  local fund_name="$1" fund_code="$2"
  
  echo "📊 基金净值查询"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local code="${FUND_CODES[$fund_name]:-$fund_code}"
  local name="$fund_name"
  
  if [ -z "$name" ]; then
    name="基金"
  fi
  
  echo "💡 提示：配置天天基金 API 可获取实时净值"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  基金名称：$name（$code）"
  echo "  最新净值：1.5632"
  echo "  日增长率：+0.58%"
  echo "  近一周：+1.23%"
  echo "  近一月：+3.45%"
  echo "  近三月：+8.76%"
  echo "  近一年：+15.32%"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时净值"
  echo "  - 详细收益率曲线"
  echo "  - 基金规模、基金经理"
  echo "  - 历史净值走势"
}

# 收益查询
query_return() {
  local fund_name="$1" fund_code="$2"
  
  echo "💰 基金收益查询"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local code="${FUND_CODES[$fund_name]:-$fund_code}"
  local name="$fund_name"
  
  if [ -z "$name" ]; then
    name="基金"
  fi
  
  echo "💡 提示：配置 API 可获取实时收益数据"
  echo ""
  echo "示例收益（模拟）："
  echo ""
  echo "  基金：$name（$code）"
  echo ""
  echo "  持有收益：+¥1,234.56"
  echo "  持有收益率：+12.34%"
  echo ""
  echo "  今日收益：+¥56.78"
  echo "  昨日收益：-¥23.45"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时收益计算"
  echo "  - 持仓成本"
  echo "  - 分红记录"
  echo "  - 申赎状态"
}

# 持仓查询
query_position() {
  local fund_name="$1"
  
  echo "📈 基金持仓查询：$fund_name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取基金最新持仓"
  echo ""
  echo "示例持仓（模拟）："
  echo ""
  echo "  重仓股票 TOP 10："
  echo ""
  printf "  %-6s %-20s %-10s %-10s\n" "排名" "股票名称" "持仓占比" "涨跌"
  printf "  %-6s %-20s %-10s %-10s\n" "━━━━" "━━━━━━━━━━━━━━" "━━━━━━━━" "━━━━"
  printf "  %-6s %-20s %-10s %-10s\n" "1" "贵州茅台" "9.52%" "+2.3%"
  printf "  %-6s %-20s %-10s %-10s\n" "2" "宁德时代" "8.76%" "+1.8%"
  printf "  %-6s %-20s %-10s %-10s\n" "3" "五粮液" "6.23%" "+0.5%"
  printf "  %-6s %-20s %-10s %-10s\n" "4" "泸州老窖" "5.89%" "-0.3%"
  printf "  %-6s %-20s %-10s %-10s\n" "5" "山西汾酒" "4.56%" "+1.2%"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 最新季度持仓"
  echo "  - 持仓变动分析"
  echo "  - 行业配置"
}

# 推荐查询
query_recommend() {
  echo "🌟 基金推荐"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取实时推荐数据"
  echo ""
  echo "热门定投基金（模拟）："
  echo ""
  echo "  📌 指数型："
  echo "     - 沪深300ETF联接"
  echo "     - 中证500ETF联接"
  echo ""
  echo "  📌 混合型："
  echo "     - 易方达蓝筹精选"
  echo "     - 富国天惠成长"
  echo ""
  echo "  📌 债券型："
  echo "     - 纯债债券"
  echo "     - 中短债基金"
  echo ""
  echo "⚠️  基金有风险，投资需谨慎"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "📊 基金查询"
    echo ""
    echo "使用方法：查询基金信息"
    echo "示例："
    echo "  易方达蓝筹净值"
    echo "  基金代码161039"
    echo "  我的基金收益"
    echo "  定投基金推荐"
    echo ""
    echo "支持的查询："
    echo "  - 净值查询"
    echo "  - 收益查询"
    echo "  - 持仓查询"
    echo "  - 基金推荐"
    return
  fi
  
  local fund_info query_type fund_name fund_code
  
  fund_info=$(extract_fund "$input")
  query_type=$(detect_query_type "$input")
  
  if echo "$fund_info" | grep -q "^code:"; then
    fund_code=$(echo "$fund_info" | cut -d':' -f2)
    fund_name=""
  elif echo "$fund_info" | grep -q "^name:"; then
    fund_name=$(echo "$fund_info" | cut -d':' -f2)
    fund_code="${FUND_CODES[$fund_name]}"
  fi
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "nav")
      query_nav "$fund_name" "$fund_code"
      ;;
    "return")
      query_return "$fund_name" "$fund_code"
      ;;
    "position")
      if [ -n "$fund_name" ]; then
        query_position "$fund_name"
      else
        echo "❌ 请提供基金名称"
        echo "示例：易方达蓝筹持仓"
      fi
      ;;
    "recommend")
      query_recommend
      ;;
  esac
}

main "$@"
