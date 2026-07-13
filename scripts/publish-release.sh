#!/bin/bash
#===============================================
# yy_machine_build - 发布正式构建（release-当前时间）
#===============================================
set -e

TAG="release-$(date +%Y%m%d%H%M%S)"

echo "=== 创建标签: $TAG ==="
git tag "$TAG"
git push origin "$TAG"

echo ""
echo "✅ 已推送标签: $TAG"
echo "   查看进度: https://github.com/readgo/yy_machine_build/actions"
