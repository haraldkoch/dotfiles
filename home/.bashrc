user="`id | tr '=()' '   ' | awk '{print $3}'`"			export user

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
HISTCONTROL=ignoreboth						export HISTCONTROL
FIGNORE=".o:~"							export FIGNORE

notify=1
no_exit_on_failed_exec=1
ignoreeof=0
shopt -s histappend
# check windowsize after each command
shopt -s checkwinsize

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
alias psmem="ps aux|sort -nr +4 -5"
alias tps='ps auxf'
alias rm='/bin/rm -i'
alias which='alias | $dotdot/which.perl -a'
alias whois='/usr/bin/whois -r'
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

alias stereo='mpc -h stereo'

alias update_calibre='sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('"'"'Download failed\n'"'"'); exec(sys.stdin.read()); main()"'

alias lish-persephone='ssh -t chk@lish-atlanta.linode.com persephone'
alias lish-penelope='ssh -t chk@lish-newark.linode.com penelope'

alias list-packages="dpkg -l |awk '{print \$2}'|sed -e 's/\:\(i386\|amd64\)$//'"
alias sshkeys="/usr/bin/ssh-add .ssh/id_rsa .ssh/id_fnord .ssh/id_github .ssh/id_media"

alias tmm-tv='(cd /home/chk/tmm;sh ./tinyMediaManager.sh)'
alias tmm-movies='(cd /scratch/video/tmm;sh ./tinyMediaManager.sh)'
alias tmm-mount='sshfs -o IdentityFile=/home/chk/.ssh/id_media media@mnemosyne:/media /scratch/video/mnemosyne -o uid=1000 -o gid=1000'
alias tmm-umount='fusermount -u /scratch/video/mnemosyne'

alias check-dsl="curl -s 'http://192.168.1.254/cgi/b/dsl/ov/?be=0&l0=1&l1=0'|grep Bandwidth|grep -o '[0-9][0-9]* / [0-9.][0-9.]*'"

alias laptop="xrandr --output LVDS1 --auto --output DVI-1-0 --off"
alias desktop="xrandr --output LVDS1 --off --output DVI-1-0 --auto"

##############
# git prompt #
##############
GIT_PROMPT_ONLY_IN_REPO=1
# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
GIT_PROMPT_THEME=Custom

function prompt_callback { gp_set_window_title ${user}@${MYHOST}:${PWD} ; }

# command-not-found support for Arch; it is builtin in Ubuntu
if [ -r /usr/share/doc/pkgfile/command-not-found.bash ] ; then
	source /usr/share/doc/pkgfile/command-not-found.bash
fi

source ~/.homesick/repos/bash-git-prompt/gitprompt.sh

##########
# travis #
##########
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

########
# work #
########
[ `hostname -s` = uhnsimsws02 ] && source $dotdot/work

#############
# homeshick #
#############
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

if test -n "$interactive" ; then
	homeshick --quiet refresh
fi

###########
# ansible #
###########
if [ -r ~/workspaces/git/ansible/hacking/env-setup ] ; then
	source ~/workspaces/git/ansible/hacking/env-setup -q
fi
