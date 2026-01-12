DOTFILES_DIR := $(abspath $(CURDIR))

all: link

link:
	@mkdir -p "${HOME}/.config/atuin"
	@mkdir -p "${HOME}/.config/ghostty"
	@mkdir -p "${HOME}/.config/zed"
	@mkdir -p "${HOME}/.config/starship"
	@mkdir -p "$(HOME)/.ssh"

	@ln -sfn "$(DOTFILES_DIR)/zsh/zshrc" "$(HOME)/.zshrc"
	@ln -sfn "$(DOTFILES_DIR)/zsh/zsh_functions" "$(HOME)/.zsh_functions"
	@ln -sfn "$(DOTFILES_DIR)/gitconfig" "$(HOME)/.gitconfig"
	@ln -sfn "$(DOTFILES_DIR)/vim/vimrc" "$(HOME)/.vimrc"
	@ln -sfn "$(DOTFILES_DIR)/scripts" "$(HOME)/.scripts"
	@ln -sfn "$(DOTFILES_DIR)/atuin/config.toml" "$(HOME)/.config/atuin/config.toml"
	@ln -sfn "$(DOTFILES_DIR)/ghostty/config" "$(HOME)/.config/ghostty/config"
	@ln -sfn "$(DOTFILES_DIR)/starship/starship.toml" "$(HOME)/.config/starship/starship.toml"
	@ln -sfn "$(DOTFILES_DIR)/zed/keymap.json" "$(HOME)/.config/zed/keymap.json"
	@ln -sfn "$(DOTFILES_DIR)/zed/settings.json" "$(HOME)/.config/zed/settings.json"
	@ln -sfn "$(DOTFILES_DIR)/ssh/config" "$(HOME)/.ssh/config"
	@chmod 700 "$(HOME)/.ssh"
	@chmod 600 "$(HOME)/.ssh/config"

clean:
	@rm -f "${HOME}/.zshrc"
	@rm -f "${HOME}/.zsh_functions"
	@rm -f "${HOME}/.gitconfig"
	@rm -f "${HOME}/.vimrc"
	@rm -rf "${HOME}/.scripts"
	@rm -f "${HOME}/.config/atuin/config.toml"
	@rm -f "${HOME}/.config/ghostty/config"
	@rm -f "${HOME}/.config/starship/starship.toml"
	@rm -f "${HOME}/.config/zed/keymap.json"
	@rm -f "${HOME}/.config/zed/settings.json"
	@rm -f "${HOME}/.ssh/config"

.PHONY: all clean link
