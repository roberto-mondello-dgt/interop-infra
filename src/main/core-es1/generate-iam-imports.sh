target_file=$1

tf_targets=()

temp_file=$(mktemp)
grep -E '^resource|^module' $target_file >> $temp_file

while read -r line; do
  resource_type=$(echo $line | cut -d '"' -f 1 | tr -d ' ')
  class=$(echo $line | cut -d '"' -f 2 | tr -d ' ')
  if [[ "$resource_type" == "resource" ]] && [[ "$class" == "aws_iam_policy" ]]; then
    resource_name=$(echo $line | cut -d '"' -f 3 | tr -d ' ')
    echo "IAM policy: $resource_name"
  elif [[ "$resource_type" == "module" ]] && [[ "$class" ~= "_irsa$" ]]; then
    resource_name=$(echo $line | cut -d '"' -f 3 | tr -d ' ')

  else
  fi

done < $temp_file
