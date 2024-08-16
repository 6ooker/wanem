#! /bin/bash

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' # Reset colour after echo
script_dir=${0%/*}

# Banner
if [[ ! -z $(which figlet) ]]; then
    figlet WanEm
    echo -e "${y} - By 6ooker"
else
echo -e "\n\n\n\n
WanEm\n\n\n"

fi

# Wait 3 seconds
for i in `seq 3 -1 1` ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done

# Dependencies
#echo -e "${c}Installing required dependencies."; $r
#sudo apt install -y libbpf0 libbsd0 libc6 libcap2 libdb5.3 libelf1 libmnl0 libselinux1 libxtables12 libcap2-bin debconf

# Update & Upgrade
#echo -e "${c}Updating and upgrading before further setup."; $r
#sudo apt update && sudo apt upgrade -y
#sudo apt --fix-broken install -y


# Installing dig and net-tools
#echo -e "${c}Installing DNS Utils and net-tools"; $r
#sudo apt install -y dnsutils net-tools

# Install iproute2
#echo -e "${c}Installing iproute2"; $r
#sudo apt install -y iproute2

installPython3() {
    sudo apt install -y python3
}

writeStarterScript() {
    cd $script_dir
    echo -e "#! /bin/bash\n
sudo screen -d -m -S \"tcgui\"
com=\"python3 $(pwd)/main.py --ip $1 --port 80 --regex $2\"
sudo screen -S \"tcgui\" -X screen \$com
exit 0" | tee auto_start.sh >/dev/null
    chmod +x auto_start.sh
}

checkInstalled() {
    echo -e "${c}Checking if $1 is installed."; $r
    source ~/.profile
    source ~/.bashrc
    if [[ -z $(which $1) ]]; then
        echo -e "${c}$1 is not installed, installing it first."; $r
        $2
    else
        echo -e "${c}$1 is already installed, Skipping."; $r
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
        writeStarterScript x.x.x.x regex
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
