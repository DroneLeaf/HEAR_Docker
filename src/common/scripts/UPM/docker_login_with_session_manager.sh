#!/bin/bash


SESSION_ENDPOINT="${SESSION_ENDPOINT:-http://localhost:3001/session-manager/session-token}"
AWS_REGION="${AWS_REGION:-me-south-1}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ecr_login() {

    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} curl or wget required"
        exit 1
    fi
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} AWS CLI required"
        apt  install awscli -y
    fi
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} Docker required"
        exit 1
    fi

    # Fetch credentials from session manager
    local response=""

    if command -v curl &> /dev/null; then
        response=$(curl --location --request POST -s "$SESSION_ENDPOINT" 2>/dev/null)
        elif command -v wget &> /dev/null; then
        response=$(wget --quiet --method=POST --output-document=- "$SESSION_ENDPOINT" 2>/dev/null)
    fi

    if [ $? -ne 0 ] || [ -z "$response" ]; then
        echo -e "${RED}[ERROR]${NC} Failed to fetch credentials from $SESSION_ENDPOINT"
        exit 1
    fi

    # Clean response
    response=$(echo "$response" | sed 's/^\xEF\xBB\xBF//' | tr -d '\r' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')


    # Extract credentials - handle multiple formats
    local access_key_id="" secret_access_key="" session_token=""

    # Try JavaScript object literal format first: {accessKeyId:VALUE,secretAccessKey:VALUE,sessionToken:VALUE}
    if [[ "$response" =~ ^\{[a-zA-Z]+: ]]; then
        local cleaned=$(echo "$response" | sed 's/^{//; s/}$//')
        access_key_id=$(echo "$cleaned" | grep -o 'accessKeyId:[^,]*' | cut -d':' -f2)
        secret_access_key=$(echo "$cleaned" | grep -o 'secretAccessKey:[^,]*' | cut -d':' -f2)
        session_token=$(echo "$cleaned" | grep -o 'sessionToken:[^,]*' | cut -d':' -f2)

    # Try JSON format with jq if available
    elif command -v jq &> /dev/null && echo "$response" | jq . &> /dev/null; then
        access_key_id=$(echo "$response" | jq -r '.accessKeyId // .AccessKeyId // .Credentials.AccessKeyId // empty')
        secret_access_key=$(echo "$response" | jq -r '.secretAccessKey // .SecretAccessKey // .Credentials.SecretAccessKey // empty')
        session_token=$(echo "$response" | jq -r '.sessionToken // .SessionToken // .Credentials.SessionToken // empty')

    # Try text patterns
    else
        access_key_id=$(echo "$response" | grep -oE 'ASIA[A-Z0-9]{16}' | head -1)
        secret_access_key=$(echo "$response" | grep -oE '[A-Za-z0-9/+=]{40}' | head -1)
        session_token=$(echo "$response" | grep -oE '[A-Za-z0-9/+=]{100,}' | head -1)
    fi

    # Validate credentials
    if [ -z "$access_key_id" ] || [ -z "$secret_access_key" ] || [ -z "$session_token" ]; then
        echo -e "${RED}[ERROR]${NC} Failed to extract AWS credentials"
        echo -e "${RED}[ERROR]${NC} Access Key: ${access_key_id:0:8}... (${#access_key_id} chars)"
        echo -e "${RED}[ERROR]${NC} Secret Key: ${secret_access_key:0:8}... (${#secret_access_key} chars)"
        echo -e "${RED}[ERROR]${NC} Session Token: ${session_token:0:20}... (${#session_token} chars)"
        exit 1
    fi


    # Export AWS credentials
    export AWS_ACCESS_KEY_ID="$access_key_id"
    export AWS_SECRET_ACCESS_KEY="$secret_access_key"
    export AWS_SESSION_TOKEN="$session_token"

    # Get account ID and ECR registry URL
    local account_id=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
    if [ $? -ne 0 ] || [ -z "$account_id" ]; then
        echo -e "${RED}[ERROR]${NC} Failed to get AWS account ID - check credentials"
        exit 1
    fi

    local ecr_registry="${account_id}.dkr.ecr.${AWS_REGION}.amazonaws.com"

    # Get ECR login token and login to Docker
    local ecr_password=$(aws ecr get-login-password --region "$AWS_REGION" 2>/dev/null)
    if [ $? -ne 0 ] || [ -z "$ecr_password" ]; then
        echo -e "${RED}[ERROR]${NC} Failed to get ECR login password"
        exit 1
    fi

    echo "$ecr_password" | docker login --username AWS --password-stdin "$ecr_registry"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[INFO]${NC} Successfully logged in"
        else
        echo -e "${RED}[ERROR]${NC} Failed to login to ECR registry"
        exit 1
    fi
}

ecr_login