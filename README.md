## Dotfiles

My personal dotfiles. 

## On a New Machine

```bash
# Install XCode
xcode-select --install

# Clone this repo
mkdir -p ~/Documents/projects/personal
cd ~/Documents/projects/personal
git clone https://github.com/EnginEken/dotfiles.git
cd dotfiles

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install homebrew packages
/opt/homebrew/bin/brew bundle

# Copy dotfiles to the appropriate place
make

# Source .zshrc
source ~/.zshrc

# Disable font smoothing
defaults -currentHost write -g AppleFontSmoothing -int 0

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
```

## Additional installation

```bash
# This must be done
atuin register -u <YOUR_USERNAME> -e <YOUR EMAIL>
atuin sync -f

# Nice to have
# uv is installed with homebrew
uv tool install harlequin
uv tool install 'harlequin[postgres,mysql,s3]'
```
