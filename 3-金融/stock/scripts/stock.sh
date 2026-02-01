#!/usr/bin/env bash
# 股票查询脚本

set -e

# 股票代码映射（常用股票）
declare -A STOCK_CODES=(
  # A股 - 贵州茅台
  ["贵州茅台"]="sh600519"
  ["茅台"]="sh600519"
  ["五粮液"]="sz000858"
  ["宁德时代"]="sz300750"
  ["比亚迪"]="sz002594"
  ["平安银行"]="sz000001"
  ["招商银行"]="sh600036"
  ["中信证券"]="sh600030"
  ["中国平安"]="sh601318"
  
  # 港股
  ["腾讯"]="hk00700"
  ["美团"]="hk03690"
  ["阿里巴巴"]="hk09988"
  ["京东"]="hk09618"
  ["小米"]="hk01810"
  ["网易"]="hk09999"
  ["快手"]="hk01024"
  ["比亚迪股份"]="hk12111"
  
  # 美股
  ["苹果"]="AAPL"
  ["谷歌"]="GOOGL"
  ["微软"]="MSFT"
  ["亚马逊"]="AMZN"
  ["特斯拉"]="TSLA"
  ["Meta"]="META"
  ["英伟达"]="NVDA"
  ["Netflix"]="NFLX"
  
  # 指数
  ["上证指数"]="sh000001"
  ["上证综指"]="sh000001"
  ["深证成指"]="sz399001"
  ["创业板指"]="sz399006"
  ["沪深300"]="sh000300"
  ["恒生指数"]="hsI"
  ["道琼斯"]="DJI"
  ["纳斯达克"]="IXIC"
)

# 提取股票名称
extract_stock() {
  local text="$1"
  for stock in "${!STOCK_CODES[@]}"; do
    if echo "$text" | grep -qi "$stock"; then
      echo "$stock"
      return
    fi
  done
  echo ""
}

# 获取股票数据（使用东方财富免费接口）
get_stock_data() {
  local code="$1"
  
  # 判断是A股还是港股还是美股
  if [[ "$code" =~ ^sh ]] || [[ "$code" =~ ^sz ]]; then
    # A股 - 使用新浪接口
    local url="https://hq.sinajs.cn/list=${code}" 
    local response
    response=$(curl -s -m 5 "https://hq.sinajs.cn/list=${code}" -H "Referer: http://finance.sina.com.cn" 2>/dev/null | iconv -f GBK -t UTF-8 2>/dev/null)
    
    if [ -z "$response" ] || echo "$response" | grep -qi "incorrect"; then
      # 备用：使用东方财富
      response=$(curl -s -m 5 "http://push2.eastmoney.com/api/qt/stock/get?fltt=2&fields=f2,f3,f4,f5,f6,f12,f13,f14,f15,f16,f17,f18,f20,f21,f24,f25,f22,f23&secid=${code}" 2>/dev/null)
      echo "$response"
      return
    fi
    
    echo "$response"
  elif [[ "$code" =~ ^hk ]]; then
    # 港股 - 使用腾讯接口
    local hk_code=$(echo "$code" | sed 's/hk//')
    local url="http://qt.gtimg.cn/q=${hk_code}"
    local response
    response=$(curl -s -m 5 "$url" 2>/dev/null)
    echo "$response"
  else
    # 美股 - 使用 Yahoo Finance
    local url="https://query1.finance.yahoo.com/v8/finance/chart/${code}"
    local response
    response=$(curl -s -m 5 "$url" 2>/dev/null)
    echo "$response"
  fi
}

# 解析A股数据
parse_ashare() {
  local response="$1"
  local stock_name="$2"
  
  # 新浪格式：var hq_str_sh600519="贵州茅台,1700.00,1688.00,1690.00,1710.00,1670.00,1688.00,1688.00,23456,123456789,1688.00,2024-01-01,09:30:00";
  if echo "$response" | grep -q "hq_str"; then
    local data
    data=$(echo "$response" | grep -oE '="[^"]*"' | sed 's/="//;s/"$//' | tail -1)
    
    local name open high low close pre_close volume amount
    IFS=',' read -r name open high low close pre_close <<< "$(echo "$data" | cut -d',' -f1-6)"
    volume=$(echo "$data" | cut -d',' -f9)
    amount=$(echo "$data" | cut -d',' -f10)
    
    echo "📈 $stock_name"
    echo "━━━━━━━━━━━━━━━━"
    echo "📊 当前价：¥$close"
    echo "📉 涨跌：$(echo "scale=2; $close - $pre_close" | bc) $(echo "scale=2; ($close - $pre_close) / $pre_close * 100" | bc)%"
    echo ""
    echo "📊 今日数据："
    echo "  开盘：¥$open"
    echo "  最高：¥$high"
    echo "  最低：¥$low"
    echo "  成交量：$volume 手"
    return
  fi
  
  # 东方财富格式
  local close price_change percent_change
  close=$(echo "$response" | grep -oE '"f2":[0-9.]+' | cut -d':' -f2)
  price_change=$(echo "$response" | grep -oE '"f3":[0-9.-]+' | cut -d':' -f2)
  percent_change=$(echo "$response" | grep -oE '"f4":[0-9.-]+' | cut -d':' -f2)
  
  if [ -n "$close" ] && [ "$close" != "0" ]; then
    echo "📈 $stock_name"
    echo "━━━━━━━━━━━━━━━━"
    echo "📊 当前价：¥$close"
    echo "📉 涨跌：$price_change ($percent_change%)"
  else
    echo "❌ 未获取到数据，请稍后重试"
  fi
}

# 解析港股数据
parse_hkstock() {
  local response="$1"
  local stock_name="$2"
  
  # 腾讯格式：hk00700~腾讯控股~180.00~185.00~182.00~178.00~180.00~182.00~5000000~900000000~182.00~09:30:00~04:04:00
  if echo "$response" | grep -q "hk"; then
    local data
    data=$(echo "$response" | cut -d'~' -f1-8)
    
    local name current high low
    current=$(echo "$response" | cut -d'~' -f7)
    high=$(echo "$response" | cut -d'~' -f5)
    low=$(echo "$response" | cut -d'~' -f6)
    
    echo "📈 $stock_name"
    echo "━━━━━━━━━━━━━━━━"
    echo "📊 当前价：HK\$$current"
    echo "📊 今日范围：HK\$ $low ~ HK\$ $high"
    return
  fi
  
  echo "❌ 未获取到数据，请稍后重试"
}

# 解析美股数据
parse_usstock() {
  local response="$1"
  local stock_name="$2"
  
  # JSON format
  local close
  close=$(echo "$response" | grep -oE '"regularMarketPrice":[0-9.]+' | head -1 | cut -d':' -f2)
  
  if [ -n "$close" ]; then
    echo "📈 $stock_name"
    echo "━━━━━━━━━━━━━━━━"
    echo "📊 当前价：\$$close"
  else
    echo "❌ 未获取到数据，请稍后重试"
  fi
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "📈 股票查询"
    echo ""
    echo "使用方法：查询股票名称"
    echo "示例：贵州茅台股价、腾讯股票、苹果股票"
    echo ""
    echo "支持的股票："
    echo "  A股：贵州茅台、宁德时代、比亚迪、平安银行"
    echo "  港股：腾讯、美团、阿里巴巴、小米"
    echo "  美股：苹果、谷歌、微软、特斯拉、英伟达"
    echo "  指数：上证指数、深证成指、恒生指数"
    return
  fi
  
  local stock_name
  stock_name=$(extract_stock "$input")
  
  if [ -z "$stock_name" ]; then
    echo "❌ 未识别到股票名称"
    echo ""
    echo "支持的格式："
    echo "  - 贵州茅台股价"
    echo "  - 腾讯股票"
    echo "  - 苹果股票"
    echo "  - 上证指数"
    return
  fi
  
  local stock_code="${STOCK_CODES[$stock_name]}"
  
  echo "🔍 正在查询 $stock_name ..."
  echo ""
  
  if [[ "$stock_code" =~ ^sh ]] || [[ "$stock_code" =~ ^sz ]]; then
    local response
    response=$(get_stock_data "$stock_code")
    parse_ashare "$response" "$stock_name"
  elif [[ "$stock_code" =~ ^hk ]]; then
    local response
    response=$(get_stock_data "$stock_code")
    parse_hkstock "$response" "$stock_name"
  else
    local response
    response=$(get_stock_data "$stock_code")
    parse_usstock "$response" "$stock_name"
  fi
}

main "$@"
