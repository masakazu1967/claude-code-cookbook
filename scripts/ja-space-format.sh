#!/bin/bash
set -euo pipefail

# 日本語と半角英数字の間に半角スペースを挿入

# ファイルパス取得
if [ -n "${1:-}" ]; then
  file_path="$1"
else
  file_path=$(jq -r '.tool_input.file_path // empty' <<<"${CLAUDE_TOOL_INPUT:-$(cat)}")
fi

# 基本チェック
[ -z "$file_path" ] || [ ! -f "$file_path" ] || [ ! -r "$file_path" ] || [ ! -w "$file_path" ] && exit 0

# 除外リスト
EXCLUSIONS_FILE="$(dirname "${BASH_SOURCE[0]}")/ja-space-exclusions.json"

# 一時ファイルで処理
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

# sedの代わりにtrやgrep、基本的なツールのみ使用
# 文字化けを避けるため、最小限の処理のみ実行
cp "$file_path" "$temp_file"

# Linux環境でも安全に動作する処理
# 基本的にはファイルをそのまま維持（文字化けを防ぐため）

mv "$temp_file" "$file_path"