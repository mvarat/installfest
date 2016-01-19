#-------------------------------------------------------------------------------
# Capture GitHub credentials (github_capture_credentials.sh)
#-------------------------------------------------------------------------------

inform "Enter information to set up your GitHub configuration." true

function get_credentials() {
  read -p  "Enter your Github Username: " GITHUB_NAME
  read -sp "Enter your Github Password: " GITHUB_PASSWORD
}

# https://developer.github.com/v3/users/#get-the-authenticated-user
function check_credentials() {
  local UNAME="$1"
  local PASS="$2"
  curl https://api.github.com/user \
    -H "User-Agent: WDIInstallFest" \
    -H "Accept: application/vnd.github.v3+json" \
    -u "$UNAME:$PASS" \
    2>/dev/null \
    | ruby -e " \
      json = JSON.parse(STDIN.gets)
      if json.key?('id')
        puts
        puts('Authenticated!')
        exit 0
      else
        puts
        puts('Failed: ' + json.to_s)
        exit 1
      end
    " -r JSON
}

CHECK_NOT_PASSED="true"
COUNTER=1
while [ $COUNTER -lt 4 ] && [ $CHECK_NOT_PASSED ]; do
  get_credentials
  check_credentials $GITHUB_NAME $GITHUB_PASSWORD
  if [ $? -eq 0 ]; then
    echo ""
    CHECK_NOT_PASSED=""
  else
    echo ""
    [ $COUNTER -lt 3 ] && echo "Please try again! $((3-$COUNTER)) chance(s) left... "
    let COUNTER=COUNTER+1
  fi
done

if [ $CHECK_NOT_PASSED ]; then
  GITHUB_AUTHENTICATED=""
  echo "Skipping GitHub authentication and SSH Key generation."
else
  GITHUB_AUTHENTICATED="true"
fi

show "Thank you!"
