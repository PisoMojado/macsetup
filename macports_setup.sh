#!/usr/bin/env sh

PORT_BIN_DIR="$( cd "$( dirname "$0" )" && pwd )/macports"
PORT_GIT="${PORT_BIN_DIR}/.git"

which port
if [ $? -eq 0 ]
then
    echo "Macports is already installed. Running selfupdate"
    sudo port selfupdate
    sudo port upgrade outdated
else
    echo "Pulling the latest release branch for MacPorts"
    ## We pull the latest branches from remote and checkout the latest for installation
    git --git-dir="${PORT_GIT}" fetch origin
    BRANCHES="$(git --git-dir=/Users/michael/Code/macsetup/macports/.git branch -r)"
    LATEST_RELEASE_BRANCH="$(echo ${BRANCHES} | tr " " "\n" | sort | grep release | tail -1)"
    LOCAL_BRANCH_NAME="$(echo "${LATEST_RELEASE_BRANCH}" | sed s_origin/__g )"
    git --git-dir="${PORT_GIT}" checkout -b "${LOCAL_BRANCH_NAME}" "${LATEST_RELEASE_BRANCH}" || git --git-dir="${PORT_GIT}" reset --hard "${LATEST_RELEASE_BRANCH}"

    if [ $? -ne 0 ]
    then
        echo "Something went wrong with pulling latest release source"
	exit 1
    fi
    echo "Compling MacPorts"
    cd "${PORT_BIN_DIR}"
    ./configure && make
    if [ $? -ne 0 ]
    then
        echo "Something went wrong with compiling macports"
	exit 1
    fi
    read -p "Please confirm installation of macports (y): " -n 1 -er
    if [ "${REPLY}" = "y" ]
    then
        sudo make install
	echo "Adding port paths to this shell environment"
	export PATH="/opt/local/bin:/opt/local/sbin:${PATH}"
	sudo port selfupdate
    else
        echo "Exiting installation"
	exit 50
    fi
fi

# Install ports
PORTS="bash zsh git rsync emacs vim emacs-app python36 python27 haskell-platform perl5 ispell"
echo "The script will now install the following ports: $(echo ${PORTS} | sed 's/ /, /g')"
read -p "Confirm installation of ports (y): " -n 1 -er
if [ "${REPLY}" = "y" ]
then
    sudo port install ${PORTS}
else
    echo "Did not install ports."
    exit 50
fi

