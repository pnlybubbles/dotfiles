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
export HISTSIZE=1000000
export SAVEHIST=100000000
export TZ=JST-9
export PKG_CONFIG_PATH='/usr/local/Cellar/imagemagick@6/6.9.10-14/lib/pkgconfig'
export LANG='ja_JP.UTF-8'
export LC_CTYPE='ja_JP.UTF-8'
export MINT_PATH="$HOME/.mint"
export MINT_LINK_PATH="$MINT_PATH/bin"

## Path

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
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

# Profiling

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc"; fi
