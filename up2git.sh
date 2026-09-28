echo "-------------------------"
# git add tvbox.json
git add .
git commit -m "$(date +%Y-%m-%d\ %H:%M:%S)" 
git remote add origin git@gitcode.com:xiqiliuse/tvboxup.git
git push origin "main"

commit_line=$(git log --oneline -1 HEAD)
stat_line=$(git show --stat HEAD | tail -n +2 | head -6)

# 执行推送并捕获输出
push_output=$(git push origin master 2>&1)

echo "$commit_line"
echo "$stat_line"
# echo "$push_output" | grep -E "error:|remote:|To " | head -4

echo "--------"
# 构建动态推送内容
push_content="$commit_line"$'\n'"$stat_line"
export push_content
python -c '
import os
import notify
content = os.environ.get("push_content", "无内容")
notify.send("tvbox路线上传成功", content)
'
echo "-------------------------"