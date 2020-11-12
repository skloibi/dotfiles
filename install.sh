#!/bin/bash

set -e

function show_usage() {
  printf "Usage $0 [options [parameters]]\n"
  printf "\n"
  printf "Options: \n"
  printf " -b|--background, Require no user input - keep custom information as-is\n"
  printf " -h|--help, Print help\n"

  return 0
}

while [ ! -z "$1" ];do
  case "$1" in
    -h|--help)
      show_usage
      exit 0
      ;;
    -b|--background)
      shift
      NO_USER_INPUT=1
      echo "> Requiring no user input"
      ;;
    -x|--x11)
      shift
      INSTALL_X11_BINDINGS=1
      echo "> Installing x11 bindings"
      ;;
    *)
      echo "Unsupported argument: '$1'"
      show_usage
  esac
done

echo "> Starting installation of dotfiles"

echo ":: Setting up environment variables"
stow environment.d

echo ":: Setting up default Git configuration"
function register_git_author() {
  read -p 'Git display name: '
  local name="${REPLY}"
  read -p 'Git email address: '
  local email="${REPLY}"
  unset REPLY

  cat <<EOT > $HOME/.gitauthor
[user]
  name = ${name}
  email = ${email}
EOT
}
if [ -z "$NO_USER_INPUT" ]; then
  register_git_author
fi
stow git

echo ":: Setting up fonts"
stow fonts

echo ":: Setting up Terminator"
stow terminator

echo ":: Setting up Zsh"
# .zshrc may have been created on installation
rm ~/.zshrc
stow zsh
stow zsh-plugins
stow zsh-themes

echo ":: Setting up Vim"
stow vim

echo ":: Setting up theme configuration"
stow gtk
# remove old Trolltech configuration
rm -f ~/.config/Trolltech.conf
stow --override=.config/Trolltech.conf qt

echo ":: Setting up Sway configuration"
stow sway
# copy configuration file templates
cp -n sway/.config/sway/inputs.dotfile.template $HOME/.config/sway/inputs
cp -n sway/.config/sway/outputs.dotfile.template $HOME/.config/sway/outputs
cp -n sway/.config/sway/keybindings.dotfile.template $HOME/.config/sway/keybindings
stow swaylock
stow wofi
stow waybar
stow mako

# create background directory
mkdir -p $HOME/.background

if [ -n "$INSTALL_X11_BINDINGS" ]; then
  echo ":: Setting up I3 configuration"
  stow i3
  stow polybar
fi

echo "> Completed dotfile installation"

