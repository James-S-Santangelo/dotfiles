## Thanks https://github.com/vsbuffalo/dotfiles2/blob/main/setup.sh
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

## printing functions ##
function gecho {
  echo "${green}[message] $1${reset}"
}

function yecho {
  echo "${yellow}[note] $1${reset}"
}

function wecho {
  # red, but don't exit 1
  echo "${red}[error] $1${reset}"
}

function recho {
  echo "${red}[error] $1${reset}"
  exit 1
}

## install functions ##

# look for command line tool, if not install via homebrew
function install_brew {
  (command -v $1 > /dev/null  && gecho "$1 found...") || 
    (yecho "$1 not found, installing via homebrew..." && brew install $1)
}

# check for pre-req, fail if not found
function check_preq {
  (command -v $1 > /dev/null  && gecho "$1 found...") || 
    recho "$1 not found, install before proceeding."
}

# install Homebrew main programs if on a mac
if [[ "$(uname)" == "Darwin" ]]; then
	check_preq brew
    check_preq stow
    install_brew zsh
    install_brew rg
	install_brew tmux
	install_brew nvim
elif [[ "$(uname)" == "Linux" ]]; then
    check_preq rg
    check_preq tmux
    check_preq nvim
    check_preq stow
fi

# Remove old absolute dotfile symlinks from previous linkdotfile approach
gecho "Cleaning up old dotfile symlinks..."
for f in .gitconfig .bashrc .bash_profile .zshrc .zsh_plugins.txt .tmux.conf .condarc; do
    [ -L "$HOME/$f" ] && rm "$HOME/$f" && yecho "Removed old symlink: ~/$f"
done

# Back up real nvim config if it exists and isn't already a symlink
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    yecho "Backing up ~/.config/nvim to ~/.config/nvim.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# Stow dotfiles
gecho "Stowing dotfiles..."
stow --dir="$HOME/github-repos" --target="$HOME" dotfiles

# Make sure Antidote is installed
if [ ! -d ~/.antidote ]; then
	yecho "~/.antidote not found, downloading..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
else
	gecho "${ZDOTDIR:-$HOME}/.antidote found."
fi
