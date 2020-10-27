#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# adding new daily backup
echo -e "${blue}creating new backup...${nocolor}" >> ${backuplog}
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"

cp -r -f ${serverdirectory} ${backupdirectory}/daily/${servername}-${newdaily}

# output file location of new daily backup
echo -e "${blue}file available under ${backupdirectory}/daily/${servername}-${newdaily}${nocolor}" >> ${backuplog}
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/daily/${servername}-${newdaily}$(printf '\r')"

# deleting old daily backup
echo -e "${red}deleting old backup...${nocolor}" >> ${backuplog}
screen -Rd ${servername} -X stuff "say deleting old backup...$(printf '\r')"

rm -r -f ${backupdirectory}/daily/${servername}-${olddaily}

# output deleted daily backup location
echo -e "${red}deleted ${backupdirectory}/daily/${servername}-${olddaily}${nocolor}" >> ${backuplog}
screen -Rd ${servername} -X stuff "say deleted ${backupdirectory}/daily/${servername}-${olddaily}$(printf '\r')"
