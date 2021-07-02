# fzf

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcsa() {
  local commits commit
  commits=$(git log --all --color=always --pretty='format:%C(yellow)%h %C(red)%d %C(reset)%s' --abbrev-commit --reverse $*) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

fcs() {
  local commits commit
  commits=$(git log --color=always --pretty='format:%C(yellow)%h %C(red)%d %C(reset)%s' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fshow - git commit browser
fshow() {
  git log --all --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
{}
FZF-EOF"
}

fadd() {
  git status -su | grep -Ev '^.\s' |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --bind "ctrl-m:execute: (sed -e "s/^...//" |
      xargs -I % sh -c 'git add %') <<< {}"
}

fbranch_raw() {
  git branch -a |
    fzf-tmux --ansi --no-sort --tiebreak=index -d 10 |
    sort |
    uniq
}

fbranch() {
  git branch -a |
    fzf-tmux --ansi --no-sort --tiebreak=index -d 10 |
    sed -e "s/..\(remotes\/origin\/\)\?//" |
    sort |
    uniq
}

fstatus() {
  git status -su |
    fzf --ansi --no-sort --tiebreak=index --preview 'git diff --color=always @ {2}' |
    awk '{ print $2 }' |
    uniq
}

fstaged() {
  git status -su |
  grep -Ev '^(\s|\?)' |
    fzf --ansi --no-sort --tiebreak=index --preview 'git diff --color=always --cached {2}' |
    awk '{ print $2 }' |
    uniq
}

funstaged() {
  git status -su |
    grep -Ev '^.\s' |
    fzf --ansi --no-sort --tiebreak=index --preview 'git diff --color=always -- {2}' |
    awk '{ print $2 }' |
    uniq
}

fdiff() {
  git diff $1 --name-only |
    fzf --ansi --no-sort --tiebreak=index --preview "git diff --color=always $1^ $1 -- {2}"
}

flog_master() {
  default=${1:-HEAD}
  flog --left-right origin/$(git default-branch)..${default}
}

flog() {
  git log $@ \
      --pretty="format:%C(reset)%h %C(white reverse) %an %C(reset)%C(cyan bold)%d%C(reset) %s %C(white dim)(%ar)" |
  fzf --ansi --no-sort --tiebreak=index \
      --preview 'git show -p --color=always --pretty=fuller --stat {1}' |
  awk '{ print $1 }'
}

fpath() {
  git ls-files |
    fzf --ansi --no-sort --tiebreak=index --preview 'bat --color=always --style=numbers --line-range=:500 {}'
}
