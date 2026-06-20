#!/bin/bash
set -euo pipefail

# == Logging Function ==
log() {
  echo "[$(date '+%H:%M:%S')] $*"
}

# == Variables ==
STACK_NAME="month2-project"
TEMPLATE="month2.yaml"
KEY_PAIR="virus-key"                # ✅ Correct key pair name in AWS
DB_USERNAME="admin"
DB_PASSWORD="QWERTYUIOP"
REGION="eu-north-1"

# == Auto-detect IP ==
get_my_ip() {
  MY_IP=$(curl -s checkip.amazonaws.com)
  if [ -z "$MY_IP" ]; then
    log "WARNING: Could not auto-detect IP. Using default."
    MY_IP="102.91.72.69"  # Fallback
  else
    log "Detected IP: $MY_IP"
  fi
}

# == Error Handler ==
trap 'log "ERROR: Script failed at line ${LINENO}"' ERR

# == Main ==
log "Starting deployment of stack: $STACK_NAME"

# 👇 ADD THIS LINE - Call the function to detect your IP
get_my_ip

aws cloudformation deploy \
  --template-file "$TEMPLATE" \
  --stack-name "$STACK_NAME" \
  --parameter-overrides \
    KeyPairName="$KEY_PAIR" \
    MyIP="$MY_IP/32" \
    DBUsername="$DB_USERNAME" \
    DBPassword="$DB_PASSWORD" \
  --capabilities CAPABILITY_IAM \
  --region "$REGION"

log "Stack deployed successfully! ✅"

log "Getting stack outputs..."
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs[*].[Description,OutputKey,OutputValue]" \
  --output table

log "Done! 🚀"