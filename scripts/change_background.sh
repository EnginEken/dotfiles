#!/bin/zsh

# change_background.sh
# Usage: ./change_background.sh [mode_setting]
# If mode_setting is not provided, it will be deduced from the system settings.

TMUX_BIN="/opt/homebrew/bin/tmux"
TMUX_SOCKET="/tmp/tmux-$(id -u)/default"

if [ ! -S "$TMUX_SOCKET" ]; then
  echo "tmux socket not found at $TMUX_SOCKET" >&2
  exit 1
fi

TMUX_SESSION="main"

change_background() {
  local mode_setting="$1"
  local mode="light"  # default value

  if [ -z "$mode_setting" ]; then
    # Try to deduce the mode from system settings
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      mode="dark"
    fi
  else
    case "$mode_setting" in
      light)
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
        mode="light"
        ;;
      dark)
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
        mode="dark"
        ;;
      *)
        echo "Invalid mode_setting: $mode_setting. Use 'light' or 'dark'."
        exit 1
        ;;
    esac
  fi

  # Change tmux configuration for all sessions
  case "$mode" in
    dark)
      $TMUX_BIN -S $TMUX_SOCKET source-file /Users/eeken/.config/tmux/tmux-dark.conf
      ;;
    light)
      $TMUX_BIN -S $TMUX_SOCKET source-file /Users/eeken/.config/tmux/tmux-light.conf
      ;;
  esac

  # Change Alacritty theme
  alacritty_theme "$mode"

  # Change Zed theme
  zed_theme "$mode"

  # Change Ghostty theme
  # ghostty_theme "$mode"
}

alacritty_theme() {
  local mode_setting="$1"

  # Paths to your Alacritty configuration
  local alacritty_config="$HOME/.config/alacritty/alacritty.toml"
  local theme_dark="$HOME/.config/alacritty/gruvbox-dark.toml"
  local theme_light="$HOME/.config/alacritty/gruvbox-light.toml"

  # Determine the theme file based on the mode
  local theme_file=""
  case "$mode_setting" in
    dark)
      theme_file="$theme_dark"
      ;;
    light)
      theme_file="$theme_light"
      ;;
  esac

  if [ ! -f "$theme_file" ]; then
    echo "Theme file not found: $theme_file"
    exit 1
  fi

  # Modify the import line in alacritty.toml
  # Use sed to replace the import line
  sed -i.bak "s|^import = \[.*\]|import = [\"$theme_file\"]|" "$alacritty_config"

  # Remove the backup file created by sed (optional)
  rm -f "$alacritty_config.bak"
}

zed_theme() {
  local mode_setting="$1"

  # Path to your Zed configuration
  local zed_config="$HOME/.config/zed/settings.json"

  # Determine the theme based on the mode
  local theme=""
  case "$mode_setting" in
    dark)
      theme="Gruvbox Dark Hard"
      ;;
    light)
      theme="Gruvbox Light Hard"
      ;;
  esac

  if [ ! -f "$zed_config" ]; then
    echo "Zed settings file not found: $zed_config"
    exit 1
  fi

  # Use jq to update the theme in settings.json
  # Create a backup of the original settings.json
  cp "$zed_config" "$zed_config.bak"

  # Update the theme
  jq --arg theme "$theme" '.theme = $theme' "$zed_config.bak" > "$zed_config"

  # Remove the backup file if desired
  rm -f "$zed_config.bak"
}

ghostty_theme() {
  local mode_setting="$1"

  # Path to your Ghostty config
  local ghostty_config="$HOME/.config/ghostty/config"

  # Determine the theme value based on light/dark
  local theme=""
  case "$mode_setting" in
    dark)
      theme="GruvboxDark"
      ;;
    light)
      theme="GruvboxLight"
      ;;
    *)
      echo "Unknown mode setting for Ghostty: $mode_setting"
      return
      ;;
  esac

  # Safety check: does the file exist?
  if [ ! -f "$ghostty_config" ]; then
    echo "Ghostty config not found: $ghostty_config"
    return
  fi

  # Update the theme line using sed
  # The line in your config presumably looks like: theme = "GruvboxDark" or theme = "GruvboxLight"
  # So we match on "theme = " and replace with the new string.
  sed -i.bak "s|^theme = .*|theme = $theme|" "$ghostty_config"

  # Remove the sed backup if desired
  rm -f "$ghostty_config.bak"
  /usr/bin/osascript <<EOT
    tell application "Ghostty" to activate
    tell application "System Events" to keystroke "," using {command down, shift down}
EOT
}
# Execute the function with the provided argument
change_background "$1"
