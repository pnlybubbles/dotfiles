# fzf

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcsa() {
  local commits commit
  commits=$(git log --all --color=always --pretty='format:%C(yellow)%h %C(red)%d %C(reset)%s' --abbrev-commit --reverse) &&
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
