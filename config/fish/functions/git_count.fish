function git-count --description "统计指定 commit 之后多个身份的代码贡献"
    if test (count $argv) -eq 0
        echo "usage: git-count <commit_hash>"
        return 1
    end

    set -l start_commit $argv[1]
    # 定义你的所有用户名，用 | 分隔
    set -l authors "celeb zhou|qizi706-macos|QuanZhou"

    git log $start_commit..HEAD -E --author="$authors" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "---------------------------\n作者群体: '$authors'\n起始提交: '$start_commit'\n---------------------------\n新增行数: %s\n删除行数: %s\n净增行数: %s\n", add, subs, loc }'
end
