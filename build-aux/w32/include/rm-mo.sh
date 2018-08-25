#!/usr/bin/env bash

# Written in 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to
# the public domain worldwide.  This software is distributed without
# any warranty.

# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.


# This is a pretty dumb - hopefully working - hack to remove
# traslation files (.mo) from the .wix files.  If you need to
# add more translations, redownload all the required files from
# https://gitlab.gnome.org/GNOME/msitools/tree/master/data/wixl
# and update MO_FILES with the required language short names
# and run this script.

# Translations to keep
# All other translations will be deleted
MO_FILES="en_CA en_GB"


# We have to create: Name=\"x\"\|Name=\"y\"|Name=\"z\"
SED_REGEX="Name=\\\"${MO_FILES}\\\""
SED_REGEX=$(echo "$SED_REGEX" | sed 's/ /\\"\\|Name=\\"/g')
GREP_REGEX=$(echo "$SED_REGEX" | tr -d '\\')

find_matches ()
{
  MATCHES=$(grep \"LC_MESSAGES\" $FILE -A$((COUNT - 4)) -B1 | grep "Id=\"cmp[0-9A-Za-z]*" -B2)

  DIRS=$(echo "$MATCHES" | grep Name | grep -v LC_MESSAGES | egrep -v "$GREP_REGEX")
  DIRS=$(echo $DIRS | grep "dir[0-9A-Za-z]*" -o)

  IDS=$(echo "$MATCHES" | sed  "/$SED_REGEX/,+$((COUNT - 4))d" | grep "cmp[0-9A-Za-z]*" -o)
}

delete_mo ()
{
  # Delete matching ComponentRefs
  for id in $IDS
  do
    sed -i "/ComponentRef Id=\"$id\"/ d" $FILE
  done

  # # Delete directories
  for dir in $DIRS
  do
    sed -i "/$dir/,+${COUNT}d" $FILE
  done
}


FILES=$(ls *.wxi)

for file in $FILES
do
  COUNT="6"
  if [ "$file" = "gtk3.wxi" ]; then
    COUNT="9"
  fi

  FILE=$file
  echo "Deleting translations from $FILE"

  find_matches
  delete_mo
done
