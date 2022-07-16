#!/bin/bash

# Thank you Dries - https://driesvints.com/blog/getting-started-with-dotfiles
# Thank you Freek - https://freek.dev
# Thank you Steve - https://juststeveking.uk

sudo -v

echo "Starting Mac fresh install..."

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

# Create code home
mkdir $HOME/Code

# Install OMZ
echo -e "Installing oh-my-zsh"
rm -rf $HOME/.oh-my-zsh
/bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Symlink Zsh
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Install Starship
/bin/bash -c "$(curl -fsSL https://starship.rs/install.sh)"
# Symlink Starship
rm -rf $HOME/.config/startship.toml
ln -s $HOME/.dotfiles/.starship.toml $HOME/.config/startship.toml

# Install Homebrew
echo -e "Installing Homebrew"
rm -rf /usr/local/Cellar /usr/local/.git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Update Homebrew
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install PHP extensions
pecl install imagick
arch -arm64 pecl install xdebug

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Symlink .mackup
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Add global gitignore
ln -s $HOME/.dotfiles/.global-gitignore $HOME/.global-gitignore
git config --global core.excludesfile $HOME/.global-gitignore

echo -e "Create new SSH Key? (y/n)"
read -p "Answer: " reply
if [[ $reply =~ ^[Yy]$ ]]
then
    echo -e "Enter email address"
    read -p "Answer: " email

    if [[ $email != "" ]]
    then 
      source gens.sh $email
    fi
fi

# Set some mac os defaults and reload terminal
source .macos