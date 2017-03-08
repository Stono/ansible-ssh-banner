#!/bin/sh
set -ue
echo "Welcome to our super secure server!"

while read -rp 'Why are you logging on to this lovely server? ' REPLY
do
	case "$REPLY" in
		'')
			# empty input; ask again
			;;
		*)
			# Run original command if available or simply the user's log-in shell
			exec ${SSH_ORIGINAL_COMMAND-$SHELL -l};;
	esac
done
