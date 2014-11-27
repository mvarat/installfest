pause_awhile "downloading the installfest repo"
# download the repo for the absolute paths
if [[ ! -d $SRC_DIR ]]; then
  echo 'Downloading Installfest repo...'
  # autoupdate bootstrap file
  git clone -b $BRANCH $INSTALL_REPO $SRC_DIR
else
  # update repo
  echo 'Updating repo...'
  cd $SRC_DIR
  git pull origin $BRANCH
fi
