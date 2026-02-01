#!/usr/bin/env bash
# 黄金价格查询脚本

set -e

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '国际金价|现货黄金|伦敦金'; then
    echo "international"
  elif echo "$text" | grep -qiE 'AU9999|金条|9999'; then
    echo "gold9999"
  elif echo "$text" | grep -qiE '首饰|金饰|999'; then
    echo "jewelry"
  elif echo "$text" | grep -qiE '涨|跌|走势'; then
    echo "trend"
  else
    echo "price"
  fi
}

# 提取金额
extract_amount() {
  local text="$1"
  echo "$text" | grep -oE '[0-9.]+' | head -1
}

# 查询金价
query_gold_price() {
  local type="$1"
  
  echo "🥇 黄金价格查询"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置金价 API 可获取实时数据"
  echo ""
  
  case "$type" in
    "gold9999")
      echo "📍 AU9999 金条"
      echo "─────────────"
      echo "  💰 价格：约 620 元/克"
      echo "  📈 涨跌：+1.2% (+7.3元)"
      echo "  📊 今日最高：625 元/克"
      echo "  📊 今日最低：615 元/克"
      ;;
    "international")
      echo "🌍 国际金价"
      echo "─────────────"
      echo "  💰 价格：约 \$2,050 美元/盎司"
      echo "  📈 涨跌：+0.8% (+16美元)"
      echo "  📊 今日最高：\$2,060"
      echo "  📊 今日最低：\$2,040"
      ;;
    "jewelry")
      echo "💍 黄金首饰"
      echo "─────────────"
      echo "  💰 价格：约 680 元/克（零售）"
      echo "  📝 包含工费，不同品牌差异大"
      echo "  📍 周大福：约 686 元/克"
      echo "  📍 老凤祥：约 682 元/克"
      echo "  📍 周生生：约 685 元/克"
      ;;
    "price"|*)
      echo "📊 黄金价格概览"
      echo "─────────────"
      echo ""
      echo "  🇨🇳 AU9999金条：约 620 元/克"
      echo "  🌍 国际金价：约 \$2,050/盎司"
      echo "  💍 黄金首饰：约 680 元/克"
      echo ""
      echo "  💡 投资建议："
      echo "     - 金条适合长期投资"
      echo "     - 首饰含工费，溢价高"
      echo "     - 关注国际金价走势"
      ;;
  esac
  
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时金价更新"
  echo "  - 历史价格走势"
  echo "  - 价格提醒设置"
}

# 查询趋势
query_gold_trend() {
  echo "📈 黄金价格趋势"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取详细趋势分析"
  echo ""
  echo "示例趋势（模拟）："
  echo ""
  echo "  📊 近7日走势：📈 +2.5%"
  echo "  📊 近30日走势：📈 +5.8%"
  echo "  📊 近90日走势：📈 +12.3%"
  echo ""
  echo "  💡 影响因素："
  echo "     - 美元汇率"
  echo "     - 地缘政治"
  echo "     - 通胀预期"
  echo "     - 央行购金"
  echo ""
  echo "⚠️  黄金有风险，投资需谨慎"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    input="今天金价多少"
  fi
  
  local query_type
  
  query_type=$(detect_type "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "trend")
      query_gold_trend
      ;;
    *)
      query_gold_price "$query_type"
      ;;
  esac
}

main "$@"
