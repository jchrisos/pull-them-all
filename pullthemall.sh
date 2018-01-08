#!/bin/bash
################################################################
# Author: Julio Chrisostomo
# Created at: 10/22/2017
# Github: http//github/jchrisos/pull-them-all
#
# Description: This script pull all changes from git.
################################################################

git_checkout_and_pull()
{
    RESULT="$(git checkout $1)"
        
    # Pull branch
    if [[ "$RESULT" == "Your branch is behind"* ]]
    then
        echo "PULLING $1"
        git pull
    else
        echo "branch '$1' is up-to-date"
    fi
}

clear

PROJECTS_DIR=~/Projects

# Access folder where all projects are saved
cd $PROJECTS_DIR

# List all folders that contain .git
DIRS="$(find . -name ".git" | sed 's/\.//g' | sed 's/git//g')"

# Iterate over folders array
for DIR in $DIRS
do  
    cd $PROJECTS_DIR$DIR

    echo "====================================================================="
    echo "Project: $PROJECTS_DIR$DIR"

    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    BRANCHES="$(git branch | sed 's/\*//g')"

    # Iterate over all branches
    for BRANCH in $BRANCHES
    do
        if [[ "$BRANCH" != "$CURRENT_BRANCH" ]]
        then
            git_checkout_and_pull $BRANCH
        fi     
    done

    git_checkout_and_pull $CURRENT_BRANCH
done

exit 0