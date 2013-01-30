#!/bin/bash

# name of GitHub commiter
GIT_USER=jbutkus
# remote name, of commiter forked repo
GIT_ORIGIN=origin
# remote name, of master repository
GIT_MASTER=thenly
# name of target repo, on master repo
GIT_PRONAME=all-in-one-event-calendar-pro
# path to repo, to create patch from
PRM_PATH=/var/www/wordpress/wp-content/plugins/all-in-one-event-calendar-premium
# path to repo, to apply patch to
PRO_PATH=/var/www/wordpress_clean/wp-content/plugins/all-in-one-event-calendar-pro

if [[ o"$1" == "o" ]]
then
    echo -e "Usage:\n  $_ AIOEC-101"
    exit 1
fi

feature=$1

cd $PRO_PATH

git checkout develop >/dev/null

git branch | grep "feature/$feature" >/dev/null
if [[ $? -eq 0 ]]
then
    git checkout "feature/$feature"
else
    git flow feature start "$feature"
    if [[ $? -ne 0 ]]
    then
	echo "Failed to initiate feature branch $feature. Aborting."
	exit 2
    fi
fi

( cd $PRM_PATH; git diff develop...feature/$feature | perl -pe 's|[ \t]*$||g' ) \
    | git apply --exclude .gitignore -

if [[ $? -ne 0 ]]
then
    echo "Merge failed. Aborting."
    exit 3
fi

files_changed=$( cd $PRM_PATH; git diff --name-only develop...feature/$feature )

for file in $files_changed
do
    git add "$file"
done

echo -n "Enter commit/pull message: "

read pullmsg

pullmsg="${pullmsg//\"/\\\"}"
pullmsg="${pullmsg//\'/\\\'}"

pullmsg="feature/$feature\n$pullmsg"

git commit --message="$pullmsg"

if [[ $? -ne 0 ]]
then
    echo "Failed to commit result. Aborting."
    exit 4
fi

git push -u "$GIT_ORIGIN" "feature/$feature"

if [[ $? -ne 0 ]]
then
    echo "Failed to push changeset to origin ($GIT_ORIGIN). Aborting."
    exit 4
fi

curl "https://api.github.com/repos/$GIT_MASTER/$GIT_PRONAME/pulls" \
    -u $GIT_USER \
    -d "{\"title\": \"feature/$feature\", \"body\": \"$pullmsg\", \"head\": \"$GIT_USER:feature/$feature\", \"base\": \"develop\" }"

exit 0
