#!/usr/bin/env bash


# Author Name and Email.
# Used in copyright string and about dialog
AUTHOR="Random Name"
FIRST_NAME="Random"
LAST_NAME="Name"

EMAIL="random@example.com"

# If you have no website/blog leave it blank so
# that your email will be used in the About window.
WEBSITE="https://www.sadiqpk.org"

# APP_NAME will be used as the binary name, directory name.
# The directory will be created in the project directory
# (ie, in my-gtemplate directory)
# WARNING: The content of the directory will be removed,
# if the directory already exists.
APP_NAME="gee-tasks"

# Used for gresource and library name
# usually the last part of the APP_NAME
APP_LAST_NAME="tasks"

# Real Application name shown in application list, about/help page.
APP_REAL_NAME="Gee Tasks"

# A unique ID for your application.
# See https://wiki.gnome.org/HowDoI/ChooseApplicationID
# This is also used as the base resource path (replacing . with /)
# If you own the domain "example.com" you can use "com.example.Application"
# Or, if the project is hosted at "gitlab.com/user/application"
# you can use "com.gitlab.user.Application"
APP_ID="com.example.Tasks"

# Shortform of the application.
# Used as filename prefix, function name prefix, etc.
# Usually, the first letters from APP_NAME is used.
# So for "gnome-taskes" it can be "gt", for example.
APP_SHRT="gtsk"

# Shortform used as NameSpace.
APP_SHRT_CAP="GTsk"

# Web Addresses
# Replace the variables with your project URLs.  If
# you are hosting at GitLab.com, you may require to
# change USER_NAME only, and sometime BASE_URL too.
USER_NAME="sadiq"
BASE_URL="https://gitlab.com/$USER_NAME/$APP_NAME"
URL="https://$USER_NAME.gitlab.io/$APP_NAME"
HELP_URL="$BASE_URL/wikis/home"
DOWNLOAD_URL="$BASE_URL/tags"
COVERAGE_URL="$URL/coverage"
BUG_URL="$BASE_URL/issues"
GIT_URL="$BASE_URL.git"
# Replace with your donation link
DONATE_URL="https://liberapay.com/sadiq/donate"

# This is the URL where your screenshots are available.
# That is, APPDATA_URL/data/appdata/01-window.png should
# be a direct link to the window image.
APPDATA_URL="$BASE_URL/raw/master"

# GNOME user ID
# Fill in you username if you are a GNOME Foundation member
GNOME_ID=""




# The real actions.  Don’t touch unless you know
# Override if commandline argument present
rm -rf "$APP_NAME"
mkdir -p "$APP_NAME"
cd "$APP_NAME"
if [ "$(basename $(pwd))/" != "$APP_NAME/" ]; then
  echo "could not cd to \"$APP_NAME\". exiting..."
  exit
fi

cd ..

# Copy content
echo "Copying files... "
cp -r * "$APP_NAME"
cp -r .gitlab "$APP_NAME"
cp .gitignore "$APP_NAME"
echo "done"

cd "$APP_NAME"

echo -n "Removing unwanted files..."
rm -rf "$APP_NAME" new-project.sh
echo "done"

OLD_NAME="my-gtemplate"
OLD_REAL_NAME="My GTemplate"
OLD_APP_LAST_NAME="gtemplate"
OLD_ID="org.sadiqpk.GTemplate"
OLD_SHRT="mgt"
OLD_SHRT_CAP="Mgt"
OLD_AUTHOR="Mohammed Sadiq"
OLD_EMAIL="sadiq@sadiqpk.org"
OLD_WEBSITE="https://www.sadiqpk.org"
OLD_FIRST_NAME="Mohammed"
OLD_LAST_NAME="Sadiq"

OLD_URL="https://www.sadiqpk.org/projects/my-gtemplate.html"
OLD_HELP_URL="https://gitlab.com/sadiq/my-gtemplate/wiki"
OLD_DOWNLOAD_URL="http://www.sadiqpk.org/projects/my-gtemplate.html"
OLD_COVERAGE_URL="https://sadiq.gitlab.io/my-gtemplate/coverage"
OLD_BUG_URL="https://gitlab.com/sadiq/my-gtemplate/issues"
OLD_GIT_URL="https://gitlab.com/sadiq/my-gtemplate.git"
OLD_DONATE_URL="https://liberapay.com/sadiq/donate"
OLD_APPDATA_URL="https://gitlab.com/sadiq/my-gtemplate/raw/master"
# Remove the postfix '/' if any.
APPDATA_URL="${APPDATA_URL%/}"

OLD_NAME_="$(echo "$OLD_NAME" | tr '-' '_')"
APP_NAME_="$(echo "$APP_NAME" | tr '-' '_')"
OLD_ID_SLASH="$(echo "$OLD_ID" | tr '.' '/')"
APP_ID_SLASH="$(echo "$APP_ID" | tr '.' '/')"

OLD_ID_LOWER="$(echo "$OLD_ID" | tr A-Z a-z)"
APP_ID_LOWER="$(echo "$APP_ID" | tr A-Z a-z)"
OLD_NAME_UPPER="$(echo "$OLD_NAME" | tr a-z A-Z)"
APP_NAME_UPPER="$(echo "$APP_NAME" | tr a-z A-Z)"
OLD_SHRT_UPPER="$(echo "$OLD_SHRT" | tr a-z A-Z)"
APP_SHRT_UPPER="$(echo "$APP_SHRT" | tr a-z A-Z)"

# Replace strings
echo -n "Mass replacing template..."

# FIXME: May not be a good idea.  This could replace data from
# binary files.

# Update About window details
if [ "$WEBSITE" ]; then
  sed -i "s|${OLD_WEBSITE}\"|${WEBSITE}\"|" src/$OLD_SHRT-application.c
else
  sed -i "s|${OLD_WEBSITE}\"|<${EMAIL}>\"|" src/$OLD_SHRT-application.c
fi

sed -i "s|${OLD_APPDATA_URL}|${APPDATA_URL}|" ./data/appdata/$OLD_ID.appdata.xml.in
find . -type f -print0 | xargs -0 sed -i "s|${OLD_URL}|${URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_BUG_URL}|${BUG_URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_GIT_URL}|${GIT_URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_HELP_URL}|${HELP_URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_DONATE_URL}|${DONATE_URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_DOWNLOAD_URL}|${DOWNLOAD_URL}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_COVERAGE_URL}|${COVERAGE_URL}|g"

# Replace name and email except in shell scripts
find . -type f -not -iname '*.sh' -print0 | xargs -0 sed -i "s|${OLD_AUTHOR}|${AUTHOR}|g"
find . -type f -not -iname '*.sh' -print0 | xargs -0 sed -i "s|${OLD_FIRST_NAME}|${FIRST_NAME}|g"
find . -type f -not -iname '*.sh' -print0 | xargs -0 sed -i "s|${OLD_LAST_NAME}|${LAST_NAME}|g"
find . -type f -not -iname '*.sh' -print0 | xargs -0 sed -i "s|${OLD_EMAIL}|${EMAIL}|g"

find . -type f -print0 | xargs -0 sed -i "s|$OLD_ID_SLASH|$APP_ID_SLASH|g"
find . -type f -print0 | xargs -0 sed -i "s|$OLD_ID|$APP_ID|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_ID_LOWER}|${APP_ID_LOWER}|g"
find . -type f -name "*$OLD_ID*" | while read file; do mv "$file" "${file/$OLD_ID/$APP_ID}"; done
find . -type f -name "*${OLD_ID_LOWER}*" | while read file; do mv "$file" "${file/${OLD_ID_LOWER}/${APP_ID_LOWER}}"; done

find . -type f -print0 | xargs -0 sed -i "s|${OLD_NAME}|${APP_NAME}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_REAL_NAME}|${APP_REAL_NAME}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_NAME_UPPER}|${APP_NAME_UPPER}|g"
find . -type f -name "*${OLD_NAME}*" | while read file; do mv "$file" "${file/$OLD_NAME/$APP_NAME}"; done

find . -type f -print0 | xargs -0 sed -i "s|${OLD_SHRT}|${APP_SHRT}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_SHRT_UPPER}|${APP_SHRT_UPPER}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_SHRT_CAP}|${APP_SHRT_CAP}|g"
find . -type f -print0 | xargs -0 sed -i "s|${OLD_APP_LAST_NAME}|${APP_LAST_NAME}|g"
find . -type f -name "*${OLD_SHRT}*" | while read file; do mv "$file" "${file/$OLD_SHRT/$APP_SHRT}"; done
find . -type f -name "*${OLD_APP_LAST_NAME}*" | while read file; do mv "$file" "${file/$OLD_APP_LAST_NAME/$APP_LAST_NAME}"; done

# Change this last, so that CI works

echo "done"

# Replace CC0 with GPL
rm -rf COPYING
mv COPYING.GPL COPYING
sed -i "s|CC0-1.0</project_license>|GPL-3.0+</project_license>|" \
    ./data/appdata/${APP_ID}.appdata.xml.in

# Set GNOME user-id
if [ "$GNOME_ID" ]; then
  sed -i "s|pksadiq|$GNOME_ID|" ${APP_NAME}.doap
else
  sed -i "/pksadiq/d" ${APP_NAME}.doap
fi

if [ "$(which uncrustify)" ]; then
  echo "Running uncrustify..."
  ./uncrustify.sh
else
  echo "Please install 'uncrustify' to fix source code style."
fi

# Reset some values so that CI works
if [ "$CI" ]; then
  echo "Setting Continues Integration changes"
  sed -i "s|${APPDATA_URL}|${OLD_APPDATA_URL}|" ./data/appdata/${APP_ID}.appdata.xml.in
fi

echo "Done"
