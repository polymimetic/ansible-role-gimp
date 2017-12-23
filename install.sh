#! /usr/bin/env bash
set -e
###########################################################################
#
# Gimp Bootstrap Installer
# https://github.com/polymimetic/ansible-role-gimp
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-gimp/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-gimp.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-gimp/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Gimp
# https://www.gimp.org/
#
# http://tipsonubuntu.com/2016/08/02/install-gimp-2-9-5-ubuntu-16-04/
###########################################################################

install_gimp() {
  e_title "Installing Gimp"

  local gimp_files="${SCRIPT_PATH}/files/gimp"

  # Add Gimp PPA
  if ! grep -q "otto-kesselgulasch/gimp" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo apt-get update
  fi

  # Install gimp
  sudo apt-get install -yq gimp gimp-plugin-registry gimp-data-extras

  # Ensure Gimp directory exists
  if [[ ! -d "${HOME}/.gimp-2.8" ]]; then
    mkdir -p "${HOME}/.gimp-2.8"
  fi

  # Gimp configuration
  cp "${gimp_files}/sessionrc" "${HOME}/.gimp-2.8/sessionrc"

  e_success "Gimp installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_gimp
}

program_start