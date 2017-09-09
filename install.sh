#!/usr/bin/env sh

SETUP_DIR="$( cd "$( dirname "$0" )" && pwd )"

# Install XCode Tools
#"${SETUP_DIR}/xcode_install.sh"

# Install macports & ports
#"${SETUP_DIR}/macports_setup.sh"

# Install homebrew & brews
#"${SETUP_DIR}/homebrew_setup.sh"

# Install dotfiles
"${SETUP_DIR}/dotfiles/install.sh"

echo "Mac Setup Complete!"

