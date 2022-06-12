### brew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# direnv settup
eval "$(direnv hook zsh)"

# nodenv setup
eval "$(nodenv init -)"

# rustup setup
. "$HOME/.cargo/env"
