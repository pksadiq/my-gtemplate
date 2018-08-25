#!/bin/bash

# Encode svg icons as png in separate sizes.
# The folder named 'scalable' in current directory is
# used as source.
# The directory structure and filesnames in output
# shall be the same as in the 'scalable' directory

# Written by Mohammed Sadiq <sadiq@sadiqpk.org>
# Last Updated: 2017 December 01
# I here by declare this file as public domain

# Dimension (considered as the pixel size of a square)
# Folders are created based on this.  Say for example,
# folders like 16x16, 24x24 etc. are created.
TARGETS="16 22 32 48 256 512"


INKSCAPE=$(which inkscape)
if [ -z "$INKSCAPE" ]; then
  echo "inkscape binary not found. Please install"
  exit 1
fi

old_dir=$(pwd)

create_icons()
{
  SIZE=$1
  dir=$2
  TARGET=$3

  for file in scalable/$dir/*.svg
  do
      $INKSCAPE -z "$file" -e "$SIZE/$dir/$(basename ${file%.svg}.png)"\
                -w $TARGET -h $TARGET -y 0.0
  done
}

# Create Target directories
for TARGET in $TARGETS
do
  SIZE="${TARGET}x${TARGET}"
  for dir in scalable/*/
  do
    dir=$(basename $dir)
    mkdir -p $SIZE/$dir
    create_icons $SIZE $dir $TARGET
  done
done

if [ "$(which convert) "]; then
  # Use "-compress None" argument to disable compression
  convert -density 384 256x256/apps/org.sadiqpk.GTemplate.png icon.ico
else
  echo "If you support MS windows, install Image magic to create .ico icons"
fi
