#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# get current world and backup size
worldsize=$(du -sh world | cut -f1)
backupsize=$(du -sh backups | cut -f1)

# write date to logfiles
echo "${date} executing backup-weekly script" >> ${screenlog}
echo "${date} executing backup-weekly script" >> ${backuplog}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}server is not currently running!${nocolor}"
	echo "server is not currently running!" >> ${screenlog}
	exit 1
fi

# check if there is no backup from the current week
if ! [ -d "${backupdirectory}/weekly/${servername}-${newweekly}" ]; then
	cp -r ${serverdirectory}/world ${backupdirectory}/weekly/${servername}-${newweekly}
else
	echo "warning: backup already exists!" >> ${backuplog}
	exit 1
fi

# check if there is a new weekly backup and output colorful success and error messages to ingame chat
if [ -d "${backupdirectory}/weekly/${servername}-${newweekly}" ]; then
	if [ -d "${backupdirectory}/weekly/${servername}-${oldweekly}" ]; then
		rm -r ${backupdirectory}/weekly/${servername}-${oldweekly}
	fi
	screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Backup] \",\"color\":\"gray\",\"italic\":true},{\"text\":\"successfully created new backup\",\"color\":\"green\",\"italic\":true,\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"created file: ${servername}-${newweekly}, removed file: ${servername}-${oldweekly}, current world size: ${worldsize}, current backup size: ${backupsize}\"}]}}}]$(printf '\r')"
	echo "newest backup has been successfully created!" >> ${backuplog}
	echo "added ${backupdirectory}/weekly/${servername}-${newweekly}" >> ${backuplog}
	echo "oldest backup has been successfully removed!" >> ${backuplog}
	echo "removed ${backupdirectory}/weekly/${servername}-${oldweekly}" >> ${backuplog}
	echo "current world size: ${worldsize}, current backup size: ${backupsize}" >> ${backuplog}
else
	screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Backup] \",\"color\":\"gray\",\"italic\":true},{\"text\":\"fatal: could not create new backup - please tell your server admin\",\"color\":\"red\",\"italic\":true,\"hoverEvent\":{\"action\":\"show_text\",\"value\":{\"text\":\"\",\"extra\":[{\"text\":\"could not create file: ${servername}-${newweekly}, could not remove file: ${servername}-${oldweekly}, current world size: ${worldsize}, current backup size: ${backupsize}\"}]}}}]$(printf '\r')"
	echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
	echo "warning: could not remove old backup!" >> ${backuplog}
	echo "fatal: could not backup world!" >> ${backuplog}
fi

# write one padding line to backuplog
echo "" >> ${backuplog}