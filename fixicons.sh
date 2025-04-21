#!/bin/sh

CONFIG_FILE="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
TMP_FILE="$(mktemp)"

awk '
BEGIN {
    match_found = 0
}
{
    print

    # Look for exact match pattern in 3 lines
    if ($0 == "[Containments][2][Applets][5]") {
        getline next1
        print next1
        if (next1 == "immutability=1") {
            getline next2
            print next2
            if (next2 == "plugin=org.kde.plasma.icontasks") {
                # Insert block after matching 3 lines
                print ""
                print "[Containments][2][Applets][5][Configuration][General]"
                print "launchers=preferred://filemanager,applications:org.kde.konsole.desktop"
                match_found = 1
            }
        }
    }
}
END {
    if (!match_found) {
        print ""
        print "# Warning: Block not inserted, matching pattern not found"
    }
}
' "$CONFIG_FILE" > "$TMP_FILE"

# Replace original file
mv "$TMP_FILE" "$CONFIG_FILE"
