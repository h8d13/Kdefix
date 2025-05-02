#!/bin/sh

TARGET_USER=$(cat /etc/passwd | grep '/home/' | head -1 | cut -d: -f1)
KB_LAYOUT=$(ls /etc/keymap/*.bmap.gz 2>/dev/null | head -1 | sed 's|/etc/keymap/||' | sed 's|\.bmap\.gz$||') 
########################################## FIX LOGIN KB
echo "Setting up Keyboard..." 
mkdir -p "/usr/share/sddm/scripts/"
cat >> /usr/share/sddm/scripts/Xsetup << EOF
setxkbmap "$KB_LAYOUT"
EOF
chmod +x /usr/share/sddm/scripts/Xsetup
########################################## FIX GLOBAL KB
mkdir -p "/home/$TARGET_USER/.config"
cat > "/home/$TARGET_USER/.config/kxkbrc" << EOF
[Layout]
LayoutList=$KB_LAYOUT
Use=True
EOF
######################################### FIX SESSIONS
echo "Setting up KDE Config..." 
## Cool prepend move totally useless file doesnt exist yet but it's cool ya know
CONFIG_FILE2="/home/$TARGET_USER/.config/ksmserverrc"
TMP_FILE="$(mktemp)"
echo -e "[General]\nloginMode=emptySession" > "$TMP_FILE"
cat "$CONFIG_FILE2" >> "$TMP_FILE" 2>/dev/null # ignore not exist error idk 
mv "$TMP_FILE" "$CONFIG_FILE2"
# Basiclally just makes it so that new sessions are fresh (something that I always thought was a stupid default value... 
# Simple override the whole file for 15 min lockout and 5 min password grace. 
CONFIG_FILE3="/home/$TARGET_USER/.config/kscreenlockerrc"
cat <<EOF > $CONFIG_FILE3
[Daemon]
LockGrace=300
Timeout=30
EOF
