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

## Zen Browser Restore

Firefox profile needs to be restored with following below steps

1. Go to `about:profiles` in Firefox.
2. Click on "Create a New Profile."
3. Copy the root folder path and close the Zen browser
4. Extract `zen_backup.tar.gz` to the copied root folder directory with `tar -xzf zen_backup.tar.gz -C ~/Library/Application\ Support/zen/Profile/<new_profile_folder_path>`
5. Start the Zen Browser
6. Login to Firefox and start syncing
7. Go back to `about:profile` and set the newly created profile as the default profile

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
