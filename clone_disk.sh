#!/bin/bash

set -e

SOURCE_DEVICE="/dev/sda"
TARGET_DEVICE="/dev/sdb"

echo "WARNING: This script will completely overwrite $TARGET_DEVICE with data from $SOURCE_DEVICE"
echo "All data on $TARGET_DEVICE will be permanently lost!"
echo ""
echo "Source device: $SOURCE_DEVICE"
echo "Target device: $TARGET_DEVICE"
echo ""

read -p "Are you absolutely sure you want to continue? (type 'YES' to confirm): " confirmation

if [ "$confirmation" != "YES" ]; then
    echo "Operation cancelled."
    exit 1
fi

if [ ! -b "$SOURCE_DEVICE" ]; then
    echo "Error: Source device $SOURCE_DEVICE not found or not a block device"
    exit 1
fi

if [ ! -b "$TARGET_DEVICE" ]; then
    echo "Error: Target device $TARGET_DEVICE not found or not a block device"
    exit 1
fi

SOURCE_SIZE=$(blockdev --getsize64 "$SOURCE_DEVICE")
TARGET_SIZE=$(blockdev --getsize64 "$TARGET_DEVICE")

echo "Source device size: $(numfmt --to=iec $SOURCE_SIZE)"
echo "Target device size: $(numfmt --to=iec $TARGET_SIZE)"

if [ "$TARGET_SIZE" -lt "$SOURCE_SIZE" ]; then
    echo "Error: Target device is smaller than source device"
    exit 1
fi

echo ""
echo "Starting disk clone operation..."
echo "This may take several hours depending on disk size."
echo ""

if command -v pv >/dev/null 2>&1; then
    echo "Using pv for progress monitoring..."
    dd if="$SOURCE_DEVICE" bs=64K | pv -s "$SOURCE_SIZE" | dd of="$TARGET_DEVICE" bs=64K
else
    echo "Using dd with built-in progress (requires dd with status=progress support)..."
    dd if="$SOURCE_DEVICE" of="$TARGET_DEVICE" bs=64K status=progress
fi

sync

echo ""
echo "Clone operation completed successfully!"
echo "Syncing filesystems..."
echo "Done."