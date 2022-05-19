#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring snap..."
echo_info "Installing snap pkgs..."
sudo apt install snapd

PKGS=(
  # breaktimer # Manage periodic breaks. Avoid eye-strain and RSI.
    keep-presence # Keep your computer on.
  # colorpicker-app # A mininal but complete Colorpicker desktop app
  gnome-boxes # Virtual machine manager
  taskbook # Tasks, boards & notes for the command-line habitat.
  insomnia # Insomnia REST Client
  fkill # Fabulously kill processes. Cross-platform.
  # mutt # Mutt is a sophisticated text-based Mail User Agent.
  # youtube-dl # Download videos from youtube.com or other video platforms.
  docker # Docker container runtime.
  # robo3t-snap # Robo 3T (formerly Robomongo) is the free lightweight GUI for MongoDB enthusiasts.
)

for pkg in "${PKGS[@]}"; do
  echo_info "Installing ${pkg}..."
  if ! [ -x "$(command -v rainbow)" ]; then
    sudo snap install "$pkg"
  else
    rainbow --red=error --yellow=warning snap install "$pkg"
  fi
  echo_done "${pkg} installed!"
done

CLASSIC_PKGS=(
  # gitkraken # For repo management, in-app code editing & issue tracking.
  # cool-retro-term # cool-retro-term is a terminal emulator.
  code # Visual Studio Code. Code editing. Redefined.
  # hollywood # fill your console with Hollywood melodrama technobabble.
  # heroku # CLI client for Heroku.
  # datagrip # IntelliJ-based IDE for databases and SQL
)

for pkg in "${CLASSIC_PKGS[@]}"; do
  echo_info "Installing ${pkg}..."
  if ! [ -x "$(command -v rainbow)" ]; then
    sudo snap install "$pkg" --classic
  else
    rainbow --red=error --yellow=warning snap install "$pkg"
  fi
  echo_done "${pkg} installed!"
done

echo_done "snap configuration!"
