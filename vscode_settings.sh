#!/bin/bash

# This script is for fetching VS Code setting.json file from git and applying to currentsystem..

# Gitlab repo of "settings.json"
VSCODE_SETTINGS_REPO_URL=https://github.com/GkhOzdmr/vscode_settings.git
# Base dir
GO_DEV_MAIN_DIR=$HOME/gokhanozdemir_dev
# Directory to put "settings.json" file
VSCODE_DIRECTORY=$GO_DEV_MAIN_DIR/vscode_settings
# Place of original "settings.json" file
if [[ "$OSTYPE" == "linux-gnu" ]]; then
# For Linux
    DEF_SETTINGS_JSON_BASE_DIR=$HOME/.config/Code/User
elif [[ "$OSTYPE" == "darwin"* ]]; then
# For macOS
    DEF_SETTINGS_JSON_BASE_DIR=$HOME/Library/Application\ Support/Code/User
else
    echo "This script is designed to work on Linux or macOS systems."
    exit 1 
fi

# Creates directory if not exists.
mkdir -p "${GO_DEV_MAIN_DIR}" 
# cd's into directory
cd "${GO_DEV_MAIN_DIR}"


function clone_repo { 
    # Cloning repo
    git clone "${VSCODE_SETTINGS_REPO_URL}" "${VSCODE_DIRECTORY}" || CLONE_EXIT_ST=$?
}

clone_repo

if [[ $CLONE_EXIT_ST -ne 0 ]]; then
    if [[ $CLONE_EXIT_ST -eq 128 ]]; then
    rm -rf "${VSCODE_DIRECTORY}/*"
    clone_repo
    else
    echo "Clone failed, exiting script. Exit code: ${CLONE_EXIT_ST}"
    exit 1
    fi 
fi

# Ask if the replaced "settings.json" file should be stored as well. 
echo "Would you like to store old \"settings.json\" file. (Y/n)"
read MUST_STORE_OLD
if [[ $MUST_STORE_OLD -eq "y" ]] || [[ $MUST_STORE_OLD -eq "Y" ]]; then 
    mkdir -p "${VSCODE_DIRECTORY}/recovered"
    cp "$DEF_SETTINGS_JSON_BASE_DIR/settings.json" "${VSCODE_DIRECTORY}/recovered" 
    echo "Use \"recover_old_settings.sh\" to recover and replace old \"settings.json\" file"
else 
    echo "Skipping restore old settings.json file"
fi

# Replacing old "settings.json " with fetched
mv "$VSCODE_DIRECTORY/settings.json" "$DEF_SETTINGS_JSON_BASE_DIR/settings.json"
if [[ $? -eq 0 ]]; then
    echo "\"settings.json\" file succesfully replaced."
fi