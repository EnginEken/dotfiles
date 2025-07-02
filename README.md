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
```bash
brew bundle
```

## Shell Customization

### Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Powerlevel10k Theme
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Install zsh Plugins
```bash
# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

## Apply Configuration Files

### Link dotfiles from your repository
```bash
# Assuming your dotfiles are in ~/dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/p10k.zsh ~/.p10k.zsh
```

## Additional installation

```bash
uv tool install harlequin
uv tool install 'harlequin[postgres,mysql,s3]'

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

2. **SSH keys** - Consider adding a reminder to set up SSH keys for GitHub/GitLab if needed

3. **Fonts** - If Powerlevel10k requires specific fonts, you might want to add:
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-meslo-lg-nerd-font
   ```

4. **iTerm2** - If you use iTerm2 instead of Terminal.app, you might want to add its installation

5. **Node/Python version management** - If you work with these languages, tools like nvm, pyenv might be worth adding

6. **Visual Studio Code or other editor** - Consider adding setup for your code editor

7. **macOS preferences** - You might want to include some useful macOS settings:
   ```bash
   # Show hidden files
   defaults write com.apple.finder AppleShowAllFiles -bool true

   # Show path bar in Finder
   defaults write com.apple.finder ShowPathbar -bool true
   ```
