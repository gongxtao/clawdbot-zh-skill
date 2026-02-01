# 🚀 Clawdbot 中文技能市场

![Clawdbot](https://img.shields.io/badge/Clawdbot-AI%20Assistant-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

中文技能市场 for Clawdbot / OpenClaw / Moltbot，提供常用中文场景技能。

## 📦 技能列表

### 1. 📦 快递查询 (express)
查询国内主流快递物流信息。

**功能：**
- 支持顺丰、申通、圆通、中通、韵达、京东、德邦等
- 自动识别快递公司
- 查询最新物流状态

**使用：**
```bash
clawdbot express "查询快递单号 SF1234567890"
clawdbot express "我的顺丰快递到哪了"
```

### 2. 🌤️ 天气查询 (天气)
查询中国城市天气预报。

**功能：**
- 支持 20+ 城市
- 3 天天气预报
- 温度、天气状况、风力

**使用：**
```bash
clawdbot weather "北京今天天气"
clawdbot weather "上海明天天气"
clawdbot weather "广州后天天气"
```

**配置 API Key（可选）：**
```bash
mkdir -p ~/.config/weather
echo "YOUR_API_KEY" > ~/.config/weather/api_key
```

### 3. 📈 股票查询 (stock)
查询 A 股/港股/美股实时行情。

**功能：**
- 支持贵州茅台、腾讯、苹果等常用股票
- 支持上证指数、深证成指等指数
- 实时价格、涨跌信息

**使用：**
```bash
clawdbot stock "贵州茅台股价"
clawdbot stock "腾讯股票"
clawdbot stock "苹果股票价格"
```

## 📥 安装方法

### 方法一：一键安装

```bash
git clone https://github.com/gongxtao/clawdbot-zh-skill.git
cd clawdbot-zh-skill
./install.sh
```

### 方法二：手动安装

```bash
# 创建技能目录
mkdir -p ~/.clawdbot/skills

# 复制技能文件夹
cp -r express weather stock ~/.clawdbot/skills/

# 重启 Clawdbot
clawdbot gateway restart
```

## 🛠️ 技能开发

### 技能结构

```
skill-name/
├── SKILL.md           # 技能定义文件（必需）
└── scripts/
    └── skill-name.sh  # 技能脚本（必需）
```

### SKILL.md 格式

```yaml
---
name: skill-name
description: "技能描述，用中文说明功能和使用方法"
metadata: {"clawdbot":{"emoji":"📦"}}
---

# 技能名称

## 使用方法

直接用自然语言查询：
```
"查询 XXX"
```

## API 说明

使用 XXX API...
```

### 脚本要求

- 使用 Bash 脚本
- 支持命令行参数
- 输出清晰的文本结果
- 错误时返回友好提示

## 🤝 贡献

欢迎贡献新技能！

1. Fork 本仓库
2. 创建新技能文件夹
3. 提交 PR

## 📝 更新日志

**v1.0.0 (2026-02-01)**
- ✨ 初始版本
- 📦 快递查询技能
- 🌤️ 天气查询技能  
- 📈 股票查询技能

## 📄 License

MIT License
