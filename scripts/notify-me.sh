#!/bin/bash

# Sends a notification at the specified time.

message="${1}"
time="${2}"

hint_kde_konsole=""
kde_konsole_desktop_file="/usr/share/applications/org.kde.konsole.desktop"

if [ -f $kde_konsole_desktop_file ]; then
	hint_kde_konsole="-h 'string:desktop-entry:org.kde.konsole'"
fi

echo "notify-send ${hint_kde_konsole} '${message}'" | at "${time}"
