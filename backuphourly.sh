
#!/bin/bash
# minecraft server backup script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# adding new daily backup
echo "creating new backup..." >> ${backuplog}
echo -e "${blue}creating new backup...${nocolor}"

# cp command
cp -r -f ${serverdirectory} ${backupdirectory}/daily/${servername}-${newdaily}

# output file location of new daily backup and write to logfile
echo "file available under ${backupdirectory}/daily/${servername}-${newdaily}" >> ${backuplog}
echo -e "${blue}file available under ${backupdirectory}/daily/${servername}-${newdaily}${nocolor}"

# deleting old hourly backup
echo "deleting old backup..." >> ${backuplog}
echo -e "${red}deleting old backup...${nocolor}"

# rm command
rm -r -f ${backupdirectory}/hourly/${servername}-${oldhourly}

# output file location of old hourly backup and write to logfile
echo "deleted ${backupdirectory}/hourly/${servername}-${oldhourly}" >> ${backuplog}
echo -e "${red}deleted ${backupdirectory}/hourly/${servername}-${oldhourly}${nocolor}"

# ingame output
screen -Rd ${servername} -X stuff "backup has finished!$(printf '\r')"
