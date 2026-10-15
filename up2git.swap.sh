echo "-------------------------"
BRANCH="main"

# 1) 提交并捕获输出（含 [main xxx] 和 x files changed 两行）
commit_out=$(git add . && git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" 2>&1)
echo "$commit_out"

# 2) remote（幂等，已存在就不报错）
if git remote get-url origin >/dev/null 2>&1; then
    remote_out="origin 已存在，跳过 remote add"
else
    remote_out=$(git remote add origin git@github.com:xiqiliuse/qltvbox.git 2>&1)
fi
echo "$remote_out"

# 3) 推送并捕获输出（含 To... 和 xxx..xxx main -> main 两行）
push_out=$(git push origin "$BRANCH" 2>&1)
echo "$push_out"

# 4) 汇总
push_content=$(printf '%s\n%s\n%s' "$commit_out" "$remote_out" "$push_out")
export push_content
echo "===== push_content 实际内容 ====="
echo "$push_content"
echo "================================="
python3 -c '
import os, notify
content = os.environ.get("push_content") or "无内容"
notify.send("tvbox路线上传成功", content)
'