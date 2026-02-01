# 🚀 Clawdbot 中文技能市场

![Clawdbot](https://img.shields.io/badge/Clawdbot-AI%20Assistant-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Skills](https://img.shields.io/badge/Skills-19-blue?style=for-the-badge)

中文技能市场 for Clawdbot / OpenClaw / Moltbot，提供常用中文场景技能。

## 📂 技能分类目录

```
chinese-skills/
├── README.md          # 本文档
├── install.sh         # 一键安装脚本
│
├── 1-工具/            # 🔧 常用工具（5个）
│   ├── express/       # 📦 快递查询
│   ├── translate/     # 🌐 翻译
│   ├── converter/     # 🔄 单位换算
│   ├── emoji/         # 😀 表情搜索
│   └── idcard/        # 🆔 身份证查询
│
├── 2-生活/            # 🏠 生活服务（3个）
│   ├── weather/       # 🌤️ 天气查询
│   ├── lunar/         # 📅 农历转换
│   └── ipquery/       # 🌐 IP查询
│
├── 3-金融/            # 💰 金融理财（4个）
│   ├── stock/         # 📈 股票查询
│   ├── currency/      # 💱 汇率查询
│   ├── crypto/        # ₿ 加密货币
│   └── fund/          # 📊 基金查询
│
├── 4-交通/            # 🚌 出行交通（3个）
│   ├── map/           # 🗺️ 地图定位
│   ├── bus/           # 🚌 公交地铁
│   └── train/         # 🚄 火车票
│
├── 5-资讯/            # 📰 新闻资讯（2个）
│   ├── news/          # 📰 今日新闻
│   └── hotsearch/     # 🔥 热搜榜单
│
└── 6-娱乐/            # 🎵 娱乐休闲（2个）
    ├── movie/         # 🎬 电影票
    └── music/         # 🎵 音乐播放
```

---

## 📦 技能统计（19个）

| 分类 | 数量 | 技能列表 |
|------|------|---------|
| 🔧 工具 | 5 | 快递、翻译、单位换算、表情、身份证 |
| 🏠 生活 | 3 | 天气、农历、IP |
| 💰 金融 | 4 | 股票、汇率、加密货币、基金 |
| 🚌 交通 | 3 | 地图、公交地铁、火车票 |
| 📰 资讯 | 2 | 新闻、热搜 |
| 🎵 娱乐 | 2 | 电影、音乐 |

---

## 📥 安装方法

### 方法一：一键安装（推荐）

```bash
git clone https://github.com/gongxtao/clawdbot-zh-skill.git
cd clawdbot-zh-skill
./install.sh
```

### 方法二：分类安装

```bash
# 只安装工具类
cp -r 1-工具/* ~/.clawdbot/skills/

# 只安装金融类
cp -r 3-金融/* ~/.clawdbot/skills/

# 只安装交通类
cp -r 4-交通/* ~/.clawdbot/skills/
```

### 方法三：单技能安装

```bash
# 安装单个技能
cp -r 1-工具/express ~/.clawdbot/skills/
```

### 重启 Clawdbot

```bash
clawdbot gateway restart
```

---

## 🛠️ 技能使用

### 🔧 常用工具

```bash
clawdbot agent "查询快递单号 SF1234567890"
clawdbot agent "翻译 Hello World"
clawdbot agent "100厘米等于多少米"
clawdbot agent "开心的表情"
clawdbot agent "身份证号310101199001011234归属地"
```

### 🏠 生活服务

```bash
clawdbot agent "北京今天天气"
clawdbot agent "今天农历多少"
clawdbot agent "我的IP"
```

### 💰 金融理财

```bash
clawdbot agent "贵州茅台股价"
clawdbot agent "1美元等于多少人民币"
clawdbot agent "比特币价格"
clawdbot agent "易方达蓝筹净值"
```

### 🚌 出行交通

```bash
clawdbot agent "附近的餐厅"
clawdbot agent "北京地铁1号线"
clawdbot agent "北京到上海的高铁"
```

### 📰 新闻资讯

```bash
clawdbot agent "今天的新闻"
clawdbot agent "微博热搜"
clawdbot agent "知乎热榜"
```

### 🎵 娱乐休闲

```bash
clawdbot agent "今天有什么电影"
clawdbot agent "播放周杰伦的稻香"
```

---

## 🤝 贡献指南

欢迎贡献新技能！

### 待开发技能

- [ ] 酒店预订
- [ ] 外卖点餐
- [ ] 二手交易
- [ ] 租房信息
- [ ] 天气预警
- [ ] 股票提醒
- [ ] 赛事比分
- [ ] 星座运势

---

## 📝 更新日志

### v1.3.0 (2026-02-01) - 新增6个技能，目录重构

**新增技能：**
- 📊 基金查询（fund）
- 🎬 电影票查询（movie）
- 🎵 音乐播放（music）
- 😀 表情搜索（emoji）
- 🆔 身份证查询（idcard）
- 🌐 IP查询（ipquery）

**重大更新：**
- ✨ 目录结构重构，按功能分类（1-工具、2-生活、3-金融...）
- 📦 技能总数达到 19 个

### v1.2.0 (2026-02-01) - 新增5个技能

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
