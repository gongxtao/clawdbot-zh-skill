#!/usr/bin/env bash
# 热搜榜单脚本

set -e

# 检测热搜平台
detect_platform() {
  local text="$1"
  
  if echo "$text" | grep -qiE "微博|weibo"; then
    echo "weibo"
  elif echo "$text" | grep -qiE "知乎|zhiHu|zhihu"; then
    echo "zhihu"
  elif echo "$text" | grep -qiE "抖音|tiktok|抖音热"; then
    echo "douyin"
  elif echo "$text" | grep -qiE "B站|b站|bilibili|Bilibili"; then
    echo "bilibili"
  elif echo "$text" | grep -qiE "小红书|RED"; then
    echo "xiaohongshu"
  elif echo "$text" | grep -qiE "百度|baidu"; then
    echo "baidu"
  elif echo "$text" | grep -qiE "热搜|热榜|热门|hot"; then
    echo "hot"
  else
    echo "hot"
  fi
}

# 微博热搜
show_weibo_hot() {
  echo "🔥 微博热搜榜"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "示例热搜（模拟）："
  echo ""
  echo "  1. #春节档电影票房破纪录#"
  echo "  2. #某顶流恋情曝光#"
  echo "  3. #演唱会门票秒罄#"
  echo "  4. #新能源汽车销量新高#"
  echo "  5. #AI技术新突破#"
  echo "  6. #某明星捐款上热搜#"
  echo "  7. #世界杯预选赛#"
  echo "  8. #高考改革新政策#"
  echo "  9. #某品牌道歉#"
  echo " 10. #天气预警#"
  echo ""
  echo "📱 配置 API 后可获取实时热搜"
}

# 知乎热榜
show_zhihu_hot() {
  echo "💬 知乎热榜"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "示例热榜（模拟）："
  echo ""
  echo "  1. 2026 年有哪些值得关注的科技趋势？"
  echo "  2. 为什么年轻人都不爱换手机了？"
  echo "  3. 月入 3 万是什么体验？"
  echo "  4. 如何看待 AI 写作？"
  echo "  5. 哪些能力是工作中最重要的？"
  echo "  6. 如何看待延迟退休？"
  echo "  7. 相亲市场到底有多卷？"
  echo "  8. 存多少钱才能躺平？"
  echo "  9. 哪些专业毕业即失业？"
  echo " 10. 为什么创业成功率这么低？"
  echo ""
  echo "📱 配置 API 后可获取实时热榜"
}

# 抖音热搜
show_douyin_hot() {
  echo "🎵 抖音热搜榜"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "示例热点（模拟）："
  echo ""
  echo "  1. #挑战赛 #OOTD 穿搭挑战"
  echo "  2. #美食 #探店 网红餐厅打卡"
  echo "  3. #萌宠 可爱宠物视频"
  echo "  4. #舞蹈 热门舞蹈教学"
  echo "  5. #搞笑 段子合集"
  echo "  6. #知识 科普短视频"
  echo "  7. #旅行 各地美景"
  echo "  8. #美妆 化妆教程"
  echo ""
  echo "📱 配置 API 后可获取实时热搜"
}

# B站热门
show_bilibili_hot() {
  echo "📺 B站热门榜"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "示例热门（模拟）："
  echo ""
  echo "  1. 【播放 1000万】年度神作合集"
  echo "  2. 【播放 800万】某UP主最新视频"
  echo "  3. 【播放 500万】搞笑剪辑"
  echo "  4. 【播放 300万】知识科普"
  echo "  5. 【播放 200万】美食探店"
  echo "  6. 【播放 150万】游戏解说"
  echo "  7. 【播放 100万】舞蹈翻跳"
  echo "  8. 【播放 80万】 数码评测"
  echo ""
  echo "📱 配置 API 后可获取实时热门"
}

# 通用热搜
show_general_hot() {
  echo "🔥 全网热搜榜"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时数据"
  echo ""
  echo "综合各平台热门（模拟）："
  echo ""
  echo "  📱 微博："
  echo "    - #春节档电影票房破纪录#"
  echo ""
  echo "  💬 知乎："
  echo "    - 2026 年有哪些值得关注的科技趋势？"
  echo ""
  echo "  🎵 抖音："
  echo "    - #挑战赛 穿搭挑战"
  echo ""
  echo "  📺 B站："
  echo "    - 【播放 1000万】年度神作合集"
  echo ""
  echo "📱 配置 API 后可获取实时热搜"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🔥 热搜榜单"
    echo ""
    echo "使用方法：查询热搜平台"
    echo "示例："
    echo "  微博热搜"
    echo "  知乎热榜"
    echo "  抖音热搜"
    echo "  B站热门"
    echo "  有什么热点"
    echo ""
    echo "支持的平台："
    echo "  - 微博 / 知乎 / 抖音 / B站"
    echo "  - 小红书 / 百度热搜"
    return
  fi
  
  local platform
  platform=$(detect_platform "$input")
  
  echo "🔍 正在获取热搜..."
  echo ""
  
  case "$platform" in
    "weibo")
      show_weibo_hot
      ;;
    "zhihu")
      show_zhihu_hot
      ;;
    "douyin")
      show_douyin_hot
      ;;
    "bilibili")
      show_bilibili_hot
      ;;
    "xiaohongshu")
      echo "📕 小红书热门"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时热门"
      ;;
    "baidu")
      echo "🔍 百度热搜"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时热搜"
      ;;
    *)
      show_general_hot
      ;;
  esac
}

main "$@"
