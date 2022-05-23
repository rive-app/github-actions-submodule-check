set -e

# For testing.
# SUBMODULE_GIT_URL=https://github.com/rive-app/rive-cpp.git
# SUBMODULE_MAIN_BRANCH=master
# NAME=rive-app/rive-ios
# WORKSPACE=../rive-ios

# Get the hash of the repo.

cd $WORKSPACE

REPO_HASH=$(git ls-remote $SUBMODULE_GIT_URL refs/heads/$SUBMODULE_MAIN_BRANCH | awk '{print $1}')
echo $SUBMODULE_GIT_URL:$SUBMODULE_MAIN_BRANCH is at $REPO_HASH

REPO_NAME=$(echo $SUBMODULE_GIT_URL | sed -En 's/.*\/(.*).git/\1/p')


# GET hash of Submodule.
SUBMODULE_HASH=$(git submodule | grep $REPO_NAME |awk '{print $1}' | sed -En 's/-*(.*)/\1/p')


echo Submodule is at $SUBMODULE_HASH

if [ "$REPO_HASH" == "$SUBMODULE_HASH" ]
then 
    echo "They match. all is good"
else 
    SUBMODULE_LOCATION=$(git submodule | grep $REPO_NAME |awk '{print $2}' | sed -En 's/-*(.*)/\1/p')
    

    git submodule set-url $SUBMODULE_LOCATION $SUBMODULE_GIT_URL
    git submodule update --init $SUBMODULE_LOCATION

    cd $SUBMODULE_LOCATION
    echo $(git log)

    # assuming rive-app
    DIFF_URL=https://github.com/rive-app/$REPO_NAME/compare/$SUBMODULE_HASH...$REPO_HASH
    echo "git rev-list --left-right --count $SUBMODULE_HASH...$REPO_HASH"
    DIFF_COUNT=$(git fetch && git rev-list --left-right --count $SUBMODULE_HASH...$REPO_HASH | awk '{print $2}')
    echo $DIFF_COUNT
    echo $DIFF_URL

    # Just full on assuming this is behind for the time being. 
    # Could put in some 'useful' links into this message. Once we have something useful to do (other than update & rebuild)
    # curl -X POST -H 'Content-type: application/json' --data '{"text":"`'"$NAME"'` is behind '"$REPO_NAME"'!"}' $SLACK_WEBHOOK
    # curl -X POST -H 'Content-type: application/json' --data '{"text":" `'$NAME'` is behind `'$REPO_NAME'` by <'$DIFF_URL'|'$DIFF_COUNT' commit(s)>."}' $SLACK_WEBHOOK
    # echo '{"text":" `'$NAME'` is behind `'$REPO_NAME'` by <'$DIFF_URL'|'$DIFF_COUNT' commit(s)>."}'

fi 