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
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

    # Homebrew Ruby
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

    alias oc-utm="sudo openconnect --authgroup 'UofT Default' --user=santang3 general.vpn.utoronto.ca"
    
    ws-hpc(){
        ssh hpcnode -N -f -L localhost:${1}:localhost:${1} santang3@hpcnode1.utm.utoronto.ca
    }
    
    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'mamba init' !!
    export MAMBA_EXE="/opt/homebrew/opt/micromamba/bin/micromamba";
    export MAMBA_ROOT_PREFIX="/Users/jamessantangelo/micromamba";
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        if [ -f "/Users/jamessantangelo/micromamba/etc/profile.d/micromamba.sh" ]; then
            . "/Users/jamessantangelo/micromamba/etc/profile.d/micromamba.sh"
        else
            export  PATH="/Users/jamessantangelo/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
        fi
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<
    
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
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
