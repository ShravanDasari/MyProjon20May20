#!/bin/bash
# Reference: https://javorszky.co.uk/2019/03/11/set-up-circle-ci-to-run-phpcs-on-only-changed-files-in-a-pr/

TARGET=$1

if [[ -z "${CIRCLE_PULL_REQUEST}" ]];
then
	echo "This is not a pull request, no deployment required."
	exit 0
else
	echo "This is a pull request, continuing"
fi

if [[ -z $GITHUB_TOKEN ]];
then
	echo "GITHUB_TOKEN not set"
	exit 1
fi

regexp="[[:digit:]]\+$"
PR_NUMBER=`echo $CIRCLE_PULL_REQUEST | grep -o $regexp`

url="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER"

target_branch=$(curl -H 'Authorization: token '$GITHUB_TOKEN $url | jq '.base.ref' | tr -d '"')

#target_branch=$(curl -s -X GET -G \
#$url \
#-d access_token=$GITHUB_TOKEN | jq '.base.ref' | tr -d '"')

echo "Resetting $target_branch to where the remote version is..."
git checkout -q $target_branch

git reset --hard -q origin/$target_branch

git checkout -q $CIRCLE_BRANCH

echo "Getting list of changed files..."
changed_files=$(git diff --name-only $target_branch..$CIRCLE_BRANCH)

git diff --name-only $target_branch..$CIRCLE_BRANCH

if git diff --name-only $target_branch..$CIRCLE_BRANCH | grep -c force-app; 
then 
    rm -rf $TARGET
    echo "SFDX go create project"
    #sfdx force:project:create --projectname $TARGET
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
    sfdx force:mdapi:deploy --testlevel NoTestRun --targetusername $SFDX_USER --deploydir $TARGET/metadataAPI --wait 20
else
    echo "No changed files in force-app"
    git diff-tree --no-commit-id --name-only -r HEAD &
    echo "circle-" $CIRCLE_BRANCH
    git diff --name-status $target_branch..$CIRCLE_BRANCH &
    echo "target-" $target_branch
    git diff --name-status master..$target_branch &
	echo "finish"
fi