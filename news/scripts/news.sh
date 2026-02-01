#!/usr/bin/env bash
# 新闻资讯脚本

set -e

# 检测新闻类型
detect_news_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "科技|数码|互联网|AI|手机|电脑"; then
    echo "tech"
  elif echo "$text" | grep -qiE "财经|股票|金融|经济|投资"; then
    echo "finance"
  elif echo "$text" | grep -qiE "体育|足球|篮球|世界杯|奥运"; then
    echo "sports"
  elif echo "$text" | grep -qiE "娱乐|影视|明星|八卦|综艺"; then
    echo "entertainment"
  elif echo "$text" | grep -qiE "热搜|热榜|榜|趋势"; then
    echo "hot"
  elif echo "$text" | grep -qiE "今日|头条|新闻|最新"; then
    echo "headline"
  else
    echo "headline"
  fi
}

# 获取今日头条新闻
get_headline_news() {
  echo "📰 今日头条"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API Key 可获取实时新闻"
  echo ""
  echo "示例新闻标题："
  echo "1. 习近平会见美国总统"
  echo "2. A股三大指数全线上涨"
  echo "3. iPhone 17 全新设计曝光"
  echo "4. 2026世界杯预选赛最新进展"
  echo "5. 人工智能成两会热点话题"
  echo ""
  echo "📱 配置 API 后可获取实时新闻流"
}

# 获取科技新闻
get_tech_news() {
  echo "💻 科技新闻"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API Key 可获取实时科技资讯"
  echo ""
  echo "示例科技资讯："
  echo "1. OpenAI 发布 GPT-5 预览版"
  echo "2. 苹果 Apple Car 预计2027年量产"
  echo "3. 特斯拉全自动驾驶 FSD V13 发布"
  echo "4. 小米汽车 SU7 销量突破 10 万台"
  echo "5. 华为 Mate 70 搭载纯血鸿蒙"
  echo ""
  echo "📱 配置 API 后可获取实时科技新闻"
}

# 获取财经资讯
get_finance_news() {
  echo "📈 财经资讯"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API Key 可获取实时财经数据"
  echo ""
  echo "示例财经资讯："
  echo "1. 沪指突破 3500 点创年内新高"
  echo "2. 美联储暗示降息周期开启"
  echo "3. 比特币突破 10 万美元大关"
  echo "4. 中国 GDP 增速符合市场预期"
  echo "5. 央行下调 LPR 利率 25 个基点"
  echo ""
  echo "📱 配置 API 后可获取实时财经新闻"
}

# 获取热搜榜单
get_hot_search() {
  echo "🔥 热搜榜单"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API Key 可获取实时热搜"
  echo ""
  echo "今日热搜（示例）："
  echo ""
  echo "📱 微博热搜："
  echo "1. #春节档电影票房破纪录#"
  echo "2. #某顶流恋情曝光#"
  echo "3. #演唱会门票秒罄#"
  echo ""
  echo "📖 知乎热榜："
  echo "1. 2026 年有哪些值得关注的科技趋势？"
  echo "2. 为什么年轻人都不爱换手机了？"
  echo "3. 月入 3 万是什么体验？"
  echo ""
  echo "📱 配置 API 后可获取实时热搜数据"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "📰 新闻资讯"
    echo ""
    echo "使用方法：查询新闻类型"
    echo "示例："
    echo "  今天的新闻"
    echo "  科技新闻"
    echo "  财经资讯"
    echo "  有什么热点"
    echo "  微博热搜"
    echo ""
    echo "支持的查询："
    echo "  - 今日新闻 / 头条新闻"
    echo "  - 科技新闻 / 数码资讯"
    echo "  - 财经资讯 / 股市新闻"
    echo "  - 体育新闻 / 娱乐新闻"
    echo "  - 热搜 / 热榜 / 趋势"
    return
  fi
  
  local news_type
  news_type=$(detect_news_type "$input")
  
  echo "🔍 正在获取新闻..."
  echo ""
  
  case "$news_type" in
    "tech")
      get_tech_news
      ;;
    "finance")
      get_finance_news
      ;;
    "sports")
      echo "🏀 体育新闻"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时体育资讯"
      ;;
    "entertainment")
      echo "🎬 娱乐新闻"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时娱乐资讯"
      ;;
    "hot")
      get_hot_search
      ;;
    *)
      get_headline_news
      ;;
  esac
}

main "$@"
