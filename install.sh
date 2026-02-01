#!/usr/bin/env bash
# 中文技能市场一键安装脚本

set -e

echo "🚀 Clawdbot 中文技能市场 - 一键安装"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 检查 Clawdbot 是否安装
if ! command -v clawdbot &> /dev/null; then
  echo "⚠️  未检测到 Clawdbot，请先安装："
  echo "   npm install -g clawdbot@latest"
  exit 1
fi

# 创建技能目录
SKILLS_DIR="$HOME/.clawdbot/skills"
mkdir -p "$SKILLS_DIR"

echo "📁 技能安装目录：$SKILLS_DIR"
echo ""

# 安装技能
echo "📦 正在安装技能..."

for skill in express weather stock; do
  if [ -d "$skill" ]; then
    cp -r "$skill" "$SKILLS_DIR/"
    echo "  ✅ $skill 安装完成"
  fi
done

echo ""
echo "✨ 安装完成！"
echo ""
echo "📖 使用方法："
echo "   clawdbot agent \"查询快递单号 SF1234567890\""
echo "   clawdbot agent \"北京今天天气\""
echo "   clawdbot agent \"贵州茅台股价\""
echo ""
echo "🔧 如需重新加载技能，请重启 Clawdbot："
echo "   clawdbot gateway restart"
echo ""
