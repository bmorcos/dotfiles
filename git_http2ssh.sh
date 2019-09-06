#/bin/bash
# Modified from https://gist.github.com/m14t/3056747

# This will loop through all sub directories in the pwd and update the remote
# URL of any github repos found.
# NOTE, currently does not support gitlab

http2ssh(){
    REPO_URL=`git remote -v | grep -m1 '^origin' | sed -Ene's#.*(https://[^[:space:]]*).*#\1#p'`
    if [ -z "$REPO_URL" ]; then
      echo "-- ERROR:  Could not identify Repo url."
      echo "   It is possible this repo is already using SSH instead of HTTPS."
      return
    fi

    USER=`echo $REPO_URL | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
    if [ -z "$USER" ]; then
      echo "-- ERROR:  Could not identify User. ($REPO_URL)"
      return
    fi

    REPO=`echo $REPO_URL | sed -Ene's#https://github.com/([^/]*)/(.*).git#\2#p'`
    if [ -z "$REPO" ]; then
      echo "-- ERROR:  Could not identify Repo. ($REPO_URL)"
      return
    fi

    NEW_URL="git@github.com:$USER/$REPO.git"
    echo ">> Changing repo url from "
    echo "     '$REPO_URL'"
    echo "       to "
    echo "     '$NEW_URL'"

    CHANGE_CMD="git remote set-url origin $NEW_URL"
    `$CHANGE_CMD`

    echo "  Success"
}

# Loop through sub directories
for dir in */ ; do
    cd $dir
    # Check if this is a repo
    if [ -d ".git" ]; then
        echo "Processing $dir"
        http2ssh
        echo ""
    fi
    cd ..
done
