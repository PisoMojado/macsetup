#!/usr/bin/env sh

# Install homebrew
echo "Searching for homebrew installation..."
which brew
if [ $? -eq 0 ]
then
    echo "Found homebrew installation. Updating homebrew"
    brew update
else
    read -p "Installation not found. Please confirm installation of homebrew (y): " -n 1 -er
    if [ "${REPLY}" = "y" ]
    then
        echo "Running the recommended installation for homebrew. See https://brew.sh for more info"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Cancelled installation of homebrew and brews"
	exit 50
    fi
fi

# Install brews
BREWS="khd"
SERVICE_BREWS="khd"
echo "This script will now install the following brews: ${BREWS}"
read -p "Confirm installation (y): " -n 1 -er
if [ "${REPLY}" = "y" ]
then
    brew install ${BREWS}
else
    echo "Cancelled installation of brews"
    exit 50
fi

echo "This script will now activate the following homebrew services: ${SERVICE_BREWS}"
read -p "Confirm service activations (y): " -n 1 -er
if [ "${REPLY}" = "y" ]
then
    for b in ${SERVICE_BREWS}
    do
        brew services start ${b}
    done
    echo "Services activated"
else
    echo "Skipped activation of services."
    # Skipped activation is also a success for this script
    exit 0
fi

