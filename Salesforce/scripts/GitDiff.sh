#!/bin/bash
#set -e

# Target directory
TARGET=$1
#CIRCLE_BRANCH=$2               #for local testing only.
echo "Commit differences-"
git diff-tree --no-commit-id --name-status -r HEAD &

git checkout master
git reset --hard origin/master
git checkout $CIRCLE_BRANCH

echo "circle branch diff-" $CIRCLE_BRANCH
git diff --name-status master..$CIRCLE_BRANCH &

echo "target branch diff-" $target_branch
git diff --name-status master..$target_branch &

echo "Commit differences-"
git diff-tree --no-commit-id --name-status -r HEAD &

echo "finish" 

#if git diff-tree --no-commit-id --name-only -r HEAD | grep -c force-app; 
if git diff --name-only master..$CIRCLE_BRANCH | grep -c force-app; 
then 
    rm -rf $TARGET
    echo "SFDX go create project"
    sfdx force:project:create --projectname $TARGET
    echo "Finding and copying files and folders to $TARGET"

    for i in $(git diff --name-only master..$CIRCLE_BRANCH)
        do
            # First create the target directory, if it doesn't exist.
            mkdir -p "$TARGET/$(dirname $i)"
            echo "Check-Folder is "$(basename $(dirname $(dirname $i)))
            if [ "$(basename $(dirname $(dirname $i)))" = "aura" ];
            then
                echo "Folder"
                # copy the aura component bundle folder, will need to do the same with LWC
                cp -vr "$(dirname $i)" "$TARGET/$(dirname $i)"
            else
                # copy file and its meta.xml
                echo "File/Meta"
                cp -v "$i" "$TARGET/$i"
                [[ -e "$i-meta.xml" ]] && cp -v "$i-meta.xml" "$TARGET/$i-meta.xml" 
            fi
        done
    echo "Files copied to target directory";
    ls -R $TARGET > ~/.sfdx/sfdx.log

    echo "Convert and check deploy -"
    echo sfdx force:source:convert --rootdir $TARGET/force-app --outputdir $TARGET/metadataAPI
    sfdx force:source:convert --rootdir $TARGET/force-app --outputdir $TARGET/metadataAPI
    sfdx force:mdapi:deploy --checkonly --testlevel NoTestRun --targetusername $SFDX_USER --deploydir $TARGET/metadataAPI --wait 20
else
    echo "No changed files in force-app"
    git diff-tree --no-commit-id --name-only -r HEAD &
    echo "circle-" $CIRCLE_BRANCH
    git diff --name-status master..$CIRCLE_BRANCH &
    echo "target-" $target_branch
    git diff --name-status master..$target_branch &
fi
