#!/bin/bash

# tfmod: Terraform module scaffolder
# ----------------------------------

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${GREEN}🌱 Terraform Module Scaffolder${NC}"
echo "------------------------------------"

if [ -z "$1" ]; then
  echo -e "${RED}❌ Module name not provided.${NC}"
  echo "👉 Usage: ./tfmod <module-name>"
  echo ""
  exit 1
fi

MODULE_NAME=$1

# Ask for the type of module
echo "📂 Choose the type of module:"
select MODULE_TYPE in aws gcp azure platform; do
  if [[ -n "$MODULE_TYPE" ]]; then
    break
  else
    echo -e "${RED}❌ Invalid selection. Please choose a number from the list.${NC}"
  fi
done

MODULE_DIR="modules/$MODULE_TYPE/$MODULE_NAME"

echo "📦 Creating module directory: $MODULE_DIR"
mkdir -p "$MODULE_DIR"

echo "📄 Creating main.tf..."
cat >"$MODULE_DIR/main.tf" <<EOF
# main.tf
# Terraform resources for $MODULE_NAME module

EOF

echo "📄 Creating variables.tf..."
cat >"$MODULE_DIR/variables.tf" <<EOF
# variables.tf
# Input variables for $MODULE_NAME module

EOF

echo "📄 Creating outputs.tf..."
cat >"$MODULE_DIR/outputs.tf" <<EOF
# outputs.tf
# Output values for $MODULE_NAME module

EOF

# Ask if user wants a README
read -p "📝 Do you want to create a README.md for this module? (y/n): " create_readme
if [[ "$create_readme" =~ ^[Yy]$ ]]; then
  echo "📝 Creating README.md..."
  cat >"$MODULE_DIR/README.md" <<EOF
# $MODULE_NAME

Terraform module for ...

## Usage

\`\`\`hcl
module "$MODULE_NAME" {
  source = "modules/$MODULE_TYPE/$MODULE_NAME"
}
\`\`\`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|      |             |      |         |          |

## Outputs

| Name | Description |
|------|-------------|
|      |             |
EOF
else
  echo "🚫 Skipping README.md creation."
fi

echo ""
echo -e "${GREEN}✅ Module '$MODULE_NAME' scaffolded successfully!${NC}"
echo -e "${CYAN}👉 Path: $MODULE_DIR${NC}"
echo ""
