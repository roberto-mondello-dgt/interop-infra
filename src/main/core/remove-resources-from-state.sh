#!/bin/zsh

set -eo pipefail

RESOURCES_FILE="./resources-to-remove-from-state.txt"
CURRENT_STATE="$(terraform state list)"

# OLD_IFS="$IFS"
# IFS=$'\n'

total_removed=0

while read -r address; do
  if [[ -z "$address" || "$address" =~ ^# ]]; then
    echo "Empty or commented line, skipping ⚠️"
    continue
  fi
  
  set +eo pipefail
  if ! $(echo "$CURRENT_STATE" | grep -q "^$address"); then
    echo "$address missing in TF state, skipping ⚠️"
    continue
  fi
  set -eo pipefail

  echo -n "Removing $address..."

  terraform state rm "$address" > /dev/null

  ((++total_removed))

  echo " ✅"

done < "$RESOURCES_FILE"

echo "➡️  Removed $total_removed resources from TF state"
