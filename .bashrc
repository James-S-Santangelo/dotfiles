# ~/.bashrc: executed by bash(1) for non-login shells.
# https://gist.github.com/mhoffman/4a5f34aaca066bb8469be26f36c7edb3
# https://mhoffman.github.io/2016/05/03/sync-your-dotfiles.html

########################################################
#|# Preamble                                           #
########################################################
[ -z "$PS1" ] && return

# Determine platform first
export platform='unknown'
uname=$(uname)
if [[ "x${uname}" == "xDarwin" ]]; then
    export platform='mac'
elif [[ "x${uname}" == "xLinux" ]]; then
    export platform='linux'
fi

export hostname='unknown'
if which hostname >/dev/null; then
    export hostname=$(hostname)
else
    export hostname='unknown'
fi

########################################################
#|# Platform Specifics                                 #
########################################################
########################################################
#|## Mac OS X                                          #
########################################################
if [[ ${platform} == 'mac' ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    . "$HOME/.cargo/env"

    # Homebrew Ruby
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

    ws-hpc(){
        ssh hpcnode -N -f -L localhost:$1:localhost:$1 santang3@hpcnode1.utm.utoronto.ca
    }

    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'mamba init' !!
    export MAMBA_EXE="/opt/homebrew/opt/micromamba/bin/micromamba";
    export MAMBA_ROOT_PREFIX="/Users/jamessantangelo/micromamba";
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
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


########################################################
#|## Linux                                             #
########################################################
elif [[ ${platform} == 'linux' ]]; then
    export PATH=$HOME/bin:$PATH
    export PATH=$HOME/.local/bin:$PATH
    
    # Check terminal size after each command to prevent prompt issues on window resizing
    shopt -s checkwinsize

    alias sp="sacct --format='JobID,JobName%50,NNodes,NTasks,NCPUS,Elapsed,CPUTime,ReqMem,MaxRSS,ExitCode,State'"
    stall(){
        JOBS=$( sq | tail -n +2 | grep 'R' | awk -vORS=, '{print $1}'; )
        sstat $JOBS --format="JobID,NTasks,MaxRSS,MaxVMSize,AveCPU" | sort -n -k3,3
    }
    scancal(){
        JOBS=$( sq | tail -n +2 | awk '{print $1}'; )
        scancel $JOBS
    }
    spmem(){
       sp | grep -A 1 "${1}" | grep 'batch' | grep 'COMP' | sort -n -k9,9 | less -S
    }
    sptime(){
       sp | grep -A 1 "${1}" | grep 'batch' | grep 'COMP' | sort -k6,6 | less -S
    }
fi

########################################################
#|# Host Specifics                                     #
########################################################
########################################################
#|## hpcnode1                                          #
########################################################
if [ "x$(hostname)" = "xhpcnode1.utm.utoronto.ca" ]
then
    
    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'mamba shell init' !!
    export MAMBA_EXE='/home/santang3/miniforge3/bin/mamba';
    export MAMBA_ROOT_PREFIX='/home/santang3/miniforge3';
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<

    # Random
    export LC_ALL="en_US.UTF-8"
else
    function fromhpcnode(){
    scp -r "santang3@hpcnode1.utm.utoronto.ca:${1}" .
    }
fi

########################################################
#|## Narval                                            #
########################################################
if [[ "x$(hostname)" = xnar* ]]
then

    # Load necessary modules
    module load nodejs
    module load apptainer
    module load python/3.12.4

    # Made sure Rust crates are on PATH
    export PATH="$HOME/.cargo/bin:$PATH"

    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'mamba shell init' !!
    export MAMBA_EXE='/home/santang3/miniforge3/bin/mamba';
    export MAMBA_ROOT_PREFIX='/home/santang3/miniforge3';
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<

else
    function fromnarval(){
    scp -r "santang3@:narval.alliancecan.ca${1}" .
    }
fi
########################################################
#|## Ponderosa                                         #
########################################################
if [[ "x$(hostname)" = xponderosa ]]
then

    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'mamba shell init' !!
    export MAMBA_EXE='/home/santang3/miniforge3/bin/mamba';
    export MAMBA_ROOT_PREFIX='/home/santang3/miniforge3';
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<

else
    function fromponderosa(){
    scp -r "santang3@ponderosa.biol.berkeley.edu:${1}" .
    }
fi

########################################################
#|## Bash, PATH                                        #
########################################################

# put here for early evaluation
alias rebash='source ~/.bashrc'

parse_git_branch() {

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'

}

export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[31m\]$(parse_git_branch)\[\033[01;34m\]$\[\033[00m\] '

# set bash to vi mode
set -o vi

# enable color support of ls and also add handy aliases
export INPUTRC=~/.inputrc
if [[ ${platform} == 'mac' ]]; then
    export CLICOLOR=1
    eval `dircolors -b`
else
    eval `dircolors -b`
fi

########################################################
#|## Aliases, Utiliites                                #
########################################################

# bash sugar
alias ls='ls --color=auto'
alias ldir='ls -al --color=always | grep -e "^d"'  # list only directories
alias gr='grep'
alias c='clear'
alias ct='printf "\033c"'  # clear terminal
alias l='ls -lhtr --color=auto  --time-style long-iso && pwd'
alias ll="clear && ls -alh --color"
alias ltail='ls -rtlh |  tail -n 20'
alias j='jobs'
alias g='gthumb'
alias d='date'
alias kk='kill %'

# alias top='htop -d 1'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Make the bash feel smoother
# correct common typos
alias sl='ls'
alias iv='vi'
alias dc='cd'
alias tpo='top'
alias otp='top'
alias t='top'
alias spath="tr ':' '\n' <<< "$PATH" | less" # Split PATH by newline

# vim
alias vi=nvim
alias vim=nvim

pman() { # view man pages the fancy way
  tmp=$(mktemp); man -t $1  | ps2pdf - ${tmp} && xpdf -z 'width' -g 1280x1000 ${tmp} && rm ${tmp};
};

