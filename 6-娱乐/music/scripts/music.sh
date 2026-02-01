#!/usr/bin/env bash
# 音乐播放脚本

set -e

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "播放|放.*歌"; then
    echo "play"
  elif echo "$text" | grep -qiE "搜索|找.*歌|点歌"; then
    echo "search"
  elif echo "$text" | grep -qiE "歌单|推荐|热门"; then
    echo "playlist"
  elif echo "$text" | grep -qiE "暂停|停止|继续"; then
    echo "control"
  elif echo "$text" | grep -qiE "喜欢|收藏|我的"; then
    echo "favorite"
  elif echo "$text" | grep -qiE "列表|播放列表"; then
    echo "list"
  else
    echo "play"
  fi
}

# 提取歌曲名
extract_song_name() {
  local text="$1"
  echo "$text" | sed -E 's/播放|搜索|找|点//g' | sed 's/的//g' | xargs
}

# 提取歌手名
extract_artist_name() {
  local text="$1"
  # 简单提取"XXX的YYY"中的XXX
  echo "$text" | grep -oE '.*的' | sed 's/的$//' | xargs
}

# 播放歌曲
play_song() {
  local song="$1" artist="$2"
  
  echo "🎵 正在播放"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  if [ -n "$song" ]; then
    echo "🎤 歌曲：$song"
    [ -n "$artist" ] && echo "👤 歌手：$artist"
  else
    echo "💡 提示：配置网易云音乐 API 可播放歌曲"
  fi
  echo ""
  
  echo "示例播放（模拟）："
  echo ""
  echo "  🎵 稻香 - 周杰伦"
  echo "  ─────────────────"
  echo "  ⏱️  时长：3分45秒"
  echo "  📀  专辑：依然范特西"
  echo "  🔊  状态：▶️ 正在播放"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 播放/暂停控制"
  echo "  - 上一首/下一首"
  echo "  - 歌词显示"
  echo "  - 收藏歌曲"
}

# 搜索歌曲
search_song() {
  local keyword="$1"
  
  echo "🔍 搜索结果：$keyword"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置网易云音乐 API 可获取实时搜索"
  echo ""
  echo "示例搜索结果（模拟）："
  echo ""
  printf "%-4s %-25s %-15s %s\n" "序号" "歌曲名称" "歌手" "时长"
  printf "%-4s %-25s %-15s %s\n" "━━━━" "━━━━━━━━━━━━━━━" "━━━━━━━━━━" "━━━━"
  printf "%-4s %-25s %-15s %s\n" "1" "稻香" "周杰伦" "3:45"
  printf "%-4s %-25s %-15s %s\n" "2" "稻香 (伴奏)" "周杰伦" "3:42"
  printf "%-4s %-25s %-15s %s\n" "3" "稻香 (Live)" "周杰伦" "4:12"
  printf "%-4s %-25s %-15s %s\n" "4" "稻香" "群星" "3:45"
  printf "%-4s %-25s %-15s %s\n" "5" "稻香" "的小朋友" "2:30"
  echo ""
  echo "💡 输入序号播放：'播放第1首'"
}

# 歌单推荐
query_playlist() {
  echo "📻 热门歌单推荐"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：配置 API 可获取实时歌单"
  echo ""
  echo "网易云热门歌单（模拟）："
  echo ""
  echo "  🔥 热歌榜 TOP 50"
  echo "     播放量：2.3亿"
  echo "     包含：周杰伦、陈奕迅、林俊杰..."
  echo ""
  echo "  💕 私人推荐歌单"
  echo "     播放量：1.2亿"
  echo "     根据听歌口味定制"
  echo ""
  echo "  🎸 摇滚经典"
  echo "     播放量：8500万"
  echo "     痛仰、逃跑计划、新裤子..."
  echo ""
  echo "  🎹 纯音乐推荐"
  echo "     播放量：6200万"
  echo "     钢琴、吉他、轻音乐..."
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 播放整个歌单"
  echo "  - 收藏歌单"
  echo "  - 分享歌单"
}

# 播放控制
control_player() {
  local action="$1"
  
  echo "🎛️ 播放控制"
  echo "━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  case "$action" in
    "暂停")
      echo "⏸️ 已暂停播放"
      ;;
    "继续")
      echo "▶️ 继续播放"
      ;;
    "停止")
      echo "⏹️ 已停止播放"
      ;;
    *)
      echo "💡 支持的控制命令："
      echo "  - 暂停播放"
      echo "  - 继续播放"
      echo "  - 停止播放"
      ;;
  esac
  
  echo ""
  echo "📱 配置 API 后可控制："
  echo "  - 播放/暂停"
  echo "  - 上一首/下一首"
  echo "  - 调节音量"
  echo "  - 播放模式（循环/随机）"
}

# 我的喜欢
query_favorite() {
  echo "❤️ 我喜欢的音乐"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 提示：登录网易云账号可同步喜欢"
  echo ""
  echo "示例数据（模拟）："
  echo ""
  echo "  累计收藏：512 首歌曲"
  echo "  本周新增：12 首"
  echo ""
  echo "  最近播放："
  echo "  1. 稻香 - 周杰伦"
  echo "  2. 平凡之路 - 朴树"
  echo "  3. 起风了 - 买辣椒也用券"
  echo ""
  echo "  心动模式：🎵 ON"
  echo "  随机播放喜欢的音乐"
  echo ""
  echo "📱 配置 API 后可："
  echo "  - 查看喜欢列表"
  echo "  - 取消收藏"
  echo "  - 播放历史"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🎵 音乐播放"
    echo ""
    echo "使用方法：控制音乐播放"
    echo "示例："
    echo "  播放周杰伦的稻香"
    echo "  搜索稻香"
    echo "  网易云热门歌单"
    echo "  暂停播放"
    echo "  我喜欢的音乐"
    echo ""
    echo "支持的功能："
    echo "  - 歌曲搜索"
    echo "  - 播放控制"
    echo "  - 歌单推荐"
    echo "  - 我的收藏"
    return
  fi
  
  local query_type song artist
  
  query_type=$(detect_query_type "$input")
  song=$(extract_song_name "$input")
  
  echo "🔍 正在处理..."
  echo ""
  
  case "$query_type" in
    "play")
      play_song "$song" ""
      ;;
    "search")
      search_song "$song"
      ;;
    "playlist")
      query_playlist
      ;;
    "control")
      if echo "$input" | grep -qi "暂停"; then
        control_player "暂停"
      elif echo "$input" | grep -qi "继续"; then
        control_player "继续"
      elif echo "$input" | grep -qi "停止"; then
        control_player "停止"
      else
        control_player ""
      fi
      ;;
    "favorite")
      query_favorite
      ;;
    "list")
      echo "📋 播放列表"
      echo "━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "💡 配置 API 后可查看当前播放列表"
      ;;
  esac
}

main "$@"
