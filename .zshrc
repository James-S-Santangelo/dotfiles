########################################################
#|# Preamble                                           #
########################################################
autoload -Uz compinit && compinit
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
AGNOSTER_PROMPT_SEGMENTS[2]=  # Remove context from Agnoster prompt

## ---------- Platform stuff ---------- ##
export platform='unknown'
uname=$(uname)
if [[ "x${uname}" == "xDarwin" ]]; then
    export platform='mac'
elif [[ "x${uname}" == "xLinux" ]]; then
    export platform='linux'
fi

########################################################
#|# Platform Independent                               ##
########################################################

## ---------- Aliases ---------- ##
alias reshell='source ~/.zshrc'
alias ls='ls --color=auto'
alias ll="clear && ls -alh --color"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias spath="tr ':' '\n' <<< "$path" | less" # split path by newline

# Vim
alias vi=nvim
alias vim=nvim
bindkey -v

########################################################
#|# Platform Specifics                                 #
########################################################

## ---------- Mac OSX ---------- ##
if [[ ${platform} == 'mac' ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

    # Homebrew Ruby
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

    alias oc-utm="sudo openconnect --authgroup 'UofT Default' --user=santang3 general.vpn.utoronto.ca"
    
    ws-hpc(){
        ssh hpcnode -N -f -L localhost:${1}:localhost:${1} santang3@hpcnode1.utm.utoronto.ca
    }
    
    # Quick scp from servers
    function fromponderosa(){
        scp -r "santang3@ponderosa.biol.berkeley.edu:${1}" .
    }
    function fromgraham(){
        scp -r "santang3@graham.computecanada.ca:${1}" .
    }
    function fromhpcnode(){
        scp -r "santang3@hpcnode1.utm.utoronto.ca:${1}" .
    }

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

fi

