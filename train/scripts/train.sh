#!/usr/bin/env bash
# 火车票查询脚本

set -e

# 检测查询类型
detect_query_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE "车次|G[0-9]+|D[0-9]+|Z[0-9]+|T[0-9]+|K[0-9]+"; then
    echo "train_number"
  elif echo "$text" | grep -qiE "北京|上海|广州|深圳|杭州|成都|武汉|南京|西安|重庆"; then
    echo "route"
  else
    echo "search"
  fi
}

# 提取出发地和目的地
extract_stations() {
  local text="$1"
  local from=""
  local to=""
  
  # 提取"从X到Y"格式
  if echo "$text" | grep -qiE "从.*到"; then
    from=$(echo "$text" | sed -E 's/从(.+)到.*/\1/' | xargs)
    to=$(echo "$text" | sed -E 's/.*到(.+)/\1/' | xargs | sed 's/的.*//')
  else
    # 找城市名
    for city in 北京 上海 广州 深圳 杭州 成都 武汉 南京 西安 重庆 天津 长沙 青岛 厦门 大连 沈阳 合肥 济南; do
      if echo "$text" | grep -qi "$city"; then
        if [ -z "$from" ]; then
          from="$city"
        else
          to="$city"
        fi
      fi
    done
  fi
  
  echo "$from|$to"
}

# 提取日期
extract_date() {
  local text="$1"
  
  # 检查是否指定日期
  if echo "$text" | grep -qiE "明天|后天|今天|今日"; then
    local offset=0
    if echo "$text" | grep -qi "明天"; then
      offset=1
    elif echo "$text" | grep -qi "后天"; then
      offset=2
    fi
    date -d "+$offset day" +%Y-%m-%d
  elif echo "$text" | grep -qiE "[0-9]{4}-[0-9]{2}-[0-9]{2}"; then
    echo "$text" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}"
  elif echo "$text" | grep -qiE "[0-9]{1,2}月[0-9]{1,2}日"; then
    local month day
    month=$(echo "$text" | grep -oE "[0-9]{1,2}月" | sed 's/月//')
    day=$(echo "$text" | grep -oE "[0-9]{1,2}日" | sed 's/日//')
    echo "$(date +%Y)-$month-$day"
  else
    # 默认今天
    date +%Y-%m-%d
  fi
}

# 提取车次
extract_train_number() {
  local text="$1"
  echo "$text" | grep -oE 'G[0-9]+|D[0-9]+|Z[0-9]+|T[0-9]+|K[0-9]+' | head -1
}

# 按线路查询
query_by_route() {
  local from="$1"
  local to="$2"
  local date="$3"
  
  echo "🚄 火车票查询：$from → $to"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📅 日期：$date"
  echo ""
  echo "💡 提示：配置 12306 API 可获取实时数据"
  echo ""
  echo "示例车次（模拟）："
  echo ""
  echo "  🚄 高铁（G字头）："
  echo "  G1234  $from → $to  08:00 - 12:00  ¥553  二等座：🟢 有票"
  echo "  G5678  $from → $to  10:30 - 14:30  ¥553  二等座：🟡 紧张"
  echo "  G9012  $from → $to  14:00 - 18:00  ¥553  二等座：🔴 售罄"
  echo ""
  echo "  🚅 动车（D字头）："
  echo "  D3456  $from → $to  09:00 - 13:00  ¥409  二等座：🟢 有票"
  echo ""
  echo "  🏃 直达（Z字头）："
  echo "  Z7890  $from → $to  20:00 - 08:00  ¥273  硬卧：🟢 有票"
  echo ""
  echo "  🚂 特快/快速（T/K）："
  echo "  K2345  $from → $to  18:00 - 06:00  ¥197  硬座：🟢 有票"
  echo ""
  echo "📱 配置 API 后可获取："
  echo "  - 实时余票"
  echo "  - 精确票价"
  echo "  - 候补购票"
  echo "  - 退改签信息"
}

# 按车次查询
query_by_number() {
  local train_num="$1"
  
  echo "🚄 车次查询：$train_num"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "💡 提示：配置 API 可获取实时时刻表和余票"
  echo ""
  echo "示例信息（模拟）："
  echo ""
  echo "  $train_num 次列车"
  echo ""
  echo "  始发站 → 终到站"
  echo "  运行时长：xx 小时 xx 分钟"
  echo ""
  echo "  主要站点："
  echo "  $from  08:00 发车"
  echo "  $mid1  10:30 到达"
  echo "  $mid2  12:00 到达"
  echo "  $to    14:00 到达"
  echo ""
  echo "📱 配置 API 后可获取完整时刻表和余票"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🚄 火车票查询"
    echo ""
    echo "使用方法：查询火车票信息"
    echo "示例："
    echo "  北京到上海的高铁"
    echo "  明天北京到广州的火车"
    echo "  2026年2月15日上海到深圳"
    echo "  查询车次 G1234"
    echo ""
    echo "支持的查询："
    echo "  - 按线路：北京 → 上海"
    echo "  - 按车次：G1234、D5678"
    echo "  - 按日期：明天、后天、指定日期"
    echo "  - 按类型：高铁、动车、直达"
    return
  fi
  
  local query_type date from to train_num
  
  query_type=$(detect_query_type "$input")
  date=$(extract_date "$input")
  
  case "$query_type" in
    "route")
      local stations
      stations=$(extract_stations "$input")
      from=$(echo "$stations" | cut -d'|' -f1)
      to=$(echo "$stations" | cut -d'|' -f2)
      if [ -n "$from" ] && [ -n "$to" ]; then
        query_by_route "$from" "$to" "$date"
      else
        echo "❌ 未识别出发地和目的地"
        echo "示例：北京到上海的高铁"
      fi
      ;;
    "train_number")
      train_num=$(extract_train_number "$input")
      if [ -n "$train_num" ]; then
        query_by_number "$train_num"
      else
        echo "❌ 未识别到车次"
        echo "示例：G1234、D5678"
      fi
      ;;
    *)
      echo "❓ 未识别查询类型"
      echo ""
      echo "支持的查询："
      echo "  - 北京到上海的高铁"
      echo "  - 明天北京到广州的火车"
      echo "  - G1234 次列车"
      ;;
  esac
}

main "$@"
