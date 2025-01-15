#! /usr/bin/env bash
#
# NAME
#   install.sh
#
# SYNOPSIS
#   ./install.sh
#
# DESCRIPTION
#   A script for installing common dependencies on a Linux machine.

file_path=$(realpath "${BASH_SOURCE[0]}")
repo_root=$(realpath $(dirname "$file_path"))

. "$repo_root"/install_setup.sh

echo "Retrieving web assets..."
retrieve_and_compare "https://raw.githubusercontent.com/anmolmathias/kitty-alabaster/refs/heads/master/alabaster-dark.conf" "${repo_root}/config/kitty/themes/Alabaster Dark.conf"
retrieve_and_compare "https://raw.githubusercontent.com/habamax/vim-habamax/refs/heads/master/colors/habamax.vim" "${repo_root}/config/.vim/colors/habamax.vim"

echo "Creating symlinks..."
# Files
ln -s "$repo_root"/config/.clang-format ~/.clang-format
ln -s "$repo_root"/config/.vimrc ~/.vimrc
# Directories
ln -s "$repo_root"/config/.vim ~
ln -s "$repo_root"/config/kitty ~/.config
