# 蔚来换电站数据中心

🚗⚡ 实时追踪蔚来换电站建设进展

## 🌐 在线访问

**GitHub Pages**: https://little-insect.github.io/nio-power-swap/

## 📊 功能特性

- **实时数据看板**: 换电站总数、充电站数量、高速换电站、累计换电次数
- **每日上新**: 展示最近7天新增站点记录
- **省级分布**: TOP15省份排行榜，含趋势指示
- **覆盖统计**: 城市覆盖数、电区房覆盖率、平均换电时间

## 🔄 自动更新设置

### 方法一：GitHub Actions（推荐）

1. 访问仓库 Settings → Secrets and variables → Actions
2. 添加 `GITHUB_TOKEN`（通常已自动配置）
3. 创建文件 `.github/workflows/auto-update.yml`:

```yaml
name: Daily Data Update

on:
  schedule:
    - cron: '0 1 * * *'  # 每天北京时间9点
  workflow_dispatch:

permissions:
  contents: write
  pages: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Update timestamp
        run: |
          TODAY=$(date +%Y-%m-%d)
          sed -i "s/上次更新:.*/上次更新: $TODAY/g" index.html
          sed -i "s/id=\"updateTime\">[^<]*/id=\"updateTime\">$TODAY/g" index.html
      
      - name: Commit changes
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add index.html
          git diff --quiet && git commit -m "auto: 每日数据更新 $TODAY" && git push || echo "No changes"
```

### 方法二：本地定时任务

在服务器上添加 cron 任务：

```bash
# 编辑 crontab
crontab -e

# 添加每日9点执行
0 9 * * * cd /path/to/nio-power-swap && bash auto-update.sh
```

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `index.html` | 主页面 |
| `update-data.js` | 数据更新脚本（Node.js） |
| `auto-update.sh` | 自动更新 shell 脚本 |

## 📝 数据来源

- 蔚来官方公开数据
- 蔚来充电地图: https://chargermap.nio.com/

## ⚠️ 免责声明

本页面仅供数据展示，不代表蔚来官方立场。
