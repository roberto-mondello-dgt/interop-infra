#!/bin/zsh

set -o pipefail

function main() {
  local buckets_all=()
  local bucket_region
  local ec1_buckets_all=()
  local ec1_source_buckets=()
  local dest_bucket

  # buckets_all=($(aws s3api list-buckets --query 'Buckets[].Name' --output text))
  #
  # echo "Listing eu-central-1 buckets"
  # for bucket in "${buckets_all[@]}"; do
  #   bucket_region=$(aws s3api head-bucket --bucket "$bucket" --query 'BucketRegion' --output text)
  #
  #   if [[ "$bucket_region" = "eu-central-1" ]]; then
  #     ec1_buckets_all+=("$bucket")
  #   fi
  # done
  #
  # echo "Filtering eu-central-1 source buckets to migrate"
  # for bucket in "${ec1_buckets_all[@]}"; do
  #   dest_bucket="${bucket}-es1"
  #   aws s3api head-bucket --bucket "$dest_bucket" > /dev/null 2>&1
  #
  #   if [[ $? -ne 0 ]]; then; continue; fi
  #   
  #   ec1_source_buckets+=("$bucket")
  # done
  
  ec1_source_buckets=("interop-application-documents-dev")
  echo "Found ${#ec1_source_buckets[@]} eu-central-1 source buckets to migrate"

  local operation
  local report
  local manifest_generator
  local priority=999


  for source_bucket in "${ec1_source_buckets[@]}"; do
    dest_bucket="${source_bucket}-es1"

    echo -n "Creating batch job: $source_bucket --> $dest_bucket..."

    operation='{"S3ReplicateObject":{}}'

    report=$(jq -n --arg src_bucket "$source_bucket" '{ 
      "Bucket": "arn:aws:s3:::interop-s3-batch-operations-dev", 
      "Prefix": "reports/\($src_bucket)/",
      "Format": "Report_CSV_20180820",
      "Enabled": true,
      "ReportScope": "FailedTasksOnly"
    }')

    manifest_generator=$(jq -n --arg src_bucket "$source_bucket" '{ 
      "S3JobManifestGenerator": { 
        "SourceBucket": "arn:aws:s3:::\($src_bucket)",
        "EnableManifestOutput": false,
        "Filter": {
          "EligibleForReplication": true, 
          "ObjectReplicationStatuses": ["NONE","FAILED"]
        } 
      } 
    }')

    aws s3control create-job \
      --region "eu-central-1" \
      --account-id "505630707203" \
      --operation "$operation" \
      --report "$report" \
      --manifest-generator "$manifest_generator" \
      --role-arn "arn:aws:iam::505630707203:role/interop-s3-region-migration-dev" \
      --priority "$priority" \
      --description "$source_bucket --> $dest_bucket" \
      --no-confirmation-required > /dev/null

    echo "✅"

    priority=$((priority-1))
  done
}

main
