#!/bin/bash
# 蔚来换电站数据自动更新脚本
# 数据来源: 加电小能微博 + 蔚来充电地图

cd /home/admin/.openclaw/workspace/nio-power-swap

echo "=========================================="
echo "🚀 蔚来换电站数据自动更新"
echo "⏰ 执行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "📡 数据源: 加电小能微博 + 蔚来充电地图"
echo "=========================================="

# 获取当前日期
TODAY=$(date +%Y-%m-%d)
echo "📅 今日日期: $TODAY"

# 检查 data.json 是否存在
if [ ! -f "data.json" ]; then
    echo "❌ data.json 不存在"
    exit 1
fi

# 更新 data.json 中的日期
sed -i "s/\"updateTime\": \"[^\"]*\"/\"updateTime\": \"$TODAY\"/g" data.json
echo "✅ data.json 日期已更新: $TODAY"

# 更新 index.html 中的日期（备用）
sed -i "s/上次更新:.*/上次更新: $TODAY/g" index.html 2>/dev/null || true

echo "=========================================="
echo "💡 提示: 请手动更新以下数据"
echo "   1. 查看微博 @加电小能 获取今日上新"
echo "   2. 访问蔚来充电地图获取总数"
echo "   3. 修改 data.json 后提交"
echo "=========================================="

# 检查是否有变更
if git diff --quiet; then
    echo "ℹ️ 无变化，跳过提交"
    exit 0
fi

# 提交到 GitHub
echo "📤 正在推送到 GitHub..."
git add data.json index.html
git commit -m "auto: 数据更新 $TODAY

- 更新日期戳
- 待手动更新: 今日上新数据、总数统计"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ 推送成功！"
    echo "🌐 https://little-insect.github.io/nio-power-swap/"
else
    echo "❌ 推送失败"
    exit 1
fi

echo "=========================================="
