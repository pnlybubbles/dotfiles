# http://post.simplie.jp/posts/60

# Profiling

# zmodload zsh/zprof

## zplug

source $HOME/.zplug/init.zsh
source $HOME/.zplug-list
zplug load

## Basic

setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt ignore_eof
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt magic_equal_subst
setopt notify
setopt print_eight_bit
setopt print_exit_value
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_wait
setopt share_history

## fpath

fpath=(/home/.zsh/completion $fpath)

## autoload

autoload -Uz add-zsh-hook
autoload -Uz compinit
autoload -Uz url-quote-magic
autoload -Uz vcs_info
zle -N self-insert url-quote-magic

## env

export XDG_CONFIG_HOME=$HOME/.config
export CLICOLOR=true
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
export EDITOR=nvim
export HISTFILE=~/.zhistory
export HISTSIZE=1000
export SAVEHIST=1000000
export TZ=JST-9
export PKG_CONFIG_PATH='/usr/local/Cellar/imagemagick@6/6.9.10-14/lib/pkgconfig'
export LANG='ja_JP.UTF-8'
export LC_CTYPE='ja_JP.UTF-8'
export MINT_PATH="$HOME/.mint"
export MINT_LINK_PATH="$MINT_PATH/bin"

## Path

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

## Alias

alias ls="ls -G"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias g="git"
alias gs="git status"
alias fs="fshow"
alias ...="cd ../.."
alias ....="cd ../../.."
alias cc="cd +"
alias grep="grep --color"
alias vim="nvim"
alias e="nvim"
alias notify="echo -e '\a'"

## Module

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%B≪ %d ≫%f'
zstyle ':completion:*:options' description 'yes'

## Prompt

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b' '%c%u'
zstyle ':vcs_info:git:*' actionformats '%b|%a' '%c%u'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"
zstyle ':vcs_info:git:*' unstagedstr "-"
BRANCH_ICON=$'\ue725'
LEFT_LINE_TRIANGLE=$'\ue0b3'
_vcs_precmd () {
  vcs_info
  git_status=''
  if [ ! -z ${vcs_info_msg_0_} ]; then
    git_status=${vcs_info_msg_0_}
    if [ ! -z ${vcs_info_msg_1_} ]; then
      git_status='● '${git_status}
    fi
    git_status=${BRANCH_ICON}' '${git_status}
  fi
}
add-zsh-hook precmd _vcs_precmd
PROMPT='%B%m%b %F{197}❯ %f'
RPROMPT=' %F{239}${git_status} ${LEFT_LINE_TRIANGLE} %c%f'

# Misc

# https://unix.stackexchange.com/questions/75681/why-do-i-have-to-re-set-env-vars-in-tmux-when-i-re-attach
# Predictable SSH authentication socket location.
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
  rm -f /tmp/ssh-agent-$USER-screen
  ln -sf $SSH_AUTH_SOCK $SOCK
  export SSH_AUTH_SOCK=$SOCK
fi

## Keybind

# bindkey -v
# bindkey -v '^?' backward-delete-char
bindkey -e
bindkey '^[[Z' reverse-menu-complete
bindkey '^r' anyframe-widget-put-history

# fzf

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

# Profiling

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi

