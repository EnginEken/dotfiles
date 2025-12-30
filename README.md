## Prerequisites

### Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Shell Setup

### About zsh
Zsh comes pre-installed on macOS since Catalina (10.15), so you don't need to install it separately.

### Add Homebrew to PATH
After installing Homebrew, you need to add it to your PATH. If the installation script doesn't do it automatically, you can add the following to your `.zshrc`:

```bash
# For Intel Macs
eval "$(/usr/local/bin/brew shellenv)"

# For Apple Silicon Macs
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Installing Packages

### Install packages from Brewfile

This will install almost all of the apps and cli tools needed including uv, ghostty, starship, atuin, etc.

```bash
brew bundle
```

## Shell Customization

For now, there is no plugin management tool in use with this dotfiles. Aliases are created manually and other bits are managed with scripts. Only plugins installed with homebrew are `zsh-syntax-highlighting` and `zsh-autosuggestions`. Maybe in the future, `zinit` or `antigen` could be implemented.

`omz` and `p10k` are also removed. Prompt is configured with `starship`.

## Apply Configuration Files

### Link dotfiles from your repository
```bash
# Assuming your dotfiles are in ~/dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/p10k.zsh ~/.p10k.zsh
```

## Additional installation

`uv` is installed with homebrew.

```bash
# Not so important to do

uv tool install harlequin
uv tool install 'harlequin[postgres,mysql,s3]'

# This must be done
atuin register -u <YOUR_USERNAME> -e <YOUR EMAIL>
atuin sync -f
```

## Final Steps

After completing the setup, restart your terminal or run:

```bash
source ~/.zshrc
```

### Suggestions for completeness:

1. **Git setup** - You might want to include configuring Git if you're setting up a new machine:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **SSH keys** - It can be found in Bitwarden

3. **Fonts** - Geist Mono is installed with homebrew 

4. **macOS preferences** - You might want to include some useful macOS settings:
   ```bash
   # Show hidden files
   defaults write com.apple.finder AppleShowAllFiles -bool true

   # Show path bar in Finder
   defaults write com.apple.finder ShowPathbar -bool true
   ```
