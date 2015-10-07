Temp="`id | tr '=()' '   ' `"
set $Temp
user=$3								export user

if test `expr "$-" : '.*i.*'` != 0 ; then
	interactive=1
fi

# Don't check for mail, dammit!
unset MAILCHECK

#ENV=~/.bashrc							export ENV
dotdot=~/...ksh							export dotdot

CDPATH=".:~/etc/cdLinks:~:~/src:/scratch/video"			export CDPATH
HISTFILE=/var/tmp/.history.$user				export HISTFILE
HISTSIZE=500							export HISTSIZE
HISTFILESIZE=500						export HISTFILESIZE
FIGNORE=".o:~"							export FIGNORE

notify=1
history_control=ignoreboth
command_oriented_history=1
no_exit_on_failed_exec=1
ignoreeof=0

MYHOST=`hostname|sed -e 's/\..*$//'`
export MYHOST

if test -z "$BASH_VERSION" ; then
	# ksh
	PS1="$user@$MYHOST \! K> "
else
	# bash
#	PS1="\u@\h \!> "
	if test $user = root ; then
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	fi
fi
	
set -o emacs

if test "$pathset" != 1 -o \( $user = root -a "$ROOTpathset" != 1 \) -o \( $user = news -a "$NEWSpathset" != 1 \) ; then
	eval `$dotdot/buildenv.pl bash`

	if test $user = root ; then
		ROOTpathset=1 export ROOTpathset
	fi
	if test $user = news ; then
		NEWSpathset=1 export NEWSpathset
	fi
	pathset=1 export pathset
fi

eval `$dotdot/sshsock`

umask 022

alias l='/bin/ls -sCF'
alias la='/bin/ls -asCF'
alias ll='/bin/ls -slF'
alias ls='/bin/ls -sCF'

alias RM='/bin/rm -f'
alias cls='clear'
alias mv='/bin/mv -i'
alias mx='/bin/chmod +x'
alias pixtoxbm='pixtoppm | ppmtopgm | pgmtopbm -threshold -value 0.5 | pbmtoxbm'
alias psmem="ps aux|sort -nr +4 -5"
alias psroff='/usr/bin/psroff -h'
alias rm='/bin/rm -i'
alias unshar='unshar -h POSTER'
alias which='alias | $dotdot/which.perl -a'
alias xv='/usr/bin/X11/xv -8 -perfect'
alias findnewest="find . -type f -print0|xargs -0 stat -c '%Y %n'|sort -n"
alias flac2mp3='find . -type f -name '"'"'*.flac'"'"' -print0 | while read -d $'"'"'\0'"'"' a; do avconv -i "$a" -c:a libmp3lame -qscale:a 2 "${a[@]/%flac/mp3}";done'

slideshow () { xv -wait 10 -expand -2 $* ; }

lsC () { ls $* [A-Z]* ; }
lsc () { ls $* *.[ch] ; }
lsd () { ls $* .[a-z]* ; }

if [ -x /bin/su ] ; then
	su () { /bin/su $*;wai ; }
else
	su () { /usr/bin/su $*;wai ; }
fi

#
# Path Handling Stuff
#
pathfirst () {
    local i
    for i in $*
    do
	PATH=$i:$PATH
    done
}    
pathlast () {
    local i
    for i in $*
    do
	PATH=$PATH:$i
    done
}    

alias pathadd='pathlast'
alias pathprint=$dotdot/pathprint.pl
pathrm () { eval `$dotdot/pathrm.pl $*`; }

alias newpath='eval `$dotdot/buildenv.pl ksh`'

if test -n "$interactive" -a -r $dotdot/$TERM ; then
	. $dotdot/$TERM
fi

alias wmailq='watch -n 15 "(mailq 2>/dev/null)"'

alias lish-persephone='ssh -t chk@lish-atlanta.linode.com persephone'
alias lish-penelope='ssh -t chk@lish-newark.linode.com penelope'

alias list-packages="dpkg -l |awk '{print \$2}'|sed -e 's/\:\(i386\|amd64\)$//'"
alias sshkeys="/usr/bin/ssh-add .ssh/identity .ssh/id_github .ssh/id_rsa .ssh/id_whatbox"

alias tmm-tv='(cd /home/chk/tmm;sh ./tinyMediaManager.sh)'
alias tmm-movies='(cd /scratch/video/tmm;sh ./tinyMediaManager.sh)'
alias check-dsl="curl -s 'http://192.168.1.254/cgi/b/dsl/ov/?be=0&l0=1&l1=0'|grep Bandwidth|grep -o '[0-9][0-9]* / [0-9.][0-9.]*'"

# homeshick integration
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
