#!/usr/bin/env sh

# Check if XCode tools are installed. These are essential for installing MacPorts
echo "Searching for XCode Tools:" && xcode-select -p                   
XCODE_STATUS=$?
if [ ${XCODE_STATUS} -eq 2 ]
then
    read -p "XCode tools not found. Install Tools?" -n 1 -er
    if [ ${REPLY} =~ ^[Yy]$ ]                                          
    then
        echo "Installing..."
        xcode-select --install
    else
        echo "Cannot install package managers without XCode Tools"
        exit 1
    fi
elif [ ${XCODE_STATUS} -eq 0 ]
then
    echo "XCode Tools are already installed"
else
    echo "xcode-select did not behave as expected"
    exit 1
fi

