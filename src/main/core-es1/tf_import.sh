#!/bin/bash

set -euo pipefail

env=$1
resourceMappingFile=$2

currentStateList="$(./terraform.sh state "$env" list)"

while IFS= read -r line
do
  tf_address="$(echo "$line" | cut -d " " -f1)"
  resource_id="$(echo "$line" | cut -d " " -f2)"

  #ignore empty lines
  [ -z "$line" ] && continue

  # ignore commented lines
  grep -q "^#" <<< "$tf_address" && continue

  if grep -Fq "$tf_address" <<< "$currentStateList"; then
    echo -e "\n##### Skip: $tf_address (already imported) #####"
    continue
  fi

  echo -e "\n##### Import: $line #####"
  ./terraform.sh import "$env" "$tf_address" "$resource_id" > /dev/null
done < "$resourceMappingFile"

