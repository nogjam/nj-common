#! /usr/bin/env bash
#
# NAME
# 	bash_common.sh
#
# SYNOPSIS
# 	. bash_common.sh
#
# DESCRIPTION
# 	A library of common script utilities for bash.
#
# 	The way this script is documented in these comments is an example of how to
# 	set up usage/help text for your own scripts. The result is a single source
# 	of truth for users of your script and readers of its source code.

################################ INITIALIZATION ################################

# Make sure we don't source more than once.
[[ $__bash_common_sourced__ ]] && return
__bash_common_sourced__=1

####################### ERROR HANDLING AND OTHER LOGGING #######################

error() {
	# ANSI escape codes:
	# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
	echo -e >&2 "\e[31m$1\e[0m"
}

warn() {
	echo -e >&1 "\e[33m$1\e[0m"
}

################################# ENVIRONMENT ##################################

does_command_exist() {
	# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script
	command -v "$1" >/dev/null 2>&1
}

################################ PYTHON POETRY #################################

is_poetry_active() {
	[ -n "${POETRY_ACTIVE}" ]
}

does_command_come_from_poetry() {
	# https://stackoverflow.com/questions/2172352/in-bash-how-can-i-check-if-a-string-begins-with-some-value
	[[ "$(which "$1")" == "$(poetry env info --path)"* ]]
}

verify_poetry_setup() {
	if ! is_poetry_active; then
		error "Please use a poetry shell. Run: poetry shell"
		exit 1
	elif ! does_command_come_from_poetry "$1"; then
		error "Please install dependencies. Run: poetry install"
		exit 1
	fi
}

############################## STRING OPERATIONS ###############################

ltrim() {
	# https://stackoverflow.com/a/3352015/7232335
	echo "${1#"${1%%[![:space:]]*}"}"
}

################################### UPDATES ####################################

retrieve_and_compare() {
    local uri="$1"
    local local_path="$2"

    local lines_changed
    local file_name

    wget "$uri" --directory-prefix /tmp --backups=1
    file_name=$(echo "$uri" | rev | cut -d "/" -f 1 | rev)
    lines_changed=$(diff "$local_path" /tmp/"${file_name}" | wc -l)
    if [ $lines_changed -gt 0 ]; then
        warn "WARNING: Change found: $1 vs. $local_path"
    fi
}

#################################### USAGE #####################################

NAME_SECTION=()
SYNOPSIS_SECTION=()
DESCRIPTION_SECTION=()

parse_usage_from_file_header() {
	local name_mode=false
	local synopsis_mode=false
	local description_mode=false

	while IFS= read line; do
		line_text=""
		if [ -z "$line" ]
		then
			break
		# Single quotes preserve literal string values, not
		# doing variable expansion and command substitution.
		# Here, "!" could otherwise be problematic.
		elif [ "${line:0:2}" == '#!' ]
		then
			# Shebang line
			continue
		fi
		line_text="${line:2}" # Remove comment characters (first two)

		# Check which section we're reading.
		if [ "$line_text" = "NAME" ]; then
			name_mode=true
			synopsis_mode=false
			description_mode=false

		elif [ "$line_text" = "SYNOPSIS" ]; then
			name_mode=false
			synopsis_mode=true
			description_mode=false

		elif [ "$line_text" = "DESCRIPTION" ]; then
			name_mode=false
			synopsis_mode=false
			description_mode=true

		# Append to the correct section.
		elif $name_mode; then
			NAME_SECTION+=("$line_text")

		elif $synopsis_mode; then
			SYNOPSIS_SECTION+=("$line_text")

		elif $description_mode; then
			DESCRIPTION_SECTION+=("$line_text")

		fi

	done < "$1"
}

generate_usage() {
	local params;
	params=$(getopt \
		--options ndt \
		--longoptions name,description,titles \
		--name "$0" \
		-- "$@"
	)
	eval set -- "$params"
	unset params

	local name=false
	# Synopsis is always used.
	local description=false
	local titles=false
	while true; do
		case $1 in
			-n | --name)
				shift
				name=true
				;;
			-d | --description)
				shift
				description=true
				;;
			-t | --titles)
				shift
				titles=true
				;;
			--)
				shift
				if [ -z "${1:-}" ]; then
					error "Missing file argument."
				fi
				file_handle="$1"
				break
				;;
		esac
	done

	parse_usage_from_file_header "$file_handle"

	if $name; then
		if $titles; then echo "NAME"; fi
		for line in "${NAME_SECTION[@]}"; do
			if $titles; then
				echo "$line"
			else
				ltrim "$line"
			fi
		done
	fi

	if $titles; then echo "SYNOPSIS"; fi
	for line in "${SYNOPSIS_SECTION[@]}"; do
		if $titles; then
			echo "$line"
		else
			ltrim "$line"
		fi
	done

	if $description; then
		if $titles; then echo "DESCRIPTION"; fi
		for line in "${DESCRIPTION_SECTION[@]}"; do
			if $titles; then
				echo "$line"
			else
				ltrim "$line"
			fi
		done
	fi
}
