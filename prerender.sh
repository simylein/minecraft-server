#!/bin/bash
# Minecraft Server start script

# read the settings
. ./settings.sh

# change to server directory
cd ${serverdirectory}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
        echo -e "${yellow}Server is not currently running!${nocolor}"
        exit 1
fi

# explain to user
echo -e "${blue}I will prerender your minecraft world by teleporting a selcted player through it${nocolor}"
echo -e "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

# ask for playername
read -p "Please enter a playername: " playername
echo -e "The player will be ${green}${playername}${nocolor}"

# ask for interval in seconds
echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 30 to 60 secounds"
echo "Please enter an interval in secounds. Example: sleep 60s"
read -p "interval:" interval
echo -e "The selected interval will be ${green}${interval}${nocolor}"

echo "I will now start to teleport the selected player through the world"
read -p "Continue? [Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}starting prerenderer...${nocolor}"
	else echo -e "${red}exiting...${nocolor}"
		exit 1
fi

# grid settings
x='128'

a='2048'
b='1792'
c='1536'
d='1280'
e='1024'
f='0768'
g='0512'
h='0256'
i='0000'
j='-0256'
k='-0512'
l='-0768'
m='-1024'
n='-1280'
o='-1536'
p='-1792'
q='-2048'

# teleporting sequence
echo "Setting player into spectator mode"
screen -Rd ${servername} -X stuff "gamemode spectator ${playername}$(printf '\r')"

# prerender start
echo "Prerendering started"
echo "Progress: [000/000]"
counter="1"
progress="1"
while [ ${counter} -lt 290 ]; do
    let "progress=counter"
    if (( ${progress} < 10 )); then
      progress=00${progress}
    elif (( ${progress} > 99 )); then
      progress=${progress}
    else
      progress=0${progress}
    fi
  echo "tp ${playername} ${a} ${x} ${a}"
  echo "Progress: [${progress}/289]"
counter=$((counter+1))
sleep 0.1s
done

# Sequence A
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${a}$(printf '\r')"
echo "Progress: [001/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${a}$(printf '\r')"
echo "Progress: [002/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${a}$(printf '\r')"
echo "Progress: [003/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${a}$(printf '\r')"
echo "Progress: [004/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${a}$(printf '\r')"
echo "Progress: [005/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${a}$(printf '\r')"
echo "Progress: [006/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${a}$(printf '\r')"
echo "Progress: [007/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${a}$(printf '\r')"
echo "Progress: [008/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${a}$(printf '\r')"
echo "Progress: [009/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${a}$(printf '\r')"
echo "Progress: [010/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${a}$(printf '\r')"
echo "Progress: [011/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${a}$(printf '\r')"
echo "Progress: [012/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${a}$(printf '\r')"
echo "Progress: [013/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${a}$(printf '\r')"
echo "Progress: [014/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${a}$(printf '\r')"
echo "Progress: [015/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${a}$(printf '\r')"
echo "Progress: [016/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${a}$(printf '\r')"
echo "Progress: [017/289]"
${interval}

# Sequence B
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${b}$(printf '\r')"
echo "Progress: [018/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${b}$(printf '\r')"
echo "Progress: [019/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${b}$(printf '\r')"
echo "Progress: [020/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${b}$(printf '\r')"
echo "Progress: [021/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${b}$(printf '\r')"
echo "Progress: [022/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${b}$(printf '\r')"
echo "Progress: [023/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${b}$(printf '\r')"
echo "Progress: [024/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${b}$(printf '\r')"
echo "Progress: [025/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${b}$(printf '\r')"
echo "Progress: [026/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${b}$(printf '\r')"
echo "Progress: [027/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${b}$(printf '\r')"
echo "Progress: [028/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${b}$(printf '\r')"
echo "Progress: [029/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${b}$(printf '\r')"
echo "Progress: [030/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${b}$(printf '\r')"
echo "Progress: [031/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${b}$(printf '\r')"
echo "Progress: [032/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${b}$(printf '\r')"
echo "Progress: [033/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${b}$(printf '\r')"
echo "Progress: [034/289]"
${interval}

# Sequence C
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${c}$(printf '\r')"
echo "Progress: [035/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${c}$(printf '\r')"
echo "Progress: [036/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${c}$(printf '\r')"
echo "Progress: [037/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${c}$(printf '\r')"
echo "Progress: [038/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${c}$(printf '\r')"
echo "Progress: [039/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${c}$(printf '\r')"
echo "Progress: [040/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${c}$(printf '\r')"
echo "Progress: [041/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${c}$(printf '\r')"
echo "Progress: [042/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${c}$(printf '\r')"
echo "Progress: [043/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${c}$(printf '\r')"
echo "Progress: [044/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${c}$(printf '\r')"
echo "Progress: [045/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${c}$(printf '\r')"
echo "Progress: [046/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${c}$(printf '\r')"
echo "Progress: [047/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${c}$(printf '\r')"
echo "Progress: [048/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${c}$(printf '\r')"
echo "Progress: [049/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${c}$(printf '\r')"
echo "Progress: [050/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${c}$(printf '\r')"
echo "Progress: [051/289]"
${interval}

# Sequence D
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${d}$(printf '\r')"
echo "Progress: [052/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${d}$(printf '\r')"
echo "Progress: [053/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${d}$(printf '\r')"
echo "Progress: [054/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${d}$(printf '\r')"
echo "Progress: [055/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${d}$(printf '\r')"
echo "Progress: [056/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${d}$(printf '\r')"
echo "Progress: [057/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${d}$(printf '\r')"
echo "Progress: [058/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${d}$(printf '\r')"
echo "Progress: [059/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${d}$(printf '\r')"
echo "Progress: [060/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${d}$(printf '\r')"
echo "Progress: [061/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${d}$(printf '\r')"
echo "Progress: [062/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${d}$(printf '\r')"
echo "Progress: [063/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${d}$(printf '\r')"
echo "Progress: [064/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${d}$(printf '\r')"
echo "Progress: [065/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${d}$(printf '\r')"
echo "Progress: [066/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${d}$(printf '\r')"
echo "Progress: [067/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${d}$(printf '\r')"
echo "Progress: [068/289]"
${interval}

# Sequence E
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${e}$(printf '\r')"
echo "Progress: [069/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${e}$(printf '\r')"
echo "Progress: [070/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${e}$(printf '\r')"
echo "Progress: [071/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${e}$(printf '\r')"
echo "Progress: [072/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${e}$(printf '\r')"
echo "Progress: [073/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${e}$(printf '\r')"
echo "Progress: [074/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${e}$(printf '\r')"
echo "Progress: [075/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${e}$(printf '\r')"
echo "Progress: [076/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${e}$(printf '\r')"
echo "Progress: [077/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${e}$(printf '\r')"
echo "Progress: [078/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${e}$(printf '\r')"
echo "Progress: [079/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${e}$(printf '\r')"
echo "Progress: [080/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${e}$(printf '\r')"
echo "Progress: [081/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${e}$(printf '\r')"
echo "Progress: [082/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${e}$(printf '\r')"
echo "Progress: [083/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${e}$(printf '\r')"
echo "Progress: [084/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${e}$(printf '\r')"
echo "Progress: [085/289]"
${interval}

# Sequence F
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${f}$(printf '\r')"
echo "Progress: [086/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${f}$(printf '\r')"
echo "Progress: [087/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${f}$(printf '\r')"
echo "Progress: [088/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${f}$(printf '\r')"
echo "Progress: [089/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${f}$(printf '\r')"
echo "Progress: [090/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${f}$(printf '\r')"
echo "Progress: [091/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${f}$(printf '\r')"
echo "Progress: [092/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${f}$(printf '\r')"
echo "Progress: [093/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${f}$(printf '\r')"
echo "Progress: [094/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${f}$(printf '\r')"
echo "Progress: [095/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${f}$(printf '\r')"
echo "Progress: [096/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${f}$(printf '\r')"
echo "Progress: [097/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${f}$(printf '\r')"
echo "Progress: [098/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${f}$(printf '\r')"
echo "Progress: [099/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${f}$(printf '\r')"
echo "Progress: [100/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${f}$(printf '\r')"
echo "Progress: [101/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${f}$(printf '\r')"
echo "Progress: [102/289]"
${interval}

# Sequence G
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${g}$(printf '\r')"
echo "Progress: [103/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${g}$(printf '\r')"
echo "Progress: [104/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${g}$(printf '\r')"
echo "Progress: [105/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${g}$(printf '\r')"
echo "Progress: [106/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${g}$(printf '\r')"
echo "Progress: [107/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${g}$(printf '\r')"
echo "Progress: [108/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${g}$(printf '\r')"
echo "Progress: [109/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${g}$(printf '\r')"
echo "Progress: [110/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${g}$(printf '\r')"
echo "Progress: [111/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${g}$(printf '\r')"
echo "Progress: [112/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${g}$(printf '\r')"
echo "Progress: [113/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${g}$(printf '\r')"
echo "Progress: [114/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${g}$(printf '\r')"
echo "Progress: [115/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${g}$(printf '\r')"
echo "Progress: [116/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${g}$(printf '\r')"
echo "Progress: [117/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${g}$(printf '\r')"
echo "Progress: [118/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${g}$(printf '\r')"
echo "Progress: [119/289]"
${interval}

# Sequence H
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${h}$(printf '\r')"
echo "Progress: [120/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${h}$(printf '\r')"
echo "Progress: [121/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${h}$(printf '\r')"
echo "Progress: [122/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${h}$(printf '\r')"
echo "Progress: [123/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${h}$(printf '\r')"
echo "Progress: [124/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${h}$(printf '\r')"
echo "Progress: [125/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${h}$(printf '\r')"
echo "Progress: [126/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${h}$(printf '\r')"
echo "Progress: [127/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${h}$(printf '\r')"
echo "Progress: [128/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${h}$(printf '\r')"
echo "Progress: [129/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${h}$(printf '\r')"
echo "Progress: [130/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${h}$(printf '\r')"
echo "Progress: [131/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${h}$(printf '\r')"
echo "Progress: [132/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${h}$(printf '\r')"
echo "Progress: [133/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${h}$(printf '\r')"
echo "Progress: [134/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${h}$(printf '\r')"
echo "Progress: [135/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${h}$(printf '\r')"
echo "Progress: [136/289]"
${interval}

# Sequence I
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${i}$(printf '\r')"
echo "Progress: [137/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${i}$(printf '\r')"
echo "Progress: [138/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${i}$(printf '\r')"
echo "Progress: [139/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${i}$(printf '\r')"
echo "Progress: [140/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${i}$(printf '\r')"
echo "Progress: [141/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${i}$(printf '\r')"
echo "Progress: [142/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${i}$(printf '\r')"
echo "Progress: [143/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${i}$(printf '\r')"
echo "Progress: [144/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${i}$(printf '\r')"
echo "Progress: [145/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${i}$(printf '\r')"
echo "Progress: [146/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${i}$(printf '\r')"
echo "Progress: [147/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${i}$(printf '\r')"
echo "Progress: [148/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${i}$(printf '\r')"
echo "Progress: [149/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${i}$(printf '\r')"
echo "Progress: [150/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${i}$(printf '\r')"
echo "Progress: [151/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${i}$(printf '\r')"
echo "Progress: [152/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${i}$(printf '\r')"
echo "Progress: [153/289]"
${interval}

# Sequence J
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${j}$(printf '\r')"
echo "Progress: [154/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${j}$(printf '\r')"
echo "Progress: [155/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${j}$(printf '\r')"
echo "Progress: [156/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${j}$(printf '\r')"
echo "Progress: [157/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${j}$(printf '\r')"
echo "Progress: [158/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${j}$(printf '\r')"
echo "Progress: [159/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${j}$(printf '\r')"
echo "Progress: [160/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${j}$(printf '\r')"
echo "Progress: [161/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${j}$(printf '\r')"
echo "Progress: [162/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${j}$(printf '\r')"
echo "Progress: [163/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${j}$(printf '\r')"
echo "Progress: [164/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${j}$(printf '\r')"
echo "Progress: [165/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${j}$(printf '\r')"
echo "Progress: [166/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${j}$(printf '\r')"
echo "Progress: [167/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${j}$(printf '\r')"
echo "Progress: [168/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${j}$(printf '\r')"
echo "Progress: [169/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${j}$(printf '\r')"
echo "Progress: [170/289]"
${interval}

# Sequence K
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${k}$(printf '\r')"
echo "Progress: [171/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${k}$(printf '\r')"
echo "Progress: [172/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${k}$(printf '\r')"
echo "Progress: [173/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${k}$(printf '\r')"
echo "Progress: [174/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${k}$(printf '\r')"
echo "Progress: [175/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${k}$(printf '\r')"
echo "Progress: [176/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${k}$(printf '\r')"
echo "Progress: [177/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${k}$(printf '\r')"
echo "Progress: [178/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${k}$(printf '\r')"
echo "Progress: [179/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${k}$(printf '\r')"
echo "Progress: [180/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${k}$(printf '\r')"
echo "Progress: [181/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${k}$(printf '\r')"
echo "Progress: [182/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${k}$(printf '\r')"
echo "Progress: [183/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${k}$(printf '\r')"
echo "Progress: [184/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${k}$(printf '\r')"
echo "Progress: [185/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${k}$(printf '\r')"
echo "Progress: [186/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${k}$(printf '\r')"
echo "Progress: [187/289]"
${interval}

# Sequence L
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${l}$(printf '\r')"
echo "Progress: [188/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${l}$(printf '\r')"
echo "Progress: [189/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${l}$(printf '\r')"
echo "Progress: [190/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${l}$(printf '\r')"
echo "Progress: [191/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${l}$(printf '\r')"
echo "Progress: [192/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${l}$(printf '\r')"
echo "Progress: [193/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${l}$(printf '\r')"
echo "Progress: [194/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${l}$(printf '\r')"
echo "Progress: [195/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${l}$(printf '\r')"
echo "Progress: [196/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${l}$(printf '\r')"
echo "Progress: [197/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${l}$(printf '\r')"
echo "Progress: [198/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${l}$(printf '\r')"
echo "Progress: [199/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${l}$(printf '\r')"
echo "Progress: [200/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${l}$(printf '\r')"
echo "Progress: [201/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${l}$(printf '\r')"
echo "Progress: [202/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${l}$(printf '\r')"
echo "Progress: [203/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${l}$(printf '\r')"
echo "Progress: [204/289]"
${interval}

# Sequence M
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${m}$(printf '\r')"
echo "Progress: [205/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${m}$(printf '\r')"
echo "Progress: [206/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${m}$(printf '\r')"
echo "Progress: [207/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${m}$(printf '\r')"
echo "Progress: [208/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${m}$(printf '\r')"
echo "Progress: [209/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${m}$(printf '\r')"
echo "Progress: [210/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${m}$(printf '\r')"
echo "Progress: [211/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${m}$(printf '\r')"
echo "Progress: [212/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${m}$(printf '\r')"
echo "Progress: [213/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${m}$(printf '\r')"
echo "Progress: [214/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${m}$(printf '\r')"
echo "Progress: [215/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${m}$(printf '\r')"
echo "Progress: [216/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${m}$(printf '\r')"
echo "Progress: [217/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${m}$(printf '\r')"
echo "Progress: [218/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${m}$(printf '\r')"
echo "Progress: [219/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${m}$(printf '\r')"
echo "Progress: [220/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${m}$(printf '\r')"
echo "Progress: [221/289]"
${interval}

# Sequence N
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${n}$(printf '\r')"
echo "Progress: [222/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${n}$(printf '\r')"
echo "Progress: [223/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${n}$(printf '\r')"
echo "Progress: [224/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${n}$(printf '\r')"
echo "Progress: [225/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${n}$(printf '\r')"
echo "Progress: [226/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${n}$(printf '\r')"
echo "Progress: [227/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${n}$(printf '\r')"
echo "Progress: [228/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${n}$(printf '\r')"
echo "Progress: [229/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${n}$(printf '\r')"
echo "Progress: [230/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${n}$(printf '\r')"
echo "Progress: [231/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${n}$(printf '\r')"
echo "Progress: [232/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${n}$(printf '\r')"
echo "Progress: [233/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${n}$(printf '\r')"
echo "Progress: [234/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${n}$(printf '\r')"
echo "Progress: [235/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${n}$(printf '\r')"
echo "Progress: [236/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${n}$(printf '\r')"
echo "Progress: [237/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${n}$(printf '\r')"
echo "Progress: [238/289]"
${interval}

# Sequence O
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${o}$(printf '\r')"
echo "Progress: [239/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${o}$(printf '\r')"
echo "Progress: [240/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${o}$(printf '\r')"
echo "Progress: [241/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${o}$(printf '\r')"
echo "Progress: [242/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${o}$(printf '\r')"
echo "Progress: [243/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${o}$(printf '\r')"
echo "Progress: [244/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${o}$(printf '\r')"
echo "Progress: [245/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${o}$(printf '\r')"
echo "Progress: [246/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${o}$(printf '\r')"
echo "Progress: [247/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${o}$(printf '\r')"
echo "Progress: [248/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${o}$(printf '\r')"
echo "Progress: [249/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${o}$(printf '\r')"
echo "Progress: [250/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${o}$(printf '\r')"
echo "Progress: [251/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${o}$(printf '\r')"
echo "Progress: [252/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${o}$(printf '\r')"
echo "Progress: [253/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${o}$(printf '\r')"
echo "Progress: [254/289]"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${o}$(printf '\r')"
echo "Progress: [255/289]"
${interval}

# command line finished message
screen -Rd ${servername} -X stuff "Prerendering of your world has finished$(printf '\r')"
echo -e "${green}Prerendering of your world has finished${nocolor}"
screen -Rd ${servername} -X stuff "Rendered 4096 blocks of area$(printf '\r')"
echo -e "${green}Rendered 16777216 [4096 times 4096] blocks of area${nocolor}"

# kick player with finished message
screen -Rd ${servername} -X stuff "kick ${playername} prerendering of your world has finished$(printf '\r')"
