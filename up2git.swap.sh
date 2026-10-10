echo "-------------------------"
# git add tvbox.json
git add .
git commit -m "$(date +%Y-%m-%d\ %H:%M:%S)" 
git remote add origin git@github.com:xiqiliuse/qltvbox.git
git push origin "main"


# commit_out=$(git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" 2>&1)
# commit_line=$(git log --oneline -1 HEAD)
# stat_line=$(git show --stat HEAD | tail -n +2 | head -6)
# push_output=$(git push origin master 2>&1)

# echo "$commit_line"
# echo "$commit_out"
# echo "$stat_line"
# echo "$push_output"
# echo "--------"

# push_content="$commit_out"$'\n'"$commit_line"$'\n'"$stat_line"$'\n'"$push_output"
# export push_content

# python -c '
# import os, notify
# content = os.environ.get("push_content", "无内容")
# notify.send("tvbox路线上传成功", content)
# '
# echo "-------------------------"

# 1) 提交
commit_out=$(git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" 2>&1)
echo "$commit_out"

# 2) remote（幂等，不再报 already exists）
if git remote get-url origin >/dev/null 2>&1; then
  remote_out="origin 已存在，跳过 remote add"
else
  remote_out=$(git remote add origin git@github.com:xiqiliuse/qltvbox.git 2>&1)
fi
echo "$remote_out"

# 3) 推送
push_out=$(git push origin "$BRANCH" 2>&1)
echo "$push_out"

# 4) 汇总
push_content=$(printf '%s\n%s\n%s' "$commit_out" "$remote_out" "$push_out")
export push_content

# 5) 调试：把真正要发的内容打出来
echo "===== push_content 实际内容 ====="
echo "$push_content"
echo "================================="

python3 -c '
import os, notify
content = os.environ.get("push_content") or "无内容"
notify.send("tvbox路线上传成功", content)
'