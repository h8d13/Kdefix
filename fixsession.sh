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
  [[ "$line" == "[Daemon]" ]] && {
    echo "$line" >> "$t"
    echo "LockGrace=300" >> "$t"
    echo "Timeout=15" >> "$t"
    skip=1
    continue
  }
  [[ "$line" == Timeout=* && $skip == 1 ]] && continue
  echo "$line" >> "$t"
done < "$f"

mv "$t" "$f"
