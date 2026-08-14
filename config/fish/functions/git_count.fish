function git-count --description "统计指定 commit 之后指定作者的代码贡献"
    if test (count $argv) -lt 1
        echo "usage: git-count <commit_hash> [author-regex]"
        return 1
    end

    set -l start_commit $argv[1]
    set -l authors
    if test (count $argv) -ge 2
        set authors $argv[2]
    else if set -q GIT_COUNT_AUTHORS
        set authors $GIT_COUNT_AUTHORS
    else
        set -l configured_email (git config user.email)
        set authors (string escape --style=regex -- "$configured_email")
    end

    if test -z "$authors"
        echo "git-count: pass author-regex, set GIT_COUNT_AUTHORS, or configure user.email" >&2
        return 1
    end

    git log "$start_commit..HEAD" -E --author="$authors" --pretty=tformat: --numstat |
        awk -v authors="$authors" -v start="$start_commit" '
            { add += $1; subs += $2; loc += $1 - $2 }
            END {
                printf "---------------------------\n作者: %s\n起始提交: %s\n---------------------------\n新增行数: %s\n删除行数: %s\n净增行数: %s\n", authors, start, add, subs, loc
            }
        '
end
