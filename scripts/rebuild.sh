#!/bin/bash

# get hostname
HOSTNAME=$(scutil --get LocalHostName)

# known hosts
VM_HOST="MKs-Virtual-Machine"
MACBOOK_HOST="Manuels-MacBook-Pro"

# Check if current host is known
if [ "$HOSTNAME" = "$VM_HOST" ] || [ "$HOSTNAME" = "$MACBOOK_HOST" ]; then
  echo "Building configuration for host: $HOSTNAME"
  darwin-rebuild switch --flake ~/git/config#"$HOSTNAME" --show-trace --impure
else
  echo "Error: Unknown host '$HOSTNAME'"
  echo "Known hosts are: $VM_HOST, $MACBOOK_HOST"
  exit 1
fi
