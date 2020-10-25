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

W32_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "$W32_DIR" && cd ../../ && pwd)"

. "$W32_DIR/defaults.sh.in"
OPTIMIZE="$1"
ARCH="$2"


if [ "$OPTIMIZE" = "no" ]; then
  OPTIMIZE=""
fi

if [ "$OPTIMIZE" ]; then
  MESON_OPT="-Doptimize=true"
else
  MESON_OPT="-Doptimize=false"
fi

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
    echo "Arch '$ARCH' not understood."
    echo "Supported Architectures: i686 x86_64"
    echo "Exiting..."
    exit 1
  fi

  DEFAULT_PACKAGES="mingw${BIT}-gtk3 meson gcc gtk3-devel msitools"

  sudo dnf install -y $DEFAULT_PACKAGES $USER_PACKAGES
}

# Check if the system is Fedora or derivatives
DNF=$(which dnf)

# Fedora seems to be the only OS that officially supports
# Mingw GTK.
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


if ! grep "cpu = '$ARCH'" "$W32_DIR/w32-config.txt" 2>/dev/null; then
  cat > "$W32_DIR/w32-config.txt" << EOF
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
fi

meson "$SRC_DIR" "$BUILD_DIR" --prefix="$INSTALL_DIR" \
      --cross-file "$W32_DIR/w32-config.txt"
meson configure "$BUILD_DIR" $MESON_OPT $BUILD_OPTIONS

ninja -C "$BUILD_DIR" || exit 1
ninja -C "$BUILD_DIR" install

if [ "$OPTIMIZE" ]; then
  pushd "$INSTALL_DIR/bin/"
  $STRIP *.exe
  popd
fi

echo ""
echo "Now run 'ninja -C $BUILD_DIR dist-msi' to create installer"
