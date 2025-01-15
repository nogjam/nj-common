#! /usr/bin/env bash
#
# NAME
#   install_setup.sh
#
# SYNOPSIS
#   . install_setup.sh
#
# DESCRIPTION
#   Sets up the environment for doing installation. Intended to be sourced.

bash_source="${BASH_SOURCE[0]}"
if [ -z "$bash_source" ]; then
    bash_source="$0"
fi

file_path=$(realpath "$bash_source")
repo_root=$(realpath $(dirname "$file_path"))

. "$repo_root"/scripts/bash_common.sh
