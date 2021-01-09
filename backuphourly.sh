#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# write date to logfiles
echo "${date} executing backup-hourly script" >> ${screenlog}
echo "${date} executing backup-hourly script" >> ${backuplog}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}server is not currently running!${nocolor}"
	echo "server is not currently running!" >> ${screenlog}
	echo "server is not currently running!" >> ${backuplog}
	exit 1
fi

# check if world is bigger than diskspace
worldsize=$(du -s world | cut -f1)
diskspace=$(df / | tail -1 | awk '{print $4}')
if (( (${worldsize} + 65536) > ${diskspace} )); then
	echo -e "${red}fatal: not enough disk-space to perform backup${nocolor}"
	echo "fatal: not enough disk-space to perform backup" >> ${backuplog}
	# ingame logfile error output
	screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Backup] \",\"color\":\"gray\",\"italic\":true},{\"text\":\"fatal: could not create new backup - please tell your server admin\",\"color\":\"red\",\"italic\":true,\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"could not create file: ${servername}-${newhourly}, could not remove file: ${servername}-${oldhourly}, reason: not enough disk-space\"}]}}}]$(printf '\r')"
	exit 1
fi

# check if there is no backup from the current hour
if ! [ -d "${backupdirectory}/hourly/${servername}-${newhourly}" ]; then
	cp -r ${serverdirectory}/world ${backupdirectory}/hourly/${servername}-${newhourly}
else
	echo "warning: backup already exists!" >> ${backuplog}
	exit 1
fi

# check if there is a new hourly backup and output colorful success and error messages to ingame chat
if [ -d "${backupdirectory}/hourly/${servername}-${newhourly}" ]; then
	if [ -d "${backupdirectory}/hourly/${servername}-${oldhourly}" ]; then
		rm -r ${backupdirectory}/hourly/${servername}-${oldhourly}
	fi
	# get current world, backup and diskspace
	worldsize=$(du -sh world | cut -f1)
	backupsize=$(du -sh backups | cut -f1)
	diskspace=$(df -h / | tail -1 | awk '{print $4}')
	# ingame and logfile success output
	screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Backup] \",\"color\":\"gray\",\"italic\":true},{\"text\":\"successfully created new backup\",\"color\":\"green\",\"italic\":true,\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"created file: ${servername}-${newhourly}, removed file: ${servername}-${oldhourly}, current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}\"}]}}}]$(printf '\r')"
	echo "newest backup has been successfully created!" >> ${backuplog}
	echo "added ${backupdirectory}/hourly/${servername}-${newhourly}" >> ${backuplog}
	echo "oldest backup has been successfully removed!" >> ${backuplog}
	echo "removed ${backupdirectory}/hourly/${servername}-${oldhourly}" >> ${backuplog}
	echo "current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}" >> ${backuplog}
else
	screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Backup] \",\"color\":\"gray\",\"italic\":true},{\"text\":\"fatal: could not create new backup - please tell your server admin\",\"color\":\"red\",\"italic\":true,\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"could not create file: ${servername}-${newhourly}, could not remove file: ${servername}-${oldhourly}, reason: missing directorys\"}]}}}]$(printf '\r')"
	echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
	echo "warning: could not remove old backup!" >> ${backuplog}
	echo "fatal: could not backup world!" >> ${backuplog}
fi

# write one padding line to backuplog
echo "" >> ${backuplog}
