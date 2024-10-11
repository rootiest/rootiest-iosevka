#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set the font source locations (relative to the script location)
FONT_FOLDER="$SCRIPT_DIR/TTF"
NERD_FONT_FOLDER="$SCRIPT_DIR/NerdFont"

# Check if the font folders exist
if [ ! -d "$FONT_FOLDER" ]; then
	echo "Font folder not found!" >&2
	exit 1
fi

if [ ! -d "$NERD_FONT_FOLDER" ]; then
	echo "Nerd Font folder not found!" >&2
	exit 1
fi

# Function to install fonts
install_fonts() {
	local font_files=("$@")

	for font_file in "${font_files[@]}"; do
		if [ -f "$FONT_FOLDER/$font_file" ]; then
			echo "Installing font - $font_file"
			cp "$FONT_FOLDER/$font_file" ~/Library/Fonts/
		else
			echo "Font not found: $font_file" >&2
		fi
	done
}

# Check for minimal option
if [[ "$1" == "--minimal" ]]; then
	# Minimal installation
	MINIMAL_FONTS=(
		"IosevkaRootiestV2-Regular.ttf"
		"IosevkaRootiestV2-Italic.ttf"
		"IosevkaRootiestV2-Oblique.ttf"
		"IosevkaRootiestV2-ObliqueItalic.ttf"
	)

	# Install minimal fonts
	install_fonts "${MINIMAL_FONTS[@]}"

	# Install the Nerd Font
	NERD_FONT_FILE="IosevkaRootiestV2NerdFont-Regular.ttf"
	if [ -f "$NERD_FONT_FOLDER/$NERD_FONT_FILE" ]; then
		echo "Installing Nerd Font - $NERD_FONT_FILE"
		cp "$NERD_FONT_FOLDER/$NERD_FONT_FILE" ~/Library/Fonts/
	else
		echo "Nerd Font not found: $NERD_FONT_FILE" >&2
	fi

else
	# Full installation: List all .fon, .otf, .ttc, and .ttf files from TTF folder
	find "$FONT_FOLDER" -type f \( -name "*.fon" -o -name "*.otf" -o -name "*.ttc" -o -name "*.ttf" \) | while read -r font; do
		echo "Installing font - $(basename "$font")"
		cp "$font" ~/Library/Fonts/
	done

	# Install all fonts from the NerdFont folder
	find "$NERD_FONT_FOLDER" -type f \( -name "*.fon" -o -name "*.otf" -o -name "*.ttc" -o -name "*.ttf" \) | while read -r nerd_font; do
		echo "Installing Nerd Font - $(basename "$nerd_font")"
		cp "$nerd_font" ~/Library/Fonts/
	done
fi
