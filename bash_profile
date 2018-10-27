#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

#	if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ -z $XDG_SESSION_TYPE ]]; then
#		XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
#	fi

# if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
#	exec startx
# fi

# if [ -z "$TMUX" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 2 ]; then
	# exec tmux attach
# fi

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/sean/.vimpkg/bin:/home/sean/.bin"

export PATH="$HOME/.cargo/bin:$PATH"
