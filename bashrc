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
    export PATH="/usr/local/sbin:$PATH"
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

    alias hpcnode="ssh santang3@hpcnode1.utm.utoronto.ca"
    alias calculon="ssh santang3@calculon.utm.utoronto.ca"
    alias niagara="ssh santang3@niagara.scinet.utoronto.ca"
    alias graham="ssh santang3@graham.computecanada.ca"
    alias oc-utm="sudo openconnect --authgroup 'UofT Default' --user=santang3 general.vpn.utoronto.ca"


    ws-hpc(){
        ssh -N -f -L localhost:$1:localhost:$1 santang3@hpcnode1.utm.utoronto.ca
    }
    ws-gra(){
        ssh -N -L localhost:$1:localhost:$1 santang3@graham.computecanada.ca
    }


########################################################
#|## Linux                                             #
########################################################
elif [[ ${platform} == 'linux' ]]; then
    export PATH=$HOME/bin:$PATH
    export PATH=$HOME/.local/bin:$PATH

    alias sp='sacct -S 2020-11-01 -u santang3 --format="JobID,JobName%50,NNodes,NTasks,NCPUS,Elapsed,CPUTime,ReqMem,MaxRSS,ExitCode,State"'
    alias scancall='sq | awk "{print $1}" | xargs -n1 scancel'

    stall(){
        JOBS=$(sq | grep 'R' | awk -vORS=, '{print $1}')
        sstat $JOBS --format="JobID,NTasks,MaxRSS,MaxVMSize,AveCPU" | sort -n -k3,3
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

    # Compilers
    export CC=/home/santang3/gcc9.3.0/bin/gcc
    export CXX=/home/santang3/gcc9.3.0/bin/g++
    
    # PATH
    #export PATH=$PATH:/opt/bwa/0.7.17:/opt/fastpmaster/0.20.1:/opt/fastqc/0.11.9:/opt/gatk/4.1.7.0:/opt/qualimap/2.2.1:/opt/samtools/1.10/bin:/opt/bcftools/1.10.2/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin               
    export PATH=$HOME/bin/cmake/bin:$PATH
	
    # LD_LIBRARY_PATH
    export LD_LIBRARY_PATH="${HOME}/gcc9.3.0/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/gcc9.3.0/lib64:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/zlib-1.2.11/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/openssl/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/curl-7.69.1/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/htslib-1.10.2/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/gsl-2.1/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/python3.7.7/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/libffi-3.2.1/lib:${LD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${HOME}/local/libffi-3.2.1/lib64:${LD_LIBRARY_PATH}"
	
    # PKG_CONFIG_PATH
    export PKG_CONFIG_PATH="${HOME}/local/zlib-1.2.11/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH="${HOME}/local/curl-7.69.1/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH="${HOME}/local/htslib-1.10.2/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH="${HOME}/local/gsl-2.1/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH="${HOME}/local/python3.7.7/lib/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH="${HOME}/local/libffi-3.2.1/lib/pkgconfig:${PKG_CONFIG_PATH}"
	
    # CPPFLAGS
    export CPPFLAGS="-I/home/santang3/local/zlib-1.2.11/include"
	export CPPFLAGS="-I/home/santang3/local/curl-7.69.1/include"
	export CPPFLAGS="-I/home/santang3/local/htslib-1.10.2/include"
	export CPPFLAGS="-I/home/santang3/local/gsl-2.1/include"
	export CPPFLAGS="-I/home/santang3/local/python3.7.7/include"
	export LDFLAGS="-L/home/santang3/local/zlib-1.2.11/lib -Wl,-rpath,/home/santang3/local/htslib-10.1.2/lib"
	
	# LDFLAGS
	export LDFLAGS="-L/home/santang3/local/openssl/lib -Wl,-rpath,/home/santang3/local/openssl/lib"
	export LDFLAGS="-L/home/santang3/local/htslib-10.1.2/lib -Wl,-rpath,/home/santang3/local/htslib-1.10.2/lib"
	export LDFLAGS="-L/home/santang3/local/gsl-2.1/lib -Wl,-rpath,/home/santang3/local/gsl-2.1/lib"
	export LDFLAGS="-L/home/santang3/local/python3.7.7/lib -Wl,-rpath,/home/santang3/local/python3.7.7/lib"
	export LDFLAGS="-L/home/santang3/local/libffi-3.2.1/lib -Wl,-rpath,/home/santang3/local/libffi-3.2.1/lib"
	export LDFLAGS="-L/home/santang3/local/libffi-3.2.1/lib64 -Wl,-rpath,/home/santang3/local/libffi-3.2.1/lib64"
    
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
    export CLICOLOR=YES
    eval `dircolors -b`
    export JAVA_HOME=$(/usr/libexec/java_home)
else
    eval `dircolors -b`
fi

# Make conda available if installed
if [ -d "${HOME}/miniconda3"  ]
then
    . ${HOME}/miniconda3/etc/profile.d/conda.sh
fi

# Install Vundle for Vim if not installed
if ! [ -d "${HOME}/.vim/bundle/Vundle.vim"  ]
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
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


[ -f "/Users/jamessantangelo/.ghcup/env" ] && source "/Users/jamessantangelo/.ghcup/env" # ghcup-env
