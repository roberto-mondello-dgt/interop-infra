#!/bin/zsh
set -eo pipefail

function filter_secrets() {
  local secrets=("$@")
  local filtered=()

  for secret in "${secrets[@]}"; do
    if [[ ! "$secret" = ses/* ]] && [[ ! "$secret" = "generated-jwt-fallback-replication-token" ]]; then
      filtered+=("$secret")
    fi
  done
  
  echo "${filtered[@]}"
}

function main() {
  local ec1_secrets_all
  local es1_secrets_all

  local ec1_secrets
  local es1_secrets

  ec1_secrets_all=($(aws secretsmanager list-secrets --region 'eu-central-1' --query 'SecretList[*].Name' --output text))
  es1_secrets_all=($(aws secretsmanager list-secrets --region 'eu-south-1' --query 'SecretList[*].Name' --output text))

  ec1_secrets=($(filter_secrets "${ec1_secrets_all[@]}"))
  es1_secrets=($(filter_secrets "${es1_secrets_all[@]}"))

  declare -A ec1_secrets_map
  declare -A es1_secrets_map

  for secret in "${ec1_secrets[@]}"; do
    ec1_secrets_map["$secret"]=1
  done

  for secret in "${es1_secrets[@]}"; do
    es1_secrets_map["$secret"]=1
  done

  local secret_value

  for secret in "${ec1_secrets[@]}"; do
    if [[ -z "${es1_secrets_map["$secret"]}" ]]; then
      echo "$secret missing in eu-south-1"
      continue
    fi

    echo "Copying $secret to eu-south-1"
    secret_value=$(aws secretsmanager get-secret-value --secret-id "$secret" --region 'eu-central-1' --query 'SecretString' --output text)
    aws secretsmanager put-secret-value --secret-id "$secret" --region 'eu-south-1' --secret-string "$secret_value" > /dev/null
  done
}

main
