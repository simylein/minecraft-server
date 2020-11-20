#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# write date to logfile
echo "${date} executing backup-hourly script" >> ${screenlog}

# ingame output
screen -Rd ${servername} -X stuff "say backing up files...$(printf '\r')"

# adding new hourly backup
echo "creating new backup..." >> ${backuplog}
echo -e "${blue}creating new backup...${nocolor}"

# cp command
cp -r -f ${serverdirectory} ${backupdirectory}/hourly/${servername}-${newhourly}

# output file location of new hourly backup and write to logfile
echo "file available under ${backupdirectory}/hourly/${servername}-${newhourly}" >> ${backuplog}
echo -e "${blue}file available under ${backupdirectory}/hourly/${servername}-${newhourly}${nocolor}"

# deleting old hourly backup
echo "deleting old backup..." >> ${backuplog}
echo -e "${red}deleting old backup...${nocolor}"

# rm command
rm -r -f ${backupdirectory}/hourly/${servername}-${oldhourly}

# output file location of old hourly backup and write to logfile
echo "deleted ${backupdirectory}/hourly/${servername}-${oldhourly}" >> ${backuplog}
echo -e "${red}deleted ${backupdirectory}/hourly/${servername}-${oldhourly}${nocolor}"

# ingame output
screen -Rd ${servername} -X stuff "say backup has successfully finished!$(printf '\r')"
