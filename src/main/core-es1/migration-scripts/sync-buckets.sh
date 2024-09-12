#!/bin/zsh

set -eo pipefail

ENV="att"
SRC_REGION="eu-central-1"
ACCOUNT_ID="533267098416"
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/interop-s3-region-migration-${ENV}"
BATCH_OPERATIONS_BUCKET="interop-s3-batch-reports-${ENV}"

function main() {
  local buckets_all=()
  local bucket_region
  local ec1_buckets_all=()
  local ec1_source_buckets=()
  local dest_bucket

  buckets_all=($(aws s3api list-buckets --query 'Buckets[].Name' --output text))

  echo "Listing $SRC_REGION buckets"
  for bucket in "${buckets_all[@]}"; do
    bucket_region=$(aws s3api head-bucket --bucket "$bucket" --query 'BucketRegion' --output text)

    if [[ "$bucket_region" = "$SRC_REGION" ]]; then
      ec1_buckets_all+=("$bucket")
    fi
  done

  echo "Filtering $SRC_REGION source buckets to migrate"
  set +e
  for bucket in "${ec1_buckets_all[@]}"; do
    dest_bucket="${bucket}-es1"

    aws s3api head-bucket --bucket "$dest_bucket" > /dev/null 2>&1

    if [[ $? -ne 0 ]]; then; continue; fi
    
    ec1_source_buckets+=("$bucket")
  done
  set -e
  
  echo "Found ${#ec1_source_buckets[@]} $SRC_REGION source buckets to migrate"

  local operation
  local report
  local manifest_generator
  local priority=999


  for source_bucket in "${ec1_source_buckets[@]}"; do
    dest_bucket="${source_bucket}-es1"

    echo -n "Creating batch job: $source_bucket --> $dest_bucket..."

    # operation=$(jq -n --arg dest_bucket "$dest_bucket" --arg op_bucket "$BATCH_OPERATIONS_BUCKET" '{
    #   "S3PutObjectCopy": {
    #     "TargetResource": "arn:aws:s3:::\($dest_bucket)"
    #   }
    # }')

    operation='{"S3ReplicateObject":{}}'

    report=$(jq -n --arg src_bucket "$source_bucket" --arg op_bucket "$BATCH_OPERATIONS_BUCKET" '{ 
      "Bucket": "arn:aws:s3:::\($op_bucket)", 
      "Prefix": "reports/\($src_bucket)",
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

    # manifest_generator=$(jq -n --arg src_bucket "$source_bucket" '{ 
    #   "S3JobManifestGenerator": { 
    #     "SourceBucket": "arn:aws:s3:::\($src_bucket)",
    #     "EnableManifestOutput": false,
    #     "Filter": {
    #       "EligibleForReplication": true, 
    #       "ObjectReplicationStatuses": ["NONE","FAILED"]
    #     } 
    #   } 
    # }')

    # manifest_generator=$(jq -n --arg src_bucket "$source_bucket" --arg op_bucket "$BATCH_OPERATIONS_BUCKET" '{ 
    #   "S3JobManifestGenerator": { 
    #     "SourceBucket": "arn:aws:s3:::\($src_bucket)",
    #     "EnableManifestOutput": true,
    #     "ManifestOutputLocation": {
    #       "Bucket": "arn:aws:s3:::\($op_bucket)",
    #       "ManifestPrefix": "manifests/\($src_bucket)",
    #       "ManifestFormat": "S3InventoryReport_CSV_20211130"
    #     }
    #   }
    # }')

    aws s3control create-job \
      --region "$SRC_REGION" \
      --account-id "$ACCOUNT_ID" \
      --operation "$operation" \
      --report "$report" \
      --manifest-generator "$manifest_generator" \
      --role-arn "$ROLE_ARN" \
      --priority "$priority" \
      --description "$source_bucket --> $dest_bucket" \
      --no-confirmation-required > /dev/null

    echo "✅"

    priority=$((priority-1))
  done
}

main
