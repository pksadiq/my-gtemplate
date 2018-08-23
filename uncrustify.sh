#!/bin/sh

# Written in 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to
# the public domain worldwide.  This software is distributed without
# any warranty.

# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.


if [ ! "$(which uncrustify)" ]; then
  echo "'uncrustify' Not found. Exiting..."
  exit 1
fi

if [ ! "$(which diff)" ]; then
  echo "'diff' Not found. Exiting..."
  exit 1
fi

# Handle only .c files.  There are unfixable issues uncrustifying .h header files
uncrustify -l c -c uncrustify.cfg --no-backup --mtime $(find . -path './src/*' -name '*.c')

# Simple Hack to work around issues with handling .h files
HEADER_FILES=$(find . -path './src/*' -name '*.h')

for file in $HEADER_FILES
do
  # Work on a copy.  Replace the file only if some actual change
  # happened.  Otherwise, every header file will have a new mtime
  # and that will result in compiling every file on rebuild.
  MTIME=$(stat -c '%Y' "$file")
  cp "$file" temp.h
  sed -i "/^G_DECLARE_/ s/)$/);/" temp.h
  cp temp.h temp.bak
  uncrustify -l c -c uncrustify.cfg --no-backup temp.h -q
  echo "Parsing: $file as language C"

  DIFF="$(diff temp.h temp.bak)"

  if [ "$DIFF" ]; then
    sed -i "/^G_DECLARE_/ s/;$//" temp.h
    mv temp.h "$file"
    # Reset modification time
    touch --date=@${MTIME} "$file"
  fi
done

# Remove temp files, if any.
rm -rf temp.h temp.bak
