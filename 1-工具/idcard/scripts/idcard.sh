#!/usr/bin/bash
# 身份证查询脚本

set -e

# 地区代码映射（部分）
declare -A REGION_CODES=(
  ["110101"]="北京市东城区"
  ["110102"]="北京市西城区"
  ["110105"]="北京市朝阳区"
  ["110106"]="北京市丰台区"
  ["310101"]="上海市黄浦区"
  ["310104"]="上海市徐汇区"
  ["310105"]="上海市长宁区"
  ["310107"]="上海市普陀区"
  ["440103"]="广州市荔湾区"
  ["440104"]="广州市越秀区"
  ["440105"]="广州市海珠区"
  ["330102"]="杭州市上城区"
  ["330103"]="杭州市拱墅区"
  ["330104"]="杭州市西湖区"
  ["510104"]="成都市锦江区"
  ["510105"]="成都市青羊区"
  ["510106"]="成都市金牛区"
  ["420102"]="武汉市江岸区"
  ["420104"]="武汉市硚口区"
  ["320102"]="南京市玄武区"
  ["320104"]="南京市秦淮区"
  ["610102"]="西安市新城区"
  ["610103"]="西安市碑林区"
  ["500102"]="重庆市渝中区"
  ["120101"]="天津市和平区"
  ["120102"]="天津市河东区"
)

# 提取身份证号
extract_id() {
  local text="$1"
  echo "$text" | grep -oE '[0-9]{15,18}' | head -1
}

# 提取地区代码
extract_region() {
  local id="$1"
  echo "${id:0:6}"
}

# 提取生日
extract_birthday() {
  local id="$1"
  if [ ${#id} -eq 18 ]; then
    echo "${id:6:4}-${id:10:2}-${id:12:2}"
  elif [ ${#id} -eq 15 ]; then
    echo "19${id:6:2}-${id:8:2}-${id:10:2}"
  fi
}

# 判断性别
get_gender() {
  local id="$1"
  if [ ${#id} -eq 18 ]; then
    local last_digit="${id:17:1}"
  elif [ ${#id} -eq 15 ]; then
    local last_digit="${id:14:1}"
  fi
  
  if [ $((last_digit % 2)) -eq 1 ]; then
    echo "男"
  else
    echo "女"
  fi
}

# 校验身份证
validate_id() {
  local id="$1"
  local valid=1
  local message=""
  
  # 检查长度
  if [ ${#id} -ne 18 ] && [ ${#id} -ne 15 ]; then
    valid=0
    message="长度不正确（应为15或18位）"
  fi
  
  # 检查是否全数字（15位）
  if [ ${#id} -eq 15 ]; then
    if ! echo "$id" | grep -qE '^[0-9]+$'; then
      valid=0
      message="应全为数字"
    fi
  fi
  
  # 检查是否全数字或X（18位）
  if [ ${#id} -eq 18 ]; then
    if ! echo "$id" | grep -qE '^[0-9]{17}[0-9Xx]$'; then
      valid=0
      message="格式不正确"
    fi
  fi
  
  if [ $valid -eq 1 ]; then
    echo "valid"
  else
    echo "invalid:$message"
  fi
}

# 查询身份证信息
query_id() {
  local id="$1"
  
  echo "🆔 身份证查询"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📋 号码：$id"
  echo ""
  
  # 校验
  local validation
  validation=$(validate_id "$id")
  
  if [ "$validation" != "valid" ]; then
    echo "❌ $validation"
    echo ""
    echo "💡 请检查身份证号是否正确"
    return
  fi
  
  # 基本信息
  local region_code region birthday gender
  region_code=$(extract_region "$id")
  region="${REGION_CODE[$region_code]:-未知地区}"
  birthday=$(extract_birthday "$id")
  gender=$(get_gender "$id")
  
  echo "✅ 校验通过"
  echo ""
  echo "📍 归属地：$region"
  echo "🎂 出生日期：$birthday"
  echo "👤 性别：$gender"
  echo "📅 龄龄：$(($(date +%Y) - ${birthday:0:4})) 岁"
  echo ""
  echo "💡 提示：此为本地数据库查询，可能不完整"
}

# 主程序
main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "🆔 身份证查询"
    echo ""
    echo "使用方法：查询身份证信息"
    echo "示例："
    echo "  身份证号310101199001011234归属地"
    echo "  123456199001011234是哪里的"
    echo "  身份证校验110101200001011234"
    echo ""
    echo "支持的功能："
    echo "  - 归属地查询"
    echo "  - 生日提取"
    echo "  - 性别判断"
    echo "  - 格式校验"
    return
  fi
  
  local id
  id=$(extract_id "$input")
  
  if [ -z "$id" ]; then
    echo "❌ 未找到身份证号"
    echo ""
    echo "示例格式："
    echo "  15位：310101900101123"
    echo "  18位：310101199001011234"
    return
  fi
  
  query_id "$id"
}

main "$@"
