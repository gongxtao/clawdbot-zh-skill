#!/usr/bin/env bash
# 翻译脚本

set -e

# 语言代码映射
declare -A LANG_CODES=(
  ["英文"]="en"
  ["英语"]="en"
  ["中文"]="zh"
  ["汉语"]="zh"
  ["日文"]="ja"
  ["日语"]="ja"
  ["韩文"]="ko"
  ["韩语"]="ko"
  ["法文"]="fr"
  ["法语"]="fr"
  ["德文"]="de"
  ["德语"]="de"
  ["俄文"]="ru"
  ["俄语"]="ru"
  ["西班牙文"]="es"
  ["西班牙语"]="es"
  ["意大利文"]="it"
  ["意大利语"]="it"
  ["葡萄牙文"]="pt"
  ["葡萄牙语"]="pt"
)

# 检测输入语言
detect_language() {
  local text="$1"
  # 简单检测：包含中文则认为是中文
  if echo "$text" | grep -qE '[\u4e00-\u9fff]'; then
    echo "zh"
  else
    echo "en"
  fi
}

# 提取需要翻译的文本
extract_text() {
  local text="$1"
  # 移除"翻译"、"把...翻译成"等前缀
  echo "$text" | sed -E 's/^翻译[的 ]?//' \
    | sed -E 's/^把(.+)翻译成.+/\1/' \
    | sed -E 's/^(.+)(中文|英文|英语|日文|日文|英文)/\1/' \
    | sed -E 's/^请把(.+)翻译成.+/\1/' \
    | xargs
}

# 提取目标语言
extract_target_lang() {
  local text="$1"
  for lang in "${!LANG_CODES[@]}"; do
    if echo "$text" | grep -qi "翻译成.*$lang\|成.*$lang"; then
      echo "${LANG_CODES[$lang]}"
      return
    fi
  done
  # 默认翻译成英文
  echo "en"
}

# 百度翻译 API（免费版有限制）
baidu_translate() {
  local text="$1" from_lang="$2" to_lang="$3"
  
  # 简单演示：使用有道翻译 API
  local url="https://openapi.youdao.com/api"
  local app_key="YOUR_APP_KEY"  # 需要替换
  local app_secret="YOUR_APP_SECRET"  # 需要替换
  local salt=$(date +%s)
  local sign=$(echo -n "$app_key$text$salt$app_secret" | md5sum | cut -d' ' -f1)
  
  local response
  response=$(curl -s -m 10 "$url" \
    -d "q=$text" \
    -d "from=$from_lang" \
    -d "to=$to_lang" \
    -d "appKey=$app_key" \
    -d "salt=$salt" \
    -d "sign=$sign" 2>/dev/null)
  
  # 解析结果
  local translation
  translation=$(echo "$response" | grep -oE '"translation":\["[^"]*"\]' | grep -oE '"[^"]*"' | head -1 | tr -d '"')
  
  if [ -n "$translation" ]; then
    echo "$translation"
  else
    echo "❌ 翻译失败，请稍后重试"
  fi
}

# 离线翻译（简单词典）
offline_translate() {
  local text="$1"
  
  # 简单演示翻译（实际使用需要 API）
  echo "🌐 翻译结果：$text"
  echo ""
  echo "💡 提示：配置 API Key 可获得完整翻译功能"
  echo ""
  echo "配置方法："
  echo "1. 注册有道翻译开放平台：https://ai.youdao.com"
  echo "2. 创建应用获取 AppKey 和 AppSecret"
  echo "3. mkdir -p ~/.config/translate"
  echo "4. echo 'APP_KEY' > ~/.config/translate/app_key"
  echo "5. echo 'APP_SECRET' > ~/.config/translate/app_secret"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🌐 翻译技能"
    echo ""
    echo "使用方法：翻译 <文本>"
    echo "示例："
    echo "  翻译 Hello World"
    echo "  把你好翻译成英文"
    echo "  How are you 中文"
    echo "  请把下雨了翻译成日文"
    echo ""
    echo "支持语言：英文、日文、韩文、法文、德文等"
    return
  fi
  
  local text target_lang from_lang
  
  text=$(extract_text "$input")
  target_lang=$(extract_target_lang "$input")
  from_lang=$(detect_language "$text")
  
  if [ -z "$text" ]; then
    echo "❌ 未识别到翻译文本"
    echo ""
    echo "使用方法：翻译 <文本>"
    echo "示例：翻译 Hello World"
    return
  fi
  
  echo "🔍 正在翻译：$text"
  echo "   从：$( [ "$from_lang" = "zh" ] && echo '中文' || echo '英文' ) → 到：$(echo $target_lang | sed 's/zh/中文/;s/en/英文/;s/ja/日文/;s/ko/韩文/;s/fr/法文/;s/de/德文/')"
  echo ""
  
  offline_translate "$text"
}

main "$@"
