#!/bin/sh

echo "Generating a new SSH key for GitHub..."
EMAIL=$1
if [[ ! $EMAIL ]]
then
    read -p "Enter email address: " EMAIL
fi

# Generating a new SSH key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
ssh-keygen -t ed25519 -C $EMAIL -f ~/.ssh/id_ed25519

# Adding your SSH key to the ssh-agent
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
eval "$(ssh-agent -s)"

touch ~/.ssh/config
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config

# Add -K flag to store passphrase in Apple's keychain pre-Monterey
# Add --apple-use-keychain to store passphrase in Apple's keychain in Monterey (and beyond)
ssh-add ~/.ssh/id_ed25519

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
echo "type 'copyssh' to copy key into the clipboard; paste that into GitHub"