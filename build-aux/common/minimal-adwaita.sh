#!/usr/bin/env bash

# Written in 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to
# the public domain worldwide.  This software is distributed without
# any warranty.

# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.


# Space separated sub directory names
TARGET="actions status"

ADWAITA_DIR="$1"
INSTALL_DIR="$2"

ADWAITA_INST_DIR="$INSTALL_DIR/share/icons/Adwaita"
ICON_DIRS="8x8 16x16 22x22 24x24 32x32 48x48 64x64"
ICON_DIRS="$ICON_DIRS 96x96 256x256 512x512 scalable"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$ADWAITA_DIR" = "" ] || [ "$INSTALL_DIR" = "" ]; then
  echo "usage: $0 ADWAITA_DIR INSTALL_DIR"
  exit 1
fi

make_icon_dirs ()
{
  for icon_dir in $ICON_DIRS
  do
    for target_dir in $TARGET
    do
      mkdir -p "$ADWAITA_INST_DIR/$icon_dir/$target_dir"
    done
  done
}

copy_svg_icons ()
{
  icon="$1"

  cp "$ADWAITA_DIR/scalable/$icon" "$ADWAITA_INST_DIR/scalable/$icon"
  for icon_dir in $ICON_DIRS
  do
    FILE="$ADWAITA_DIR/$icon_dir/${icon%.svg}.symbolic.png"

    if [ -e "$FILE" ]; then
      cp "$FILE" "$ADWAITA_INST_DIR/$icon_dir/${icon%.svg}.symbolic.png"
    fi
  done
}

copy_png_icons ()
{
  icon="$1"

  for icon_dir in $ICON_DIRS
  do
    FILE="$ADWAITA_DIR/$icon_dir/$icon"

    if [ -e "$FILE" ]; then
      cp "$FILE" "$ADWAITA_INST_DIR/$icon_dir/$icon"
    fi
  done
}


echo "Creating a minimal Adwaita icon theme..."
make_icon_dirs

while read -r icon
do
  echo "$icon"
  if [ "${icon##*.}" = "svg" ]; then
    copy_svg_icons $icon
  else
    copy_png_icons $icon
  fi
done < "$CURRENT_DIR/icons"

cp "$CURRENT_DIR/Adwaita.theme" "$ADWAITA_INST_DIR/index.theme"
echo "done"
