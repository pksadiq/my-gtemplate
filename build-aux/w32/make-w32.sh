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

W32_DIR="$1"
. "$W32_DIR/build-aux/w32/defaults.sh"

WIXL_VERSION=$(wixl --version 2>/dev/null)

if [ -z "$WIXL_VERSION" ]; then
  echo "wixl binary not found. Please install msitools"
  exit 1
fi

WIXL_DIR="/usr/share/wixl-$WIXL_VERSION/include"
cp "$WIXL_DIR/adwaita-icon-theme.wxi" "$SRC_DIR/build-aux/w32/include"

find_bin ()
{
  ARCH="$1"

  if [ "$ARCH" = "x86_64" ]; then
    ARCH_SHORT="x64"
    MINGW_DIR="/usr/x86_64-w64-mingw32/sys-root/mingw"
  else
    ARCH_SHORT="x86"
    MINGW_DIR="/usr/i686-w64-mingw32/sys-root/mingw"
  fi

  CC=$(which "${ARCH}-w64-mingw32-gcc")
  AR=$(which "${ARCH}-w64-mingw32-ar")
  STRIP=$(which "${ARCH}-w64-mingw32-strip")
  PKGCONFIG=$(which "${ARCH}-w64-mingw32-pkg-config")

  if [ "$CC" = "" ] || [ "$PKGCONFIG" = "" ]; then
    return $(false)
  else
    return $(true)
  fi
}

exit_with_arch_fail ()
{
  ARCH=$1

  if [ "$CC" = "" ]; then
    echo "Failed to find MinGW GCC compiler"
  fi

  if [ "$PKGCONFIG" = "" ]; then
    echo "Failed to find pkg-config"
  fi

  echo "Failed to find binaries for Arch $ARCH"
  echo "Please install the necessary MinGW packages"
  echo "Exiting..."
  exit 1
}

install_packages ()
{
  if [ "$ARCH" = "" ] || [ "$ARCH" = "i686" ]; then
    BIT="32"
  elif [ "$ARCH" =  "x86_64" ]; then
    BIT="64"
  else
    echo "Arch $ARCH not understood."
    echo "Exiting..."
    exit 1
  fi

  DEFAULT_PACKAGES="mingw${BIT}-gtk3 meson gcc gtk3-devel msitools"

  dnf install -y $DEFAULT_PACKAGES $USER_PACKAGES
}

# Check if the system is Fedora or derivatives
DNF=$(which dnf)

# Fedora seems to be the only OS that officially supports
# Mingw GTK+.
if [ "$DNF" = "" ]; then
  echo "WARNING: OS is not Fedora."
  echo "Packages shall be automatically installed only on Fedora."
  echo "Please make sure necessary packages are installed before build"
else
  install_packages "$DEFAULT_PACKAGES" "$USER_PACKAGES"
fi

if [ "$ARCH" = "" ]; then
  # As it's possible to run 32 bit binaries on both arch, prefer 32 bit.
  find_bin "i686" || find_bin "x86_64" || exit_with_arch_fail "i686, x86_64"
else
  find_bin "$ARCH" || exit_with_arch_fail "$ARCH"
fi


cat > w32-config.txt << EOF
[binaries]
c = '$CC'
ar = '$AR'
strip = '$STRIP'
pkgconfig = '$PKGCONFIG'

[host_machine]
system = 'windows'
cpu_family = 'x86'
cpu = '$ARCH'
endian = 'little'
EOF

FILE_NAME=my-gtemplate-${VERSION}-${ARCH}.msi
mkdir -p "$BUILD_DIR"
mkdir -p "$INSTALL_DIR"


meson "$SRC_DIR" "$BUILD_DIR" $BUILD_OPTIONS --prefix="$INSTALL_DIR" \
      --cross-file w32-config.txt

# Compile
ninja -C "$BUILD_DIR" || exit 1
# Install
ninja -C "$BUILD_DIR" install || exit 1


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
     -I "$W32_DIR/build-aux/w32" -a "$ARCH_SHORT" \
     --wxidir "$WIXL_DIR" --wxidir "$SRC_DIR/build-aux/w32/include" \
     -o "$FILE_NAME" my-gtemplate.wxs binaries.wxs || exit 1

echo -n "msi installer for MS Windows created at "
echo "$SRC_DIR/build-aux/w32/$FILE_NAME"
