# brew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"

# direnv settup
#eval "$(direnv hook zsh)"

# nodenv setup
#eval "$(nodenv init -)"

# rustup setup
. "$HOME/.cargo/env"
