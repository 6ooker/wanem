#! /bin/bash

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' # Reset colour after echo
script_dir=${0%/*}

# Banner
if [[ ! -z $(which figlet) ]]; then
    figlet WanEm -f slant
    echo -e "${y} - By 6ooker"
else
echo -e "\n\n\n\n
 _       __            ______
| |     / /___ _____  / ____/___ ___
| | /| / / __ `/ __ \\/ __/ / __ `__ \
| |/ |/ / /_/ / / / / /___/ / / / / /
|__/|__/\__,_/_/ /_/_____/_/ /_/ /_/
                       - By 6ooker\n\n\n"
fi

# Wait 3 seconds
for i in `seq 3 -1 1` ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done

# Dependencies
echo -e "${c}Installing required dependencies."; $r
sudo apt install -y libbpf0 libbsd0 libc6 libcap2 libdb5.3 libelf1 libmnl0 libselinux1 libxtables12 libcap2-bin debconf

# Update & Upgrade
echo -e "${c}Updating and upgrading before further setup."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y


# Installing dig and net-tools
echo -e "${c}Installing DNS Utils and net-tools"; $r
sudo apt install -y dnsutils net-tools

# Install iproute2
echo -e "${c}Installing iproute2"; $r
sudo apt install -y iproute2

installPython3() {
    sudo apt install -y python3
}

getServerIp() {
    serverip=$(whiptail --title "WebGUI - IP Address" --inputbox "\nPlease enter the IP on which the WebGUI should be available:" 20 50 "127.0.0.1" 3>&1 1>&2 2>&3)
    echo "$serverip"
}

selectInterfaces() {
    shopt -s nullglob
    available=($(basename -a /sys/class/net/*))
    intfchoices=$(whiptail --title "WanEm - Interfaces" --separate-output --checklist "Which Interfaces to use/show in the WebGUI." 20 35 15 \
    $(for ((i=0; i<${#available[@]}; i++)) ; do echo "$i ${available[$i]} on" ; done ) 3>&1 1>&2 2>&3)
    for choice in $intfchoices; do
        echo -n "${available[$choice]} "
    done
}

writeStarterScript() {
    cd $script_dir
    echo -e "#! /bin/bash\n
sudo screen -d -m -S \"tcgui\"
com=\"python3 $(pwd)/main.py --ip $(getServerIp) --port 80 --dev $(selectInterfaces)\"
sudo screen -S \"tcgui\" -X screen \$com
exit 0" | tee auto_start.sh >/dev/null
    chmod +x auto_start.sh
    echo -e "${c}Wrote auto_start.sh to $(pwd)"; $r
}

addCronJob() {
    if whiptail --yesno "Do you want to make the auto_start script run after reboot?" 10 40; then
        (crontab -l ; echo "@reboot $(pwd)/auto_start.sh") | crontab -
        echo -e "${c}Wrote to crontab file."; $r
    else
        echo "${c}Script will not run after reboot."; $r
    fi
}

# Exec install dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "WanEm Setup Script" --checklist "\nPlease select required software:\n(Press 'Space' to Select/Deselect, 'Enter' to install and 'Esc' to Cancel)" 30 80 20)
options=(1 "Python3, pip, python3-flask" on
    2 "Auto Start Script" on
    3 "NAT Mode *wip" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected
do
    case $choices in
        1)
        echo -e "${c}Installing Python3, Python3-pip and Python3-flask"; $r
        installPython3
        sudo apt install -y python3-pip python3-flask
        ;;

        2)
        echo -e "${c}Writing Auto Start Script"; $r
        writeStarterScript
        addCronJob
        ;;

        3)
        echo -e "${c}NAT Config is not yet available."; $r
        ;;
    esac
done

# Final Update & Upgrade
echo -e "${c}Updating and upgrading to finish setup."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
