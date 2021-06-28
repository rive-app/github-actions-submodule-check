set -e

# For testing.
# REPO_URL=https://github.com/rive-app/rive-cpp.git
# REPO_MAIN_BRANCH=master
# NAME=rive-app/rive-ios
# WORKSPACE=.

# Get the hash of the repo.

pushd $WORKSPACE

REPO_HASH=$(git ls-remote $REPO_URL refs/heads/$REPO_MAIN_BRANCH | awk '{print $1}')
echo $REPO_URL:$REPO_MAIN_BRANCH is at $REPO_HASH

REPO_NAME=$(echo $REPO_URL | sed -En 's/.*\/(.*).git/\1/p')


# GET hash of Submodule.
SUBMODULE_HASH=$(git submodule | grep $REPO_NAME |awk '{print $1}' | sed -En 's/-*(.*)/\1/p')

echo Submodule is at $SUBMODULE_HASH

if [ "$REPO_HASH" == "$SUBMODULE_HASH" ]
then 
    echo "They match. all is good"
else 
    # Just full on assuming this is behind for the time being. 
    # Could put in some 'useful' links into this message. Once we have something useful to do (other than update & rebuild)
    curl -X POST -H 'Content-type: application/json' --data '{"text":"`'"$NAME"'` is behind '"$REPO_NAME"'!"}' $SLACK_WEBHOOK
fi 