#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# adding new hourly backup
echo -e "${blue}creating new backup...${nocolor}"
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"

cp -r -f ${serverdirectory} ${backupdirectory}/hourly/${servername}-${new}

# output file location of new hourly backup
echo -e "${blue}file available under ${backupdirectory}/hourly/${servername}-${new}${nocolor}"
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/hourly/${servername}-${new}$(printf '\r')"

# deleting old hourly backup
echo -e "${red}deleting old backup...${nocolor}"
screen -Rd ${servername} -X stuff "say deleting old backup...$(printf '\r')"

rm -r -f ${backupdirectory}/hourly/${servername}-${old}

# output deleted hourly backup location
echo -e "${red}deleted ${backupdirectory}/hourly/${servername}-${old}${nocolor}"
screen -Rd ${servername} -X stuff "say deleted ${backupdirectory}/hourly/${servername}-${old}$(printf '\r')"
