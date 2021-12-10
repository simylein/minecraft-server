#!/bin/bash
# mincraft server prerender script

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -s "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.functions is missing$(tput sgr0)"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -s "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.properties is missing$(tput sgr0)"
	exit 1
fi

# read server.settings file with error checking
if [[ -s "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> "fatalerror.log"
	echo "$(tput setaf 1)fatal: server.settings is missing$(tput sgr0)"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> "fatalerror.log"
	echo "${red}fatal: serverdirectory is missing${nocolor}"
	exit 1
fi

# log to debug if true
CheckDebug "executing pre-render script"

# parsing script arguments
ParseScriptArguments "$@"

# check for script lock
CheckScriptLock

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	PrintToTerminal "warn" "server is not currently running!"
	exit 1
fi

# let user chose between online and offline prerendering
echo "would you like to startup online or offline pre-rendering?"
PS3="your choice: "
method=("online" "offline")
select method in "${method[@]}"; do
	case $method in
		"online")
			PrintToTerminal "action" "starting online pre-renderer..."

			# explain to user
			PrintToTerminal "info" "i will pre-render your minecraft world by teleporting a selected player through it"
			PrintToTerminal "info" "i will scan so to speak in a grid with the spacing of 256 blocks"

			# ask for playername
			read -p "please enter a player-name: " playername
			echo "the player will be ${green}${playername}${nocolor}"

			# ask for cords
			PS3="which radius would you like to pre-render? "
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
						cords=( 4096 3840 3584 3328 3072 2816 2560 2304 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -2304 -2560 -2816 -3072 -3328 -3584 -3840 -4096 )
						area="4096 times 4096"
						totalblocks=$((8192 * 8192))
						amount="33"
						break
					;;
					"8192*8192")
						cords=( 8192 7936 7680 7414 7168 6912 6656 6400 6144 5888 5632 5376 5120 4864 4608 4352 4096 3840 3584 3328 3072 2816 2560 2304 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -2304 -2560 -2816 -3072 -3328 -3584 -3840 -4096 -4352 -4608 -4864 -5120 -5376 -5632 -5888 -6144 -6400 -6656 -6912 -7168 -7414 -7680 -7936 -8192 )
						area="8192 times 8192"
						totalblocks=$((16384 * 16384))
						amount="65"
						break
					;;
					*) echo "please choose an option from the list: " ;;
				esac
			done

			# ask for interval in seconds
			PrintToTerminal "info" "i would like to know how fast you want to scan your world"
			PrintToTerminal "info" "i would recommend an interval of 20 to 80 seconds depending on your server resources"
			PrintToTerminal "info" "please enter an interval in seconds. Example: ${yellow}60${nocolor}"
			read -p "interval: " interval
			regex="^([8-9]|[1-9][0-9]|1[0-2][0-8])$"
			while [[ ! ${interval} =~ ${regex} ]]; do
				read -p "please enter an interval between 8 and 128 seconds: " interval
			done

			# calculate some internal intervals
			between=$((${interval} / 4))
			between="sleep ${between}s"
			estimated=$((${interval} * ${amount} * ${amount}))
			interval="sleep ${interval}s"
			PrintToTerminal "info" "the selected grid will be ${green}${area}${nocolor}"
			PrintToTerminal "info" "the selected interval will be ${green}${interval}${nocolor}"
			PrintToTerminal "info" "the selected between will be ${green}${between}${nocolor}"

			# ask for permission to proceed
			echo "I will now start to teleport the selected player through the world"
			echo "It will take about ${estimated} seconds to finish pre-rendering"
			read -p "Continue? [Y/N]: "
			regex="^(Y|y|N|n)$"
			while [[ ! ${REPLY} =~ ${regex} ]]; do
				read -p "Please press Y or N: " REPLY
			done
			if [[ ${REPLY} =~ ^[Yy]$ ]]
				then echo "${green}starting pre-renderer...${nocolor}"
				else echo "${red}exiting...${nocolor}"
					exit 1
			fi

			# prerender start
			echo "pre-rendering started"
			echo "progress: [0/$((${amount} * ${amount}))]"
			sleep 2s

			# teleport script with progress
			totalamount=$((${amount} * ${amount}))
			progress="1"
			counter="1"
			y="120"
			for x in "${cords[@]}"; do
				for z in "${cords[@]}"; do
					let "progress=counter"
					# progress counter
					ProgressBar "${blue}[Script]${nocolor} Progress: [${progress}/${totalamount}]" "${progress}" "${totalamount}"
					# teleporting with facing directions
					PrintToScreen "tp ${playername} ${x} ~ ${z} 0 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ~ ${z} 90 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ~ ${z} 180 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ~ ${z} 270 0"
					${between}
					counter=$((counter+1))
				done
			done

			# command line finished message
			PrintToScreen "say pre-rendering of your world has finished"
			
			# user info
			PrintToTerminal "info" "pre-rendering of your world has finished"
			PrintToTerminal "info" "rendered ${totalblocks} [${area}] blocks of area"

			# kick player with finished message
			PrintToScreen "kick ${playername} pre-rendering of your world has finished"
			break
		;;
		"offline")
			PrintToTerminal "action" "starting offline pre-renderer..."

			# explain to user
			PrintToTerminal "info" "i will pre-render your minecraft world by setting the world-spawn to various coordinates and then restarting the server over and over"
			PrintToTerminal "info" "i will scan so to speak in a grid with the spacing of 256 blocks"

			# ask for cords
			PS3="Which radius would you like to pre-render? "
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
					*) echo "please choose an option from the list: " ;;
				esac
			done

			# ask for interval in seconds
			echo "I would like to know how fast you want to scan your world"
			echo "I would recommend an interval of 20 to 80 seconds depending on your server resources"
			echo "Please enter an interval in seconds. Example: ${yellow}60${nocolor}"
			read -p "interval: " interval
			regex="^([8-9]|[1-9][0-9]|1[0-2][0-8])$"
			while [[ ! ${interval} =~ ${regex} ]]; do
				read -p "Please enter an interval between 8 and 128 seconds: " interval
			done
			interval="sleep ${interval}s"

			# ask for permission to proceed
			echo "I will now start to pre-render your world using world-spawns and server restart"
			read -p "Continue? [Y/N]: "
			regex="^(Y|y|N|n)$"
			while [[ ! ${REPLY} =~ ${regex} ]]; do
				read -p "Please press Y or N: " REPLY
			done
			if [[ ${REPLY} =~ ^[Yy]$ ]]
				then echo "${green}starting pre-renderer...${nocolor}"
				else echo "${red}exiting...${nocolor}"
					exit 1
			fi

			# prerender start
			PrintToTerminal "info" "pre-rendering started"
			sleep 2s

			# teleport script with progress
			totalamount=$((${amount} * ${amount}))
			progress="1"
			counting="1"
			y="120"
			for x in "${cords[@]}"; do
				for z in "${cords[@]}"; do
					let "progress=counting"
					# progress counter
					ProgressBar "${blue}[Script]${nocolor} Progress: [${progress}/${totalamount}]" "${progress}" "${totalamount}"
					# setworldspawn to x y z
					PrintToScreen "setworldspawn ${x} ~ ${z}"
					# stop server
					./stop.sh --quiet --now
					# start server
					./start.sh --quiet
				done
			done

			# reset spawnpoint
			PrintToScreen "setworldspawn 0 ~ 0"

			# command line info
			PrintToTerminal "ok" "pre-rendering of your world has finished"
			break
		;;
			*) echo "please choose an option from the list: " ;;
	esac
done

# log to debug if true
CheckDebug "executed pre-render script"

# exit with code 0
exit 0
