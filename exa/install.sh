#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring exa..."

echo_info "Installing exa..."
sudo apt install exa

echo_done "exa configuration!"
