#!/bin/sh
# prepend to file :)
CONFIG_FILE="/home/harch/.config/ksmserverrc"
TMP_FILE="$(mktemp)"
echo -e "[General]\nloginMode=emptySession" > "$TMP_FILE"
cat "$CONFIG_FILE" >> "$TMP_FILE"
mv "$TMP_FILE" "$CONFIG_FILE"

f="/home/harch/.config/kscreenlockerrc"
t=$(mktemp)

while IFS= read -r line; do
  echo "$line" >> "$t"
  [[ "$line" == "[Daemon]" ]] && echo "LockGrace=300" >> "$t"
  [[ "$line" == "Timeout="* ]] && echo "Timeout=15" >> "$t" && continue
done < "$f"

mv "$t" "$f"
