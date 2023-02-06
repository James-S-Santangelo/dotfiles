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

export dnsdomainname='unknown'
if which dnsdomainname >/dev/null; then
    export dnsdomainname=$(dnsdomainname)
else
    export dnsdomainname='unknown'
fi

export domainname='unknown'
if which domainname >/dev/null; then
    export domainname=$(domainname)
else
    export domainname='unknown'
fi

export hostname='unknown'
if which domainname >/dev/null; then
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

    alias hpcnode="ssh hpcnode"
    alias niagara="ssh niagara"
    alias graham="ssh graham"
    alias oc-utm="sudo openconnect --authgroup 'UofT Default' --user=santang3 general.vpn.utoronto.ca"
    
    ws-hpc(){
        ssh hpcnode -N -f -L localhost:$1:localhost:$1 santang3@hpcnode1.utm.utoronto.ca
    }
    ws-gra(){
        ssh graham -N -f -L localhost:$1:localhost:$1 santang3@graham.computecanada.ca
    }

########################################################
#|## Linux                                             #
########################################################
elif [[ ${platform} == 'linux' ]]; then
    export PATH=$HOME/bin:$PATH
    export PATH=$HOME/.local/bin:$PATH
    
    # Check terminal size after each command to prevent prompt issues on window resizing
    shopt -s checkwinsize

    alias sp="sacct -u santang3 --format='JobID,JobName%50,NNodes,NTasks,NCPUS,Elapsed,CPUTime,ReqMem,MaxRSS,ExitCode,State'"
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
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
        else
            export PATH="/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    
    # Random
    export LC_ALL="en_US.UTF-8"
else
    function fromhpcnode(){
    scp -r "santang3@hpcnode1.utm.utoronto.ca:${1}" .
    }
fi

########################################################
#|## niagara                                           #
########################################################
if [[ "x$(hostname)" = xnia* ]]
then
    if  [ "x$(hostname)" = "xnia-login01.scinet.local"  ]
    then
        :
    else
        ssh nia-login01
    fi
else
    function fromniagara(){
    scp -r "santang3@niagara.scinet.utoronto.ca:${1}" .
    }
fi

########################################################
#|## graham                                            #
########################################################
if [[ "x$(hostname)" = xgra* ]]
then
    if  [ "x$(hostname)" = "xgra-login1"  ]
    then
        :
    else
        ssh gra-login1
    fi

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/santang3/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/santang3/mambaforge/etc/profile.d/conda.sh" ]; then
            . "/home/santang3/mambaforge/etc/profile.d/conda.sh"
        else
            export PATH="/home/santang3/mambaforge/bin:$PATH"
        fi
    fi
    unset __conda_setup

    if [ -f "/home/santang3/mambaforge/etc/profile.d/mamba.sh" ]; then
        . "/home/santang3/mambaforge/etc/profile.d/mamba.sh"
    fi
    # <<< conda initialize <<<

else
    function fromgraham(){
    scp -r "santang3@graham.computecanada.ca:${1}" .
    }
fi
########################################################
#|# General                                            #
########################################################

alias dirbashrc="grep -nT '^#|' ~/.bashrc"
alias bashrc="vim ~/.bashrc"


########################################################
#|## Bash, PATH                                        #
########################################################

# put here for early evaluation
alias rebash='source ~/.bashrc'

parse_git_branch() {

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'

}

export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[31m\]$(parse_git_branch)\[\033[01;34m\]$\[\033[00m\] '

# have to stay here before setting PS1
# export GIT_PS1_SHOWDIRTYSTATE=true
# export export GIT_PS1_SHOWSTASHSTATE=true

# # set a fancy prompt
# declare -F | grep __git_ps1 > /dev/null
# if [ "$?" -eq 0 ]
# then
    # echo ${platform}
        # export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[31m\]$(__git_ps1 "(%s)")\[\033[01;34m\]$\[\033[00m\] '
# else
    # if [[ ${platform} == 'mac' ]]; then
        # export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[31m\]$(parse_git_branch)\[\033[01;34m\]$\[\033[00m\] '
    # else
        # export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[31m\]\[\033[01;34m\]$\[\033[00m\] '
    # fi
 #fi

# set bash to vi mode
# (hit ESC for command mode/
#  hit i for insert mode)
set -o vi

# enable color support of ls and also add handy aliases
export INPUTRC=~/.inputrc
if [[ ${platform} == 'mac' ]]; then
    export CLICOLOR=1
    eval `dircolors -b`
else
    eval `dircolors -b`
fi


# Install Vundle for Vim if not installed
if ! [ -d "${HOME}/.vim/bundle/Vundle.vim"  ]
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

########################################################
#|## Environment                                       #
########################################################

export EDITOR=vim

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
alias v='vim'
alias eb='vim ~/.bashrc'
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
alias vi='vim'
alias dc='cd'
alias tpo='top'
alias otp='top'
alias t='top'

alias mem="ps aux | awk '{print \$2, \$4, \$11}' | sort -k2rn | head -n 20"
alias ppu="ps -u '$(echo $(w -h | cut -d ' ' -f1 | sort -u))' o user= | sort | uniq -c | sort -rn"
alias spath="tr ':' '\n' <<< "$PATH" | less" # Split PATH by newline

# vim
alias vi=vim
alias vim="vim -O"

pman() { # view man pages the fancy way
  tmp=$(mktemp); man -t $1  | ps2pdf - ${tmp} && xpdf -z 'width' -g 1280x1000 ${tmp} && rm ${tmp};
};

