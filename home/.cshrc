#
# When I run su, it executes the target's shell, but with my environment. So,
# when I su to root, it executes /bin/csh. Csh executes $HOME/.cshrc! I want
# bash instead, so I execute it here.

#if ($?prompt) then
#	if (`/var/config/track/bin/hostin solaris` == 1) exec /home/enfm/harald/sbin/appl/bash
#	if (-x /opt/gnu/bin/bash) exec /opt/gnu/bin/bash
#endif
#set path = ($path /opt/openwin/bin /usr/openwin/bin /local/bin/X11)
