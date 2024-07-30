#!/bin/zsh

set -eo pipefail

SRC_REGION="eu-central-1"
DST_REGION="eu-south-1"

function check_replication_count() {
  local src_ecr_repos=("$@")
  local src_tagged_images
  local dst_tagged_images
  local unmatched_repos=()

  for repo in ${src_ecr_repos[@]}; do
    src_tagged_images=($(aws ecr list-images --repository-name "$repo" --region "$SRC_REGION" \
      --query 'imageIds[*].imageTag' --output json | jq -r -c '.[] | select(endswith("-es1"))'))

    dst_tagged_images=($(aws ecr list-images --repository-name "$repo" --region "$DST_REGION" \
            --query 'imageIds[*].imageTag' --output json | jq -r -c '.[] | select(endswith("-es1"))'))

    if [[ "${#src_tagged_images[@]}" -ne "${#dst_tagged_images[@]}" ]]; then
      unmatched_repos+=("$repo")
    fi
  done

  echo "${unmatched_repos[@]}"
}

function push_additional_tag() {
  local repo="$1"
  local image_tag="$2"
  local additional_tag="$3"
  local region="$4"
  local image_data

  image_data=$(aws ecr batch-get-image --repository-name "$repo"  --region "$region" \
    --image-ids imageTag="$image_tag" --query 'images[*].imageManifest' --output text)

  aws ecr put-image --repository-name "$repo" --region "$region" \
    --image-manifest "$image_data" --image-tag "$additional_tag" > /dev/null
}

function main() {
  local src_ecr_repos
  local all_repo_images_json
  local filtered_repo_images
  
  echo "Listing ECR repositories in $SRC_REGION..."

  src_ecr_repos=($(aws ecr describe-repositories --region "$SRC_REGION" \
    --query 'repositories[*].repositoryName' --output text))

  echo "Found ${#src_ecr_repos[@]} ECR repositories"

  for repo in ${src_ecr_repos[@]}; do
    echo "Listing tagged images in $repo..."
    
    all_repo_images_json=$(aws ecr describe-images --repository-name "$repo" --region "$SRC_REGION" \
      --query 'imageDetails[*].{ImageTags: imageTags, ImageDigest: imageDigest}' --output json)

    echo "Found $(echo "$all_repo_images_json" | jq length) images"

    filtered_repo_images=($(echo "$all_repo_images_json" \
      | jq -c -r '.[] | select(.ImageTags != null) | select([.ImageTags[] | select(endswith("-es1"))] | length == 0) | .ImageTags[]'))

    echo "Found ${#filtered_repo_images[@]} filtered images to replicate"   

    for image_tag in ${filtered_repo_images[@]}; do
      echo -n "Pushing ${repo}:${image_tag}-es1..."

      push_additional_tag "$repo" "$image_tag" "${image_tag}-es1" "$SRC_REGION"

      echo " ✅"
    done
  done

  local unmatched_repos
  local dst_ecr_repos

  unmatched_repos=$(check_replication_count ${src_ecr_repos[@]})
  echo "Unmatched repos: ${unmatched_repos[@]}"

  if [[ ${#unmatched_repos[@]} -gt 0 ]]; then; exit 1; fi

  echo "Listing ECR repositories in $DST_REGION..."

  dst_ecr_repos=($(aws ecr describe-repositories --region "$DST_REGION" \
    --query 'repositories[*].repositoryName' --output text))

  for repo in ${dst_ecr_repos[@]}; do
    echo "Listing tagged images in $repo..."
    
    all_repo_images_json=$(aws ecr describe-images --repository-name "$repo" --region "$DST_REGION" \
      --query 'imageDetails[*].{ImageTags: imageTags, ImageDigest: imageDigest}' --output json)

    echo "Found $(echo "$all_repo_images_json" | jq length) images"

    filtered_repo_images=($(echo "$all_repo_images_json" \
      | jq -c -r '.[] | select(.ImageTags != null) | select([.ImageTags[] | select(endswith("-es1"))] | length != 0) 
          | select([.ImageTags[] | select(endswith("-es1") | not)] | length == 0) | .ImageTags[]'))

    echo "Found ${#filtered_repo_images[@]} filtered images to tag without '-es1' suffix"

    for image_tag in ${filtered_repo_images[@]}; do
      echo -n "Pushing ${repo}:${image_tag%"-es1"}..."

      push_additional_tag "$repo" "$image_tag" "${image_tag%"-es1"}" "$DST_REGION"

      echo " ✅"
    done

  done
}

main
