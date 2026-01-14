#!/bin/bash

# 获取脚本所在目录及项目根目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_SOURCE_DIR="$PROJECT_ROOT/skills"
SKILLS_TARGET_DIR="$HOME/.gemini/antigravity/skills"

# 1. 执行 Git Pull 更新代码
echo "🔄 正在更新代码仓库..."
cd "$PROJECT_ROOT" || { echo "❌ 无法进入项目根目录 ($PROJECT_ROOT)"; exit 1; }

if git pull; then
    echo "✅ 代码更新成功"
else
    echo "❌ 代码更新失败，请检查 Git 状态"
    exit 1
fi

# 2. 确保目标目录存在
mkdir -p "$SKILLS_TARGET_DIR"

# 3. 同步 Skills (复制并处理增删)
echo "📂 正在同步 Skills 从 $SKILLS_SOURCE_DIR 到 $SKILLS_TARGET_DIR ..."

# 检查是否安装 rsync (MacOS/Linux 通常默认安装)
if command -v rsync &> /dev/null; then
    # -a: 归档模式 (递归, 保留属性)
    # -v: 详细输出
    # --delete: 删除目标目录中源目录没有的文件 (处理"减少"的情况)
    # 注意: 源目录路径末尾的 '/' 表示复制目录内容，而不是目录本身
    rsync -av --delete "$SKILLS_SOURCE_DIR/" "$SKILLS_TARGET_DIR/"
    echo "✅ Skills 同步完成 (镜像模式)"
else
    echo "⚠️ 未找到 rsync 工具，回退到普通复制模式 (无法自动处理文件删除)"
    cp -Rf "$SKILLS_SOURCE_DIR/"* "$SKILLS_TARGET_DIR/"
    echo "✅ Skills 复制完成"
fi
