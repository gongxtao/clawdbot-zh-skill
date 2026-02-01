#!/usr/bin/env bash
# 加密货币查询脚本

set -e

# 币种代码映射
declare -A CRYPTO_CODES=(
  ["比特币"]="BTC"
  ["BTC"]="BTC"
  ["中本聪"]="BTC"
  ["以太坊"]="ETH"
  ["ETH"]="ETH"
  ["V神"]="ETH"
  ["币安币"]="BNB"
  ["BNB"]="BNB"
  ["索拉纳"]="SOL"
  ["SOL"]="SOL"
  ["瑞波币"]="XRP"
  ["XRP"]="XRP"
  ["艾达币"]="ADA"
  ["ADA"]="ADA"
  ["狗币"]="DOGE"
  ["DOGE"]="DOGE"
  ["马蹄币"]="MATIC"
  ["MATIC"]="MATIC"
  ["波场"]="TRX"
  ["TRX"]="TRX"
  ["莱特币"]="LTC"
  ["LTC"]="LTC"
)

# 模拟价格数据（实际需要 API）
declare -A CRYPTO_PRICES=(
  ["BTC"]="104500.00"
  ["ETH"]="3250.00"
  ["BNB"]="720.00"
  ["SOL"]="185.00"
  ["XRP"]="2.45"
  ["ADA"]="1.05"
  ["DOGE"]="0.38"
  ["MATIC"]="0.92"
  ["TRX"]="0.28"
  ["LTC"]="115.00"
)

# 模拟涨跌幅（%）
declare -A CRYPTO_CHANGES=(
  ["BTC"]="+2.5"
  ["ETH"]="+3.8"
  ["BNB"]="+1.2"
  ["SOL"]="+5.2"
  ["XRP"]="-0.8"
  ["ADA"]="+1.5"
  ["DOGE"]="+8.5"
  ["MATIC"]="-1.2"
  ["TRX"]="+0.5"
  ["LTC"]="+2.1"
)

# 提取币种
extract_crypto() {
  local text="$1"
  for crypto in "${!CRYPTO_CODES[@]}"; do
    if echo "$text" | grep -qiE "$crypto"; then
      echo "${CRYPTO_CODES[$crypto]}"
      return
    fi
  done
  echo ""
}

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "价格|多少钱|行情|报价"; then
    echo "price"
  elif echo "$text" | grep -qiE "涨|跌|涨幅|跌幅|走势"; then
    echo "change"
  elif echo "$text" | grep -qiE "市值|总市值|流通"; then
    echo "market"
  elif echo "$text" | grep -qiE "新闻|消息|动态"; then
    echo "news"
  elif echo "$text" | grep -qiE "所有|全部|列表|排行"; then
    echo "list"
  else
    echo "price"
  fi
}

# 价格查询
query_price() {
  local crypto="$1"
  
  echo "₿ $crypto 行情"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local price change
  price="${CRYPTO_PRICES[$crypto]}"
  change="${CRYPTO_CHANGES[$crypto]}"
  
  if [ -n "$price" ]; then
    local trend
    if echo "$change" | grep -q '+'; then
      trend="📈 涨"
    else
      trend="📉 跌"
    fi
    
    echo "💰 当前价格：\$$price USDT"
    echo "📊 24小时涨跌：$change $trend"
    echo ""
    echo "📱 配置 API 后可获取："
    echo "  - 实时价格（CoinGecko/Binance）"
    echo "  - 24小时最高/最低价"
    echo "  - 成交量"
    echo "  - K线走势"
  else
    echo "❌ 未找到 $crypto 的价格数据"
    echo ""
    echo "支持的币种："
    for crypto in BTC ETH BNB SOL XRP ADA DOGE MATIC TRX LTC; do
      echo "  - $crypto（${!CRYPTO_CODES[$crypto]})"
    done
  fi
}

# 涨跌查询
query_change() {
  local crypto="$1"
  
  echo "📊 $crypto 24小时涨跌"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local change
  change="${CRYPTO_CHANGES[$crypto]}"
  
  if [ -n "$change" ]; then
    echo "📈 24小时涨跌幅：$change"
    echo ""
    
    if echo "$change" | grep -q '+'; then
      echo "🟢 今日上涨，适合观望/减仓"
    else
      echo "🔴 今日下跌，注意风险"
    fi
    echo ""
    echo "💡 加密货币波动较大，请谨慎投资"
  else
    query_change "全部"
  fi
}

# 市值查询
query_market() {
  local crypto="$1"
  
  echo "💼 $crypto 市值信息"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取实时市值数据"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  if [ "$crypto" = "BTC" ]; then
    echo "  比特币（BTC）："
    echo "  - 市值：\$2.1 万亿美元"
    echo "  - 流通量：1,910 万枚"
    echo "  - 最高价：\$108,000"
    echo "  - 最低价：\$95,000"
  elif [ "$crypto" = "ETH" ]; then
    echo "  以太坊（ETH）："
    echo "  - 市值：\$3,900 亿"
    echo "  - 流通量：1.2 亿枚"
    echo "  - 最高价：\$3,500"
    echo "  - 最低价：\$3,000"
  else
    echo "  $crypto："
    echo "  - 市值：\$xxx 亿"
    echo "  - 流通量：xxx 万枚"
    echo "  - 最高价：\$xxx"
    echo "  - 最低价：\$xxx"
  fi
}

# 全部列表
query_all_list() {
  echo "📊 加密货币排行榜"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "🔥 热门币种（模拟）："
  echo ""
  printf "%-6s %-12s %-12s %-10s\n" "币种" "价格" "24h涨跌" "状态"
  printf "%-6s %-12s %-12s %-10s\n" "━━━━" "━━━━" "━━━━━━━━" "━━━━"
  
  for crypto in BTC ETH BNB SOL XRP ADA DOGE MATIC TRX LTC; do
    local price change
    price="${CRYPTO_PRICES[$crypto]}"
    change="${CRYPTO_CHANGES[$crypto]}"
    printf "%-6s \$%-11s %-11s %s\n" "$crypto" "$price" "$change" "🟢"
  done
  
  echo ""
  echo "📱 配置 CoinGecko API 可获取："
  echo "  - 实时价格"
  echo "  - 市值排名"
  echo "  - 交易量"
  echo "  - 历史K线"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "₿ 加密货币查询"
    echo ""
    echo "使用方法：查询加密货币信息"
    echo "示例："
    echo "  比特币价格"
    echo "  ETH 行情"
    echo "  BTC 涨了多少"
    echo "  以太坊市值"
    echo "  今日加密货币走势"
    echo ""
    echo "支持的币种："
    echo "  比特币(BTC)、以太坊(ETH)、币安币(BNB)"
    echo "  索拉纳(SOL)、瑞波币(XRP)、艾达币(ADA)"
    echo "  狗币(DOGE)、马蹄币(MATIC)、波场(TRX)"
    return
  fi
  
  local crypto query_type
  
  crypto=$(extract_crypto "$input")
  query_type=$(detect_query_type "$input")
  
  if [ -z "$crypto" ]; then
    # 未识别币种，显示列表
    query_type="list"
  fi
  
  case "$query_type" in
    "price")
      query_price "$crypto"
      ;;
    "change")
      query_change "$crypto"
      ;;
    "market")
      query_market "$crypto"
      ;;
    "news")
      echo "📰 加密货币新闻"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时新闻"
      echo ""
      echo "示例新闻（模拟）："
      echo "  - BTC 突破 10 万美元，机构持续买入"
      echo "  - ETH 2.0 升级进展顺利"
      echo "  - SOL 生态应用快速增长"
      echo "  - 某交易所推出新合约产品"
      ;;
    "list")
      query_all_list
      ;;
    *)
      query_price "$crypto"
      ;;
  esac
}

main "$@"
