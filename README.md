# 🚀 Clawdbot 中文技能市场

![Clawdbot](https://img.shields.io/badge/Clawdbot-AI%20Assistant-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Skills](https://img.shields.io/badge/Skills-8-blue?style=for-the-badge)

中文技能市场 for Clawdbot / OpenClaw / Moltbot，提供常用中文场景技能。

## 📦 技能列表（8个核心技能）

### 🏠 生活服务

| 技能 | 状态 | 说明 |
|------|------|------|
| 🌤️ 天气查询 | ✅ | 3天天气预报、空气质量 |
| 📦 快递查询 | ✅ | 主流快递自动识别 |
| 🗺️ 地图定位 | 🔄 开发中 | 周边搜索、导航 |

### 💰 金融理财

| 技能 | 状态 | 说明 |
|------|------|------|
| 📈 股票查询 | ✅ | A股/港股/美股/指数 |
| 💱 汇率查询 | 🔄 开发中 | 实时汇率、换算 |
| ₿ 加密货币 | 🔄 开发中 | BTC/ETH 实时价格 |

### 📰 新闻资讯

| 技能 | 状态 | 说明 |
|------|------|------|
| 📰 今日新闻 | ✅ | 头条新闻、热点资讯 |
| 🔥 热搜榜单 | ✅ | 微博/知乎/抖音/B站 |

### 🛠️ 工具效率

| 技能 | 状态 | 说明 |
|------|------|------|
| 🌐 翻译 | ✅ | 中英互译、多语言 |
| 🔄 单位换算 | ✅ | 长度/重量/温度/货币 |
| 📅 农历转换 | ✅ | 公历↔农历/节假日/节气 |

---

## 📥 安装方法

### 方法一：一键安装（推荐）

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
cp -r express weather stock translate news converter lunar hotsearch ~/.clawdbot/skills/

# 重启 Clawdbot
clawdbot gateway restart
```

### 方法三：单技能安装

```bash
# 安装单个技能
cp -r express ~/.clawdbot/skills/
# 或从 GitHub
git clone https://github.com/gongxtao/clawdbot-zh-skill.git
cp -r clawdbot-zh-skill/express ~/.clawdbot/skills/
```

---

## 🛠️ 技能使用

### 天气查询
```bash
clawdbot agent "北京今天天气"
clawdbot agent "上海明天天气"
clawdbot agent "广州后天天气"
```

### 快递查询
```bash
clawdbot agent "查询快递单号 SF1234567890"
clawdbot agent "我的顺丰快递到哪了"
```

### 股票查询
```bash
clawdbot agent "贵州茅台股价"
clawdbot agent "腾讯股票"
clawdbot agent "苹果股票价格"
```

### 翻译
```bash
clawdbot agent "翻译 Hello World"
clawdbot agent "把你好翻译成英文"
```

### 新闻资讯
```bash
clawdbot agent "今天的新闻"
clawdbot agent "科技新闻"
clawdbot agent "有什么热点"
```

### 热搜榜单
```bash
clawdbot agent "微博热搜"
clawdbot agent "知乎热榜"
clawdbot agent "抖音热搜"
```

### 单位换算
```bash
clawdbot agent "100厘米等于多少米"
clawdbot agent "1公里等于多少英里"
clawdbot agent "37度等于多少摄氏度"
```

### 农历转换
```bash
clawdbot agent "今天农历多少"
clawdbot agent "2026年春节是哪天"
clawdbot agent "今天是什么节气"
```

---

## 📋 技能开发规范

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

---

## 🤝 贡献指南

欢迎贡献新技能！

1. Fork 本仓库
2. 创建新技能文件夹
3. 编写 SKILL.md 和 scripts/*.sh
4. 测试通过后提交 PR

### 技能需求清单

- [ ] 地图导航（高德/百度地图）
- [ ] 公交地铁（实时到站）
- [ ] 火车票查询（车次/余票）
- [ ] 基金查询（净值/持仓）
- [ ] 加密货币（BTC/ETH）
- [ ] 电影票（场次/票价）
- [ ] 音乐播放（网易云/QQ音乐）
- [ ] 表情搜索（Emoji 查询）

---

## 📝 更新日志

### v1.1.0 (2026-02-01) - 新增5个技能

**新增技能：**
- ✨ 翻译（translate）
- ✨ 新闻资讯（news）
- ✨ 单位换算（converter）
- ✨ 农历转换（lunar）
- ✨ 热搜榜单（hotsearch）

### v1.0.0 (2026-02-01) - 初始版本

**核心技能：**
- ✨ 快递查询（express）
- ✨ 天气查询（weather）
- ✨ 股票查询（stock）

---

## 📄 License

MIT License

---

## 👨‍💻 作者

- GitHub: [@gongxtao](https://github.com/gongxtao)
- 项目: [clawdbot-zh-skill](https://github.com/gongxtao/clawdbot-zh-skill)
