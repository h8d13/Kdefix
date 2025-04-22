#!/bin/sh
# cool prepend sequence to file :)
CONFIG_FILE="/home/harch/.config/ksmserverrc"
TMP_FILE="$(mktemp)"
echo -e "[General]\nloginMode=emptySession" > "$TMP_FILE"
cat "$CONFIG_FILE" >> "$TMP_FILE"
mv "$TMP_FILE" "$CONFIG_FILE"
# Basiclally just makes it so that new sessions are fresh. 

# Simple override the whole file for 15 min lockout and 5 min password grace. 
CONFIG_FILE2="/home/harch/.config/kscreenlockerrc"
cat <<EOF > $CONFIG_FILE2
[Daemon]
LockGrace=300
Timeout=15
EOF
