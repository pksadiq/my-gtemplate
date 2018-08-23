#!/usr/bin/env bash

# Written in 2017, 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to
# the public domain worldwide.  This software is distributed without
# any warranty.

# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

package_name="$1"
build_dir="$2"
po_dir="$3"
target_prefix="$4"
to_subdir="$5" # Install in sub directory?
pot_file="${package_name}.pot"
old_dir="$(pwd)"

cd "$build_dir"
ninja "${target_prefix}${package_name}-pot"

echo -n "language list (separated by space): "
read langs

is_locale ()
{
  lang="$1"

  # Be dumb, and assume the language exists
  # if locale binary isn't present
  if [ ! "$(which locale)" ]; then
    return $(true)
  fi

  # Get the locale list, ignore dotted ones
  # because we always assume UTF-8 encoding
  locale="$(locale -a | grep "^${lang}\(_\|$\)")"

  if [ -z "$locale" ]; then
    return $(false)
  fi

  return $(true)
}

create_po ()
{
  orig_lang="$1"
  cd "$po_dir"

  msginit --no-translator -o temp.po -i $pot_file -l ${orig_lang}.UTF-8 >/dev/null 2>&1
  # Set the charset as UTF-8
  sed -i '1,18{s/; charset=[0-9a-zA-Z_-]*/; charset=UTF-8/}' temp.po

  # Extract the language name from create po file
  lang=$(head -n 18 temp.po | grep "^[ ]*\"Language: ")
  lang=$(echo "$lang" | grep -o ": [0-9a-zA-Z_@.]*" | tr -d ': ')

  # Add the language to LINGUAS file sorted
  if [ -f LINGUAS ]; then
    # This assumes that first line is a comment
    (head -n 1 LINGUAS && (echo $lang && tail -n +2 LINGUAS) | sort -u) > temp_file
    mv temp_file LINGUAS
  else
    echo "LINGUAS file missing in $PWD"
  fi

  if [ $to_subdir ] && [ -f $lang/$lang.po ] || [ -f $lang.po ]; then
    echo "“$lang.po” file already present."
    return
  fi

  if [ $to_subdir ]; then
    mkdir -p $lang
    cp temp.po $lang/$lang.po
  else
    cp  temp.po $lang.po
  fi

  echo "“$lang.po” created"
}

set_case ()
{
  if [[ $1 != *_* ]]; then
    echo ${1,,}
  fi

  full_lang=${1^^}
  country="${lang#*_}"
  full_lang=${full_lang,,}

  echo "${full_lang%_*}_${country^^}"
}

for lang in $langs; do
  lang=$(set_case $lang)
  if is_locale $lang; then
    create_po $lang
  else
    echo "Language “$lang.po” does not exist."
    echo "Is it present in 'locales -a'?"
  fi
done

# Clean up
cd "$po_dir"
rm -rf temp.po
rm -rf $pot_file
