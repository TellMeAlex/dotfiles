#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring asdf..."

echo_info "Installing asdf..."

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

echo_done "asdf configuration!"
