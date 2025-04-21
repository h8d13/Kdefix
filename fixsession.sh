#!/bin/sh
# prepend to file :)
CONFIG_FILE="/home/harch/.config/ksmserverrc"
TMP_FILE="$(mktemp)"
echo -e "[General]\nloginMode=emptySession" > "$TMP_FILE"
cat "$CONFIG_FILE" >> "$TMP_FILE"
mv "$TMP_FILE" "$CONFIG_FILE"


CONFIG_FILE2="/home/harch/.config/kscreenlockerrc"
cat <<EOF > $CONFIG_FILE2
[Daemon]
LockGrace=300
Timeout=15
EOF
