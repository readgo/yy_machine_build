#!/bin/bash
#===============================================
# yy_machine_build - 发布正式构建（release-当前时间）
#
# 用法：在任意目录执行均可，脚本会自己切到本仓库根
#   bash yy_machine_build/scripts/publish-release.sh
# 打 release-<年月日时分秒> 标签并推送到 GitHub，
# 触发 GitHub Actions 从 Gitee 拉 master 源码构建 portable 包。
#===============================================
set -e

# 切到脚本所属仓库根（yy_machine_build），否则在父目录执行时 git 找不到仓库
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]; then
    echo "❌ 不是 git 仓库: $REPO_ROOT" >&2
    exit 1
fi

TAG="release-$(date +%Y%m%d%H%M%S)"

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    echo "❌ 标签已存在: $TAG" >&2
    exit 1
fi

echo "=== 仓库: $REPO_ROOT ==="
echo "=== 创建标签: $TAG ==="
git tag "$TAG"
git push origin "$TAG"

echo ""
echo "✅ 已推送标签: $TAG"
echo "   查看进度: https://github.com/readgo/yy_machine_build/actions"
