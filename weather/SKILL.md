---
name: weather
description: "天气查询技能。查询中国城市天气，支持普通话查询。集成和风天气 API（需要注册获取 Key）。查询格式：'北京天气'、'上海明天天气'、'广州后天天气'、'深圳未来一周天气'"
metadata: {"clawdbot":{"emoji":"🌤️"}}
---

# 天气查询技能

## 使用方法

直接用自然语言查询：
```
"北京今天天气"
"上海明天天气"
"广州后天天气"
"深圳未来一周天气"
"杭州天气怎么样"
```

## API 设置

1. 注册和风天气：https://console.qweather.com
2. 免费版有 1000 次/天 额度
3. 创建 `~/.config/weather/api_key` 文件，写入你的 API Key

```bash
mkdir -p ~/.config/weather
echo "YOUR_API_KEY" > ~/.config/weather/api_key
```

## 支持城市

支持中国所有城市，识别城市名/省会/直辖市。

## API 说明

使用和风天气 QWeather API，提供 3 天天气预报。

