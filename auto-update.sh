#!/bin/bash
# 蔚来换电站数据自动更新脚本
# 每日定时执行，更新数据并推送到 GitHub

cd /home/admin/.openclaw/workspace/nio-power-swap

echo "=========================================="
echo "🚀 蔚来换电站数据自动更新"
echo "⏰ 执行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 1. 运行数据更新脚本
echo "📊 正在更新数据..."
node update-data.js

if [ $? -ne 0 ]; then
    echo "❌ 数据更新失败"
    exit 1
fi

# 2. 检查是否有变更
if git diff --quiet index.html; then
    echo "ℹ️ 数据无变化，无需提交"
    exit 0
fi

# 3. 提交变更
echo "📤 正在提交到 GitHub..."
git add index.html
git commit -m "auto: 更新换电站数据 $(date '+%Y-%m-%d')"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ 更新成功！GitHub Pages 将在 1-2 分钟后自动部署"
    echo "🌐 访问地址: https://little-insect.github.io/nio-power-swap/"
else
    echo "❌ 推送失败，请检查网络或权限"
    exit 1
fi

echo "=========================================="
echo "✨ 完成！"
echo "=========================================="
