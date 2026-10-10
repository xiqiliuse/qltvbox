echo "-------------------------"
# git add tvbox.json
git add .
git commit -m "$(date +%Y-%m-%d\ %H:%M:%S)" 
git remote add origin git@github.com:xiqiliuse/qltvbox.git
git push origin "main"

commit_line=$(git log --oneline -1 HEAD)
stat_line=$(git show --stat HEAD | tail -n +2 | head -6)

# 执行推送并捕获输出
push_output=$(git push origin master 2>&1)

echo "$commit_line"
echo "$stat_line"
# echo "$push_output" | grep -E "error:|remote:|To " | head -4

# echo "--------"
# # 构建动态推送内容
# push_content="$commit_line"$'\n'"$stat_line"
# export push_content
# python -c '
# import os
# import notify
# content = os.environ.get("push_content", "无内容")
# notify.send("tvbox路线上传成功", content)
# '
# echo "-------------------------"

echo "--------"

# 1. 执行 git 命令并捕获输出（2>&1 合并错误输出）
git_output=$(git add -A 2>&1; git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" 2>&1; git push origin main 2>&1)

# 2. 取输出前 10 行
push_content=$(echo "$git_output" | head -n 10)

# 3. 传给 Python
export push_content

python -c '
import os
import notify
content = os.environ.get("push_content", "无内容")
notify.send("tvbox路线上传成功", content)
'

echo "-------------------------"