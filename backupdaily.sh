#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# adding new hourly backup
echo "creating new backup..." >> ${backuplog}
echo -e "${blue}creating new backup...${nocolor}"

# cp command
cp -r -f ${serverdirectory} ${backupdirectory}/hourly/${servername}-${newhourly}

# output file location of new daily backup and write to logfile
echo "file available under ${backupdirectory}/hourly/${servername}-${newhourly}" >> ${backuplog}
echo -e "${blue}file available under ${backupdirectory}/hourly/${servername}-${newhourly}${nocolor}"

# deleting old daily backup
echo "deleting old backup..." >> ${backuplog}
echo -e "${red}deleting old backup...${nocolor}"

# rm command
rm -r -f ${backupdirectory}/daily/${servername}-${olddaily}

# output file location of old daily backup and write to logfile
echo "deleted ${backupdirectory}/daily/${servername}-${olddaily}" >> ${backuplog}
echo -e "${red}deleted ${backupdirectory}/daily/${servername}-${olddaily}${nocolor}"

# ingame output
screen -Rd ${servername} -X stuff "backup has finished!$(printf '\r')"
