#!/usr/bin/env bash
set -euo pipefail

### BEGIN DOCUMENTATION ###
# This script automates the process of:
# 1. Adding 'venv/' and '.venv/' to .gitignore
# 2. Initializing a local Git repository (if needed)
# 3. Creating a remote repository on GitHub with the same name as the current directory
# 4. Syncing (pushing) the local repository to GitHub
#
# Requirements:
# - You must be in the directory you want to set up as a repository.
# - Git, GitHub CLI must be installed and configured.
#
# Usage:
#   cd ~/Projects/MyCode
#   ./init_github_repo.sh
#
### END DOCUMENTATION ###

# Show each command as it runs
set -x

# Step 1: Identify repository name from current directory
REPO_NAME=$(basename "$PWD")

# Step 2: Create or update the .gitignore file to ignore environment directories
# Only add the entries if they do not already exist
if ! grep -qE '^venv/$' .gitignore 2>/dev/null; then
    echo "venv/" >> .gitignore
fi

if ! grep -qE '^\.venv/$' .gitignore 2>/dev/null; then
    echo ".venv/" >> .gitignore
fi

echo "Added environment directories to .gitignore."

# Step 3: Initialize Git repository if not already done
if [ ! -d .git ]; then
    git init
    echo "Initialized local Git repository."
else
    echo "Git repository already initialized."
fi

# Step 4: Add and commit all current files to Git
git add .
git commit -m "Initial commit"
echo "Committed all files locally."

# Step 5: Create the GitHub repository with the same name
# Note: This will use the current directory name as the repo name.
# Adjust flags as needed (e.g., --public or --private).
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
echo "Created repository on GitHub and pushed initial commit."

# Step 6: Set the default branch to 'main' and push if needed
# Usually 'gh repo create' with --push handles this, but let's ensure main is set.
git branch -M main
git push -u origin main
echo "Set main branch and pushed to remote repository."

# Script complete
echo "Repository '$REPO_NAME' is successfully synced with GitHub."
