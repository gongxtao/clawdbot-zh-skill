# 🚀 Clawdbot 中文技能市场

![Clawdbot](https://img.shields.io/badge/Clawdbot-AI%20Assistant-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Skills](https://img.shields.io/badge/Skills-13-blue?style=for-the-badge)

中文技能市场 for Clawdbot / OpenClaw / Moltbot，提供常用中文场景技能。

## 📦 技能列表（13个核心技能）

### 🏠 生活服务（3个）

| 技能 | 状态 | 说明 |
|------|------|------|
| 🌤️ 天气查询 | ✅ | 3天天气预报、空气质量 |
| 📦 快递查询 | ✅ | 主流快递自动识别 |
| 🗺️ 地图定位 | ✅ | 周边搜索、距离计算 |

### 🚌 出行交通（2个）

| 技能 | 状态 | 说明 |
|------|------|------|
| 🚌 公交地铁 | ✅ | 线路查询、换乘规划 |
| 🚄 火车票 | ✅ | 车次查询、余票、票价 |

### 💰 金融理财（3个）

| 技能 | 状态 | 说明 |
|------|------|------|
| 📈 股票查询 | ✅ | A股/港股/美股/指数 |
| 💱 汇率查询 | ✅ | 实时汇率、货币换算 |
| ₿ 加密货币 | ✅ | BTC/ETH 等主流币种 |

### 📰 新闻资讯（2个）

| 技能 | 状态 | 说明 |
|------|------|------|
| 📰 今日新闻 | ✅ | 头条新闻、热点资讯 |
| 🔥 热搜榜单 | ✅ | 微博/知乎/抖音/B站 |

### 🛠️ 工具效率（3个）

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

# 复制所有技能
cp -r express weather map bus train stock currency crypto news hotsearch translate converter lunar ~/.clawdbot/skills/

# 重启 Clawdbot
clawdbot gateway restart
```

### 方法三：单技能安装

```bash
# 安装单个技能
cp -r express ~/.clawdbot/skills/
```

---

## 🛠️ 技能使用

### 生活服务
```bash
clawdbot agent "北京今天天气"
clawdbot agent "查询快递单号 SF1234567890"
clawdbot agent "附近的餐厅"
clawdbot agent "从北京到上海有多远"
```

### 出行交通
```bash
clawdbot agent "北京地铁1号线"
clawdbot agent "上海公交911路"
clawdbot agent "北京到上海的高铁"
clawdbot agent "从望京到国贸怎么坐车"
```

### 金融理财
```bash
clawdbot agent "贵州茅台股价"
clawdbot agent "1美元等于多少人民币"
clawdbot agent "比特币价格"
clawdbot agent "ETH 行情"
```

### 新闻资讯
```bash
clawdbot agent "今天的新闻"
clawdbot agent "科技新闻"
clawdbot agent "微博热搜"
clawdbot agent "知乎热榜"
```

### 工具效率
```bash
clawdbot agent "翻译 Hello World"
clawdbot agent "100厘米等于多少米"
clawdbot agent "今天农历多少"
clawdbot agent "2026年春节是哪天"
```

---

## 📋 技能目录结构

```
chinese-skills/
├── express/        # 快递查询
├── weather/        # 天气查询
├── map/            # 地图定位 🆕
├── bus/            # 公交地铁 🆕
├── train/          # 火车票 🆕
├── stock/          # 股票查询
├── currency/       # 汇率查询 🆕
├── crypto/         # 加密货币 🆕
├── news/           # 新闻资讯
├── hotsearch/      # 热搜榜单
├── translate/      # 翻译
├── converter/      # 单位换算
├── lunar/          # 农历转换
├── install.sh      # 一键安装脚本
└── README.md       # 完整文档
```

---

## 🤝 贡献指南

欢迎贡献新技能！

### 待开发技能清单

- [ ] 基金查询（净值/持仓）
- [ ] 电影票（场次/票价）
- [ ] 音乐播放（网易云/QQ音乐）
- [ ] 表情搜索（Emoji 查询）
- [ ] 身份证查询（归属地/校验）
- [ ] IP 查询（本机IP/归属地）
- [ ] 短链接生成
- [ ] 密码生成器

---

## 📝 更新日志

### v1.2.0 (2026-02-01) - 新增5个交通金融技能

**新增技能：**
- 🗺️ 地图定位（map）
- 🚌 公交地铁（bus）
- 🚄 火车票（train）
- 💱 汇率查询（currency）
- ₿ 加密货币（crypto）

### v1.1.0 (2026-02-01) - 新增5个工具技能

**新增技能：**
- 🌐 翻译（translate）
- 📰 新闻资讯（news）
- 🔄 单位换算（converter）
- 📅 农历转换（lunar）
- 🔥 热搜榜单（hotsearch）

### v1.0.0 (2026-02-01) - 初始版本

**核心技能：**
- 📦 快递查询（express）
- 🌤️ 天气查询（weather）
- 📈 股票查询（stock）

---

## 📄 License

MIT License

---

## 👨‍💻 作者

- GitHub: [@gongxtao](https://github.com/gongxtao)
- 项目: [clawdbot-zh-skill](https://github.com/gongxtao/clawdbot-zh-skill)
