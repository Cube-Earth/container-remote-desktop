#!/bin/bash
if [[ ! -z "$PASSWORD" ]]
then
	echo "desktop:$PASSWORD" | chpasswd
fi

if [[ -f /home/desktop/.ssh/authorized_keys ]]
then
	nuid=`stat -c %u /home/desktop/.ssh/authorized_keys`
	[[ `id -u` -ne $nuid ]] && echo changing uid of user 'desktop' to $nuid ... && usermod -u $nuid desktop
fi
rm /home/desktop/display.env
sudo -i -u desktop flock -w 15 /var/run/xpra/.lock /usr/scripts/clean_sockets.sh
if [[ $? -ne 0 ]]
then
	echo "ERROR: could not obtain lock !"
	exit 1
fi
rm /tmp/.X1-lock /tmp/.X11-unix/X1
sudo -i -u desktop /usr/scripts/start_services.sh

# for debugging purposes stop xrdp and xrdp-sesman and invoke them via "sudo xrdp -ns &" and "sudo xrdp-sesman -ns &" to get logging messages inside the console output
xrdp
xrdp-sesman

chown -R root /tmp/.X11-unix

echo "starting sshd ..."
/usr/sbin/sshd -d -D
