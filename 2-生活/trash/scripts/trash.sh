#!/usr/bin/env bash
# 垃圾分类查询脚本

set -e

# 垃圾分类数据
declare -A TRASH_CATEGORIES=(
  # 可回收物
  ["纸箱"]="可回收物"
  ["报纸"]="可回收物"
  ["书本"]="可回收物"
  ["塑料瓶"]="可回收物"
  ["易拉罐"]="可回收物"
  ["玻璃瓶"]="可回收物"
  ["旧衣服"]="可回收物"
  ["金属"]="可回收物"
  ["塑料袋"]="可回收物"
  
  # 有害垃圾
  ["电池"]="有害垃圾"
  ["废电池"]="有害垃圾"
  ["灯管"]="有害垃圾"
  ["荧光灯"]="有害垃圾"
  ["药品"]="有害垃圾"
  ["过期药品"]="有害垃圾"
  ["油漆"]="有害垃圾"
  ["杀虫剂"]="有害垃圾"
  ["化妆品"]="有害垃圾"
  
  # 厨余垃圾
  ["剩菜"]="厨余垃圾"
  ["剩饭"]="厨余垃圾"
  ["果皮"]="厨余垃圾"
  ["果核"]="厨余垃圾"
  ["蛋壳"]="厨余垃圾"
  ["茶渣"]="厨余垃圾"
  ["咖啡渣"]="厨余垃圾"
  ["菜叶"]="厨余垃圾"
  
  # 其他垃圾
  ["卫生纸"]="其他垃圾"
  ["纸尿裤"]="其他垃圾"
  ["烟蒂"]="其他垃圾"
  ["污损塑料"]="其他垃圾"
  ["一次性餐具"]="其他垃圾"
  ["外卖盒"]="其他垃圾"
  ["吸管"]="其他垃圾"
)

# 提取查询物品
extract_item() {
  local text="$1"
  # 移除"是什么垃圾"、"怎么分类"、"怎么处理"等
  echo "$text" | sed -E 's/是什么垃圾|怎么分类|怎么处理|是什么类别|属于哪类//g' | xargs
}

# 检测查询类型
detect_type() {
  local text="$1"
  
  if echo "$text" | grep -qiE '怎么分类|如何分类|丢哪个|扔哪个|放哪个'; then
    echo "howto"
  elif echo "$text" | grep -qiE '怎么处理|怎么扔|怎么丢'; then
    echo "dispose"
  else
    echo "query"
  fi
}

# 查询垃圾分类
query_trash() {
  local item="$1"
  
  echo "♻️ 垃圾分类查询：$item"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  local found=0
  for key in "${!TRASH_CATEGORIES[@]}"; do
    if echo "$item" | grep -qiE "$key"; then
      local category="${TRASH_CATEGORIES[$key]}"
      
      # 分类图标
      local icon
      case "$category" in
        "可回收物") icon="🔵" ;;
        "有害垃圾") icon="🔴" ;;
        "厨余垃圾") icon="🟢" ;;
        "其他垃圾") icon="⚫" ;;
      esac
      
      echo "  $icon $category"
      echo ""
      echo "💡 投放提示："
      case "$category" in
        "可回收物")
          echo "  - 清洗干净后投放"
          echo "  - 压扁以减少体积"
          echo "  - 尽量保持完整"
          ;;
        "有害垃圾")
          echo "  - 保持完整，不要随意丢弃"
          echo "  - 放入专用容器"
          echo "  - 社区有害垃圾收集点"
          ;;
        "厨余垃圾")
          echo "  - 沥干水分后投放"
          echo "  - 单独袋装，不要混合"
          echo "  - 厨余垃圾专用桶"
          ;;
        "其他垃圾")
          echo "  - 放入其他垃圾专用桶"
          echo "  - 尽量沥干水分"
          echo "  - 密封处理"
          ;;
      esac
      echo ""
      found=1
      break
    fi
  done
  
  if [ $found -eq 0 ]; then
    echo "❌ 未找到 '$item' 的分类信息"
    echo ""
    echo "💡 常见物品分类参考："
    echo ""
    echo "  🔵 可回收物：纸箱、塑料瓶、易拉罐、玻璃瓶、旧衣服"
    echo "  🔴 有害垃圾：电池、灯管、过期药品、油漆"
    echo "  🟢 厨余垃圾：剩菜、果皮、蛋壳、茶渣"
    echo "  ⚫ 其他垃圾：卫生纸、外卖盒、烟蒂"
    echo ""
    echo "📱 建议：可使用'垃圾分类'小程序查询更准确"
  fi
}

# 如何分类
howto_trash() {
  local item="$1"
  
  echo "♻️ 如何分类：$item"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  echo "💡 分类步骤："
  echo ""
  echo "  1. 判断是否为可回收物（纸/塑/金/玻/织）"
  echo "     → 是 → 清洗干净 → 投入可回收物桶"
  echo ""
  echo "  2. 判断是否是有害垃圾（废电/废灯/废药/废油）"
  echo "     → 是 → 保持完整 → 投入有害垃圾桶"
  echo ""
  echo "  3. 判断是否为厨余垃圾（剩菜/果皮/蛋壳）"
  echo "     → 是 → 沥干水分 → 投入厨余垃圾桶"
  echo ""
  echo "  4. 以上都不是 → 其他垃圾"
  echo ""
  echo "📱 配置完整数据库后可精确匹配"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "♻️ 垃圾分类查询"
    echo ""
    echo "使用方法：查询垃圾分类"
    echo "示例："
    echo "  电池是什么垃圾"
    echo "  外卖盒怎么分类"
    echo "  过期药品怎么处理"
    echo "  快递纸箱是什么垃圾"
    echo ""
    echo "支持的分类："
    echo "  🔵 可回收物：纸箱、塑料瓶、易拉罐、玻璃瓶"
    echo "  🔴 有害垃圾：电池、灯管、过期药品、油漆"
    echo "  🟢 厨余垃圾：剩菜、果皮、蛋壳、茶渣"
    echo "  ⚫ 其他垃圾：卫生纸、外卖盒、烟蒂"
    return
  fi
  
  local item query_type
  
  item=$(extract_item "$input")
  query_type=$(detect_type "$input")
  
  if [ -z "$item" ]; then
    echo "❌ 未识别到查询物品"
    echo ""
    echo "示例："
    echo "  电池是什么垃圾"
    echo "  外卖盒怎么分类"
    return
  fi
  
  case "$query_type" in
    "howto"|"dispose")
      howto_trash "$item"
      ;;
    *)
      query_trash "$item"
      ;;
  esac
}

main "$@"
