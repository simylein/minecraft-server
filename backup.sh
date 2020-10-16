#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# adding new backup
echo -e "${blue}creating new backup...${nocolor}"
screen -Rd ${servername} -X stuff "say creating new backup...$(printf '\r')"

cp -r ${serverdirectory} ${backupdirectory}/${servername}-${new}

# output file location of new backup
echo -e "${blue}file available under ${backupdirectory}/${servername}-${new}${nocolor}"
screen -Rd ${servername} -X stuff "say file available under ${backupdirectory}/${servername}-${new}$(printf '\r')"

# deleting old backup
echo -e "${red}deleting old backup...${nocolor}"
screen -Rd ${servername} -X stuff "say deleting old backup...$(printf '\r')"

rm -r ${backupdirectory}/${servername}-${old}

# output deleted backup location
echo -e "${red}deleted ${backupdirectory}/${servername}-${old}${nocolor}"
screen -Rd ${servername} -X stuff "say deleted ${backupdirectory}/${servername}-${old}$(printf '\r')"
