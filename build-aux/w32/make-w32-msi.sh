#!/usr/bin/env bash

# Written in 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to
# the public domain worldwide.  This software is distributed without
# any warranty.

# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.


trap "exit" INT

. "$MESON_BUILD_ROOT/build-aux/w32/defaults.sh"

SRC_DIR="$MESON_SOURCE_ROOT"
BUILD_DIR="$MESON_BUILD_ROOT"

WIXL_VERSION=$(wixl --version 2>/dev/null)

if [ "$ARCH" = "x86_64" ]; then
  ARCH_SHORT="x64"
  MINGW_DIR="/usr/x86_64-w64-mingw32/sys-root/mingw"
elif [ "$ARCH" = "i686" ]; then
  ARCH_SHORT="x86"
  MINGW_DIR="/usr/i686-w64-mingw32/sys-root/mingw"
else
  echo "Arch '$ARCH' Not supported. Only i686 and x86_64 supported"
  exit 1
fi

if [ -z "$WIXL_VERSION" ]; then
  echo "wixl binary not found. Please install msitools"
  exit 1
fi

WIXL_DIR="/usr/share/wixl-$WIXL_VERSION/include"
cp "$WIXL_DIR/adwaita-icon-theme.wxi" "$SRC_DIR/build-aux/w32/include"


FILE_NAME=my-gtemplate-${VERSION}-${ARCH}.msi
mkdir -p "$BUILD_DIR"
mkdir -p "$INSTALL_DIR"


TEMP_DIR=$(mktemp my-gtemplate.XXXXX -d -p /tmp)
mkdir $TEMP_DIR/bin $TEMP_DIR/schemas

# Copy all GSettings schema xml in MinGW glib directory to
# a temporary path.   Also copy our application specific
# schemas. Compile it there, and copy the compiled schema
# back.
# This is a work around since CustomAction is not working
# in msitools, which makes it pretty hard to run executables
# post installation.
cp $MINGW_DIR/share/glib-2.0/schemas/*.xml "$TEMP_DIR/schemas"
cp $INSTALL_DIR/share/glib-2.0/schemas/*.xml "$TEMP_DIR/schemas"
glib-compile-schemas "$TEMP_DIR/schemas"
mv "$TEMP_DIR/schemas/gschemas.compiled" "$INSTALL_DIR/share/glib-2.0/schemas/"

# Work around to find application icons
# TODO: Fix this please
cp "$SRC_DIR/build-aux/w32/index.theme" "$INSTALL_DIR/share/icons/hicolor"
gtk-update-icon-cache -f "$INSTALL_DIR/share/icons/hicolor"


rm -rf "$TEMP_DIR"
# Generate wxs file from the binaries built
find "$INSTALL_DIR" | wixl-heat -p "$INSTALL_DIR/" --var var.InstallDir \
                                --component-group binaries > binaries.wxs

sed -i 's|TARGETDIR|INSTALLDIR|' binaries.wxs

# Create Start menu items
for item in $SHORT_FILES
do
  file="${item%|*}"
  icon="${item#*|}"

  if [ "$icon" != "" ]; then
    icon="Icon=\"$icon\""
  fi

  # This requires GNU sed
  sed -i "/)$file/a <Shortcut Id=\"startmenu$file\" Directory=\"ProgramMenuDir\"\
 Name=\"My GTemplate\" WorkingDirectory=\"INSTALLDIR\" $icon\
 IconIndex=\"0\" Advertise=\"yes\" \/>" binaries.wxs
done

# Create desktop items
for item in $DESKTOP_FILES
do
  file="${item%|*}"
  icon="${item#*|}"

  if [ "$icon" != "" ]; then
    icon="Icon=\"$icon\""
  fi

  # This requires GNU sed
  sed -i "/)$file/a <Shortcut Id=\"desktop$file\" Directory=\"\DesktopFolder\"\
 Name=\"My GTemplate\" WorkingDirectory=\"INSTALLDIR\" $icon\
 IconIndex=\"0\" Advertise=\"yes\" \/>" binaries.wxs
done

# Now generate msi
wixl -v -D ARCH="$ARCH_SHORT" -D InstallDir="$INSTALL_DIR" \
     -I "$BUILD_DIR/build-aux/w32" -a "$ARCH_SHORT" \
     --wxidir "$SRC_DIR/build-aux/w32/include" \
     -o "$FILE_NAME" my-gtemplate.wxs binaries.wxs || exit 1

echo -n "msi installer for MS Windows created at "
echo "$SRC_DIR/build-aux/w32/$FILE_NAME"
