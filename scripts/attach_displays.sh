#!/bin/bash
`dirname "$0"`/clean_sockets.sh
for f in `ls -1 /var/run/xpra/display-*`
do
	if ps -ef | grep -e "/xpra attach .*display-${f/*-/}$" > /dev/null 2>&1
	then
		echo "display already attached to $f ..."
	else
		echo "attaching to display $f ..."
		xpra attach --opengl=no socket:$f
	fi
done


## sudo apt-get install -y inotify-tools
#inotifywait -m /path -e create -e moved_to |
#    while read path action file; do
#        echo "The file '$file' appeared in directory '$path' via '$action'"
#		xpra attach --opengl=no socket:$path/$file
#    done
