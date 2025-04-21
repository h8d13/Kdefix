#!/bin/sh

CONFIG_FILE="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
TMP_FILE="$(mktemp)"

awk '
BEGIN { state = 0 }

/^\[Containments\]\[2\]\[Applets\]\[5\]$/ { state = 1; print; next }
state == 1 && /^immutability=1$/ { state = 2; print; next }
state == 2 && /^plugin=org\.kde\.plasma\.icontasks$/ {
    print
    print ""  # one newline
    print "[Containments][2][Applets][5][Configuration][General]"
    print "launchers=preferred://filemanager,applications:org.kde.konsole.desktop"
    state = 0
    next
}
{ print }
' "$CONFIG_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$CONFIG_FILE"
