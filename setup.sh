#! /bin/bash

# Determine OS name
os=$(uname)

# Install git
if [ "$os" = "Linux" ]; then

echo "This is a Linux machine"

    if [[ -f /etc/redhat-release ]]; then
        pkg_manager=yum
    elif [[ -f /etc/debian_version ]]; then
        pkg_manager=apt
    fi

    if [ $pkg_manager = "yum" ]; then
        yum install git -y
    elif [ $pkg_manager = "apt" ]; then
        apt install git -y
    fi

elif [ "$os" = "Darwin" ]; then

echo "this is a Mac machine"
    brew install git

else
    echo "Unsupported OS"
    exit 1

fi

echo "Git installed!"


# Grant execution permissions to the script
chmod +x setup.sh

# Test config
echo "Testing git configuration..."

if git --version >/dev/null 2>&1; then
    echo "Git is configured correctly."
else
    echo "Git configuration test failed. PLease check the installation."
fi