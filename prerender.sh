#!/bin/bash
# mincraft server prerender script

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Server is not currently running!${nocolor}"
	exit 1
fi

# explain to user
echo -e "${blue}I will prerender your minecraft world by teleporting a selected player through it${nocolor}"
echo -e "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

# ask for playername
read -p "Please enter a playername: " playername
echo -e "The player will be ${green}${playername}${nocolor}"

# ask for cords
PS3="Which radius would you like to prerender? "
grid=("1024*1024" "2048*2048" "4096*4096" "8192*8192")
select grid in "${grid[@]}"; do
	case $grid in
		"1024*1024")
			cords=( 1024 768 512 256 0 -256 -512 -768 -1024 )
			area="1024 times 1024"
			totalblocks=$((2048 * 2048))
			amount="9"
			break
		;;
		"2048*2048")
			cords=( 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 )
			area="2048 times 2048"
			totalblocks=$((4096 * 4096))
			amount="17"
			break
		;;
		"4096*4096")
			cords=( 4096 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -4096 )
			area="4096 times 4096"
			totalblocks=$((8192 * 8192))
			amount="33"
			break
		;;
		"8192*8192")
			cords=( 8192 6144 4096 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -4096 -6144 -8192 )
			area="8192 times 8192"
			totalblocks=$((16384 * 16384))
			amount="65"
			break
		;;
		*) echo "Please choose an option from the list: ";;
	esac
done

# ask for interval in seconds
echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 20 to 80 seconds depending on your server recources"
echo -e "Please enter an interval in seconds. Example: ${yellow}60${nocolor}"
read -p "interval:" interval

# calculate some internal intervals
between=$((${interval} / 4))
between="sleep ${between}s"
estimated=$((${interval} * ${amount} * ${amount}))
interval="sleep ${interval}s"
echo -e "The selected grid will be ${green}${area}${nocolor}"
echo -e "The selected interval will be ${green}${interval}${nocolor}"
echo -e "The selected between will be ${green}${between}${nocolor}"

# ask for permission to proceed
echo "I will now start to teleport the selected player through the world"
echo "It will take about ${estimated} seconds"
read -p "Continue? [Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}starting prerenderer...${nocolor}"
	else echo -e "${red}exiting...${nocolor}"
		exit 1
fi

# prerender start
echo "Prerendering started"
echo "Progress: [0/$((${amount} * ${amount}))]"
sleep 2s

# teleport script with progress
progress="1"
counter="1"
y="128"
for x in "${cords[@]}"; do
	for z in "${cords[@]}"; do
		let "progress=counter"
		# progress counter
		echo -e "${blue}[Script]${nocolor} Progress: [${progress}/$((${amount} * ${amount}))]"
		# teleporting with facing directions
		PrintToScreen "tp ${playername} ${x} ${y} ${z} 0 0"
		${between}
		PrintToScreen "tp ${playername} ${x} ${y} ${z} 90 0"
		${between}
		PrintToScreen "tp ${playername} ${x} ${y} ${z} 180 0"
		${between}
		PrintToScreen "tp ${playername} ${x} ${y} ${z} 270 0"
		${between}
		counter=$((counter+1))
	done
	${interval}
done

# command line finished message
PrintToScreen "say Prerendering of your world has finished"
echo -e "${blue}[Script]${nocolor} ${green}Prerendering of your world has finished${nocolor}"

echo -e "${blue}[Script]${nocolor} ${green}Rendered ${totalblocks} [${area}] blocks of area${nocolor}"

# kick player with finished message
screen -Rd ${servername} -X stuff "kick ${playername} prerendering of your world has finished$(printf '\r')"
