#!/bin/sh

BOLD='\033[1m'
CYAN='\033[0;34m'
NC='\033[0m'
message() {
    printf "\n${BOLD}${CYAN}>> ${1}${NC}\n"
}

message "Enabling Node..."
export PATH="/usr/lib/sdk/node20/bin:$PATH"

message "Installing ts-for-gir..."
export PATH="$(yarn global bin):$PATH"
yarn global add @ts-for-gir/cli@4.0.0-beta.12

message "Finding all modules..."
LIST_OUTPUT=$(ts-for-gir list)
# This pretty prints the output of `ts-for-gir list` into a list of modules
MODULES=$(echo "$LIST_OUTPUT" |
sed -n '/Selected Modules:/,/Conflicts:/p' | 
awk '/^- / {
    module = $2
    getline
    print module
}'
)
echo "$(echo $MODULES | wc -w) Modules found:"
echo $MODULES

message "Generating modules..."
ts-for-gir generate -o gi-types $MODULES

message "Generated modules!"