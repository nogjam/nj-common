#!/usr/bin/env bash

git-authors() {
    git ls-tree -r -z --name-only HEAD -- \$1 \
        | sed 's/^/.\//' \
        | xargs -0 -n1 git blame --line-porcelain HEAD \
        | grep -ae "^author " \
        | sort \
        | uniq -c \
        | sort -nr
}

git-branch-ls-local() {
    git branch -v \
        --format='%(color:blue)%(committerdate:short) %(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' \
        --sort=-committerdate
}

git-branch-ls-remote() {
    if [ -z "${1:-}" ]; then
        echo "Error: Must specify a name to search for"
        return 1
    fi
    git branch -r --list 'origin/*' -v --color=always \
        --format='%(color:blue)%(committerdate:short) %(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' \
        --sort=-committerdate \
        | grep -Ev --color=always '(origin/sel/|origin/master)' \
        | grep --color=always "$1"
}

git-log-oneline-author() {
    git log --format=format:'%Cblue%as %Cred%h %Cgreen%an%Creset %s'
}
