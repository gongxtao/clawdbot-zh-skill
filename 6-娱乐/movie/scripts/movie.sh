#!/usr/bin/env bash
# 电影票查询脚本

set -e

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "今天|现在|热映|上映"; then
    echo "showing"
  elif echo "$text" | grep -qiE "场次|票|影院"; then
    echo "ticket"
  elif echo "$text" | grep -qiE "评分|豆瓣|多少分"; then
    echo "rating"
  elif echo "$text" | grep -qiE "即将|待上映|预告"; then
    echo "coming"
  elif echo "$text" | grep -qiE "推荐|好看|值得看"; then
    echo "recommend"
  else
    echo "showing"
  fi
}

# 提取电影名
extract_movie_name() {
  local text="$1"
  # 移除常见前缀
  echo "$text" | sed -E 's/(电影票|场次|评分|推荐|有)//g' | xargs
}

# 热映电影查询
query_showing() {
  echo "🎬 热映电影"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置猫眼/淘票票 API 可获取实时数据"
  echo ""
  echo "当前热映（模拟）："
  echo ""
  printf "%-4s %-20s %-8s %-10s %s\n" "排名" "电影名称" "票房" "评分" "上座率"
  printf "%-4s %-20s %-8s %-10s %s\n" "━━━━" "━━━━━━━━━━━━━━" "━━━━━━" "━━━━━━━━━━" "━━━━━━"
  printf "%-4s %-20s %-8s %-10s %s\n" "1" "流浪地球3" "8.5亿" "9.4⭐" "15.2%"
  printf "%-4s %-20s %-8s %-10s %s\n" "2" "哪吒之魔童降世" "6.2亿" "8.8⭐" "12.8%"
  printf "%-4s %-20s %-8s %-10s %s\n" "3" "唐探1900" "4.8亿" "8.5⭐" "10.5%"
  printf "%-4s %-20s %-8s %-10s %s\n" "4" "熊出没·狂野大陆" "2.1亿" "8.2⭐" "8.3%"
  printf "%-4s %-20s %-8s %-10s %s\n" "5" "封神第二部" "1.8亿" "7.9⭐" "6.5%"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时票房"
  echo "  - 场次信息"
  echo "  - 购票链接"
}

# 场次查询
query_ticket() {
  local movie="$1"
  
  echo "🎫 电影场次查询"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  if [ -n "$movie" ]; then
    echo "📽️ 电影：$movie"
  else
    echo "📽️ 电影：未指定"
  fi
  echo ""
  
  echo "💡 提示：配置 API 可获取实时场次和票价"
  echo ""
  echo "示例场次（模拟）："
  echo ""
  echo "  🏢 XX影院（距您 2.5km）"
  echo "  ─────────────────────────"
  echo "  14:30  💰 35元 🟢 余票充足"
  echo "  16:45  💰 35元 🟢 余票充足"
  echo "  19:00  💰 45元 🟡 余票紧张"
  echo "  21:30  💰 40元 🟢 余票充足"
  echo ""
  echo "  🏢 YY影院（距您 3.2km）"
  echo "  ─────────────────────────"
  echo "  15:00  💰 32元 🟢 余票充足"
  echo "  18:00  💰 38元 🟢 余票充足"
  echo "  20:30  💰 38元 🔴 即将售罄"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时余票"
  echo "  - 选座购票"
  echo "  - 优惠活动"
}

# 评分查询
query_rating() {
  local movie="$1"
  
  echo "⭐ 电影评分查询"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  if [ -n "$movie" ]; then
    echo "📽️ 电影：$movie"
  else
    echo "📽️ 电影：未指定"
  fi
  echo ""
  
  echo "💡 提示：配置 API 可获取实时评分"
  echo ""
  echo "示例评分（模拟）："
  echo ""
  echo "  🏆 豆瓣评分：9.4/10"
  echo "  🎬 猫眼评分：9.6/10"
  echo "  ⭐ 淘票票评分：9.3/10"
  echo "  👥 想看人数：128万"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时评分"
  echo "  - 口碑趋势"
  echo "  - 观众短评"
}

# 即将上映
query_coming() {
  echo "🎬 即将上映"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取即将上映电影"
  echo ""
  echo "即将上映（模拟）："
  echo ""
  printf "%-4s %-20s %-15s %s\n" "日期" "电影名称" "类型" "期待值"
  printf "%-4s %-20s %-15s %s\n" "━━━━" "━━━━━━━━━━━━━━" "━━━━━━━━━━━━━━" "━━━━━━"
  printf "%-4s %-20s %-15s %s\n" "02-14" "情人节特辑" "爱情" "🔥 9.2万"
  printf "%-4s %-20s %-15s %s\n" "02-21" "X战警重启" "动作" "🔥 8.5万"
  printf "%-4s %-20s %-15s %s\n" "03-01" "超能陆战队2" "动画" "🔥 7.8万"
  printf "%-4s %-20s %-15s %s\n" "03-15" "哥斯拉大战金刚2" "科幻" "🔥 6.9万"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 精确上映日期"
  echo "  - 预售票房"
  echo "  - 预告片"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🎬 电影票查询"
    echo ""
    echo "使用方法：查询电影信息"
    echo "示例："
    echo "  今天有什么电影"
    echo "  北京电影票"
    echo "  流浪地球3场次"
    echo "  最近评分高的电影"
    echo ""
    echo "支持的查询："
    echo "  - 热映电影"
    echo "  - 场次查询"
    echo "  - 评分查询"
    echo "  - 即将上映"
    return
  fi
  
  local query_type movie_name
  
  query_type=$(detect_query_type "$input")
  movie_name=$(extract_movie_name "$input")
  
  echo "🔍 正在查询..."
  echo ""
  
  case "$query_type" in
    "showing")
      query_showing
      ;;
    "ticket")
      query_ticket "$movie_name"
      ;;
    "rating")
      query_rating "$movie_name"
      ;;
    "coming")
      query_coming
      ;;
    "recommend")
      echo "🎬 电影推荐"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可获取实时推荐"
      echo ""
      echo "热门推荐（模拟）："
      echo ""
      echo "  🌟 本周必看："
      echo "     1. 流浪地球3 - 科幻巨制"
      echo "     2. 哪吒之魔童降世 - 国漫巅峰"
      echo "     3. 唐探1900 - 悬疑喜剧"
      echo ""
      echo "  🎬 口碑佳作："
      echo "     1. 豆瓣9分以上电影合集"
      echo "     2. 冷门但好看的电影"
      echo "     3. 经典重映"
      ;;
  esac
}

main "$@"
