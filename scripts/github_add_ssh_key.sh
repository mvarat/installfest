#-------------------------------------------------------------------------------
# Create and Upload SSH key. This script assumes jsawk is installed, and
# must come after scripts/mac/homebrew_install_cli_apps. (github_add_ssh_key.sh)
#-------------------------------------------------------------------------------

# SSH keys establish a secure connection between your computer and GitHub
# This script follows these instructions
# `https://help.github.com/articles/generating-ssh-keys`

# Steps:
# 0. check user credentials: if they fail announce and skip the rest.
# 1. check for SSH keys stored on GitHub
# 2. if there is an SSH key on GitHub, announce and skip the rest; else
# 3. check for local SSH keys: store in variable,
# 4. if there are keys:
#   a. if there is a key id_rsa.pub, send it.
#   b. if there is another key, notify, warn, and suggest it be sent after.
# 5. if there are no keys, then generate an id_rsa key and send.
#   a. If sending fails, announce.

# SSH Keygen
inform "Generating an SSH key to establish a secure connection " true
inform "  your computer and GitHub. "

pause_awhile "Note: when you see the prompts:
        'Enter a file in which to save the key (...)',
        'Enter passphrase (empty for no passphrase)', and
        'Enter passphrase again'
      ${BOLD}just press Enter! Do NOT input anything!
" true

ssh-keygen -t rsa -b 4096 -C $github_email
ssh-add ~/.ssh/id_rsa

public_key=$(cat ~/.ssh/id_rsa.pub)

# TODO (PJ) test if this fails or not!
show "SSH key created..."

# Upload to GitHub
inform "Uploading SSH key to GitHub..." true

# TODO (PJ) test if this fails or not!
curl https://api.github.com/user/keys \
  -H "User-Agent: WDIInstallFest" \
  -H "Accept: application/vnd.github.v3+json" \
  -u "$github_name:$github_password" \
  -d '{"title":"WDI Installfest", "key":"'"$public_key"'"}'

echo ""
show "Key uploaded!" true
