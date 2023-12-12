#!/usr/bin/env python3


import os
import pwd
import re
import shutil
import configparser
from pathlib import Path
from email.utils import parseaddr as parseemail
from gi.repository import Gio

app_id = ""
app_name = ""
author_name = ""
author_email = ""
project_name = ""
app_name_prefix = ""
app_name_suffix = ""
app_class_prefix = ""

old_app_id = "org.sadiqpk.GTemplate"
old_app_name = "my-gtemplate"
old_author_name = "Mohammed Sadiq"
old_author_email = "sadiq@sadiqpk.org"
old_project_name = "My GTemplate"
old_app_name_prefix = "mgt"
old_app_name_suffix = "gtemplate"
old_app_class_prefix = "Mgt"


def get_valid_str(value_type: str, initial_value: str) -> str:
    value = input(f"{value_type} [{initial_value}]: ") or initial_value
    while not value:
        print(f"'{value}' should not be empty")
        value = input(f"{value_type} []: ")
    return value


def email_is_valid(email: str) -> bool:
    email = parseemail(email)[1]
    if email and "@" in email and "." in email:
        return True
    return False


def get_valid_email(value_type: str, initial_value: str) -> str:
    value = input(f"{value_type} [{initial_value}]: ") or initial_value
    while not email_is_valid(value):
        print(f"'{value}' is not a valid email")
        value = input(f"{value_type} []: ")
    return value


def get_project_name(name: str) -> str:
    if not name:
        value = "my-app"
    regex = "^[a-z][a-z0-9-]+[a-z0-9]+$"
    value = name.replace(" ", "-").lower()
    value = input(f"Project Name ({regex})[{value}]: ") or value
    while not re.match(regex, value):
        print(f"'{value}' is not a valid project name")
        value = input(f"Project Name ({regex}) []: ")
    return value


def get_app_id(name: str) -> str:
    app_id = "org.example." + name.title().replace(" ", "")

    # A unique ID for your application.
    # This is also used as the base resource path (replacing . with /)
    # If you own the domain "example.com" you may use "com.example.Application"
    # Or, if the project is hosted at "gitlab.com/user/application"
    # you can may "com.gitlab.user.Application"
    help_url = "https://developer.gnome.org/documentation/tutorials/application-id.html"
    app_id = input(f"Application ID, See {help_url} [{app_id}]: ") or app_id

    while not Gio.Application.id_is_valid(app_id):
        print(f"'{app_id}' is not a valid Application ID")
        app_id = input(f"Application ID, See {help_url} []: ")
    return app_id


def get_app_name_prefix(name: str) -> str:
    if not name:
        name = "My App"
    regex = "^[a-z][a-z]+$"
    prefix = "".join([c for c in name if c.isupper()]).lower()
    prefix = input(f"Project Prefix ({regex})[{prefix}]: ") or prefix
    while not re.match(regex, prefix):
        print(f"'{prefix}' is not a valid Application prefix")
        prefix = input(f"Project Prefix ({regex})[]: ")
    return prefix


def get_app_name_suffix(name: str) -> str:
    if not name:
        name = "My App"
    regex = "^[a-z][a-z]+$"
    *_, suffix = name.lower().split()
    suffix = input(f"Project Suffix ({regex})[{suffix}]: ") or suffix
    while not re.match(regex, suffix):
        print(f"'{suffix}' is not a valid Application suffix")
        suffix = input(f"Project Suffix ({regex})[]: ")
    return suffix


def get_app_class_prefix(name_prefix: str) -> str:
    if not name_prefix:
        name_prefix = "mgt"
    regex = "^([A-Z]+[a-z]+)+$"
    prefix = name_prefix.title()
    prefix = input(f"App Class Prefix ({regex})[{prefix}]: ") or prefix
    while not re.match(regex, prefix) or prefix.lower() != name_prefix:
        print(f"'{prefix}' is not a valid Application prefix")
        if prefix.lower() != name_prefix:
            print("Class name and Name prefix should only differ in case")
        prefix = input(f"Application Class Prefix ({regex})[]: ")
    return prefix


def guess_author_details() -> tuple[str, str]:
    name = ""
    email = ""

    config = configparser.ConfigParser()
    git_config = config.read(os.path.expanduser("~/.gitconfig"))

    # Try if we have some name in gitconfig
    if git_config:
        try:
            name = config["user"]["name"]
            email = config["user"]["email"]
        except KeyError:
            pass

    # If we didn't get a name from git, guess the name from OS
    if not name:
        name = pwd.getpwuid(os.getuid())[4].split(",")[0]

    return name, email


def copy_project_files():
    project_dir = Path(__file__).parent / app_name

    items_to_copy = list(Path(__file__).parent.iterdir())
    items_to_copy.remove(Path(__file__).parent / "create-project.py")
    try:
        items_to_copy.remove(Path(__file__).parent / "COPYING")
        items_to_copy.remove(Path(__file__).parent / ".git")
        items_to_copy.remove(Path(__file__).parent / ".mypy_cache")
        items_to_copy.remove(list(Path(__file__).parent.rglob("*~")))
    except ValueError:
        pass

    os.mkdir(project_dir)
    print(f"Copying files to '{project_dir}'")
    for f in items_to_copy:
        if f.is_dir():
            shutil.copytree(f, project_dir / f.name)
        else:
            shutil.copyfile(f, project_dir / f.name)
            if f.name == "run.in":
                try:
                    os.chmod(project_dir / f.name, 0o755)
                except Exception as e:
                    pass


def update_project_files_content():
    project_dir = Path(__file__).parent / app_name

    files_to_change = list(project_dir.rglob("*.build"))
    files_to_change += list(project_dir.rglob("*.doap"))
    files_to_change += list(project_dir.rglob("*.in"))
    files_to_change += list(project_dir.rglob("*.md"))
    files_to_change += list(project_dir.rglob("*.sh"))
    files_to_change += list(project_dir.rglob("*.po"))
    files_to_change += list(project_dir.rglob("*.json"))
    files_to_change += list(project_dir.rglob("*.txt"))
    files_to_change += list(project_dir.rglob("*.ui"))
    files_to_change += list(project_dir.rglob("*.xml"))
    files_to_change += list(project_dir.rglob("*.wxs"))
    files_to_change += list(project_dir.rglob("*.[ch]"))
    files_to_change += list(project_dir.rglob("*.page"))
    files_to_change += list(project_dir.rglob(f"*my-gtemplate"))

    app_name_snake = app_name.replace("-", "_")
    old_app_name_snake = old_app_name.replace("-", "_")

    app_path = "/".join(app_id.split("."))
    old_app_path = "/".join(old_app_id.split("."))

    for f in files_to_change:
        with open(f, "r") as fp:
            content = fp.read()
            content = content.replace(old_app_id, app_id)
            content = content.replace(old_app_path, app_path)
            content = content.replace(old_project_name, project_name)
            content = content.replace(old_app_name, app_name)
            content = content.replace(old_app_name_snake, app_name_snake)
            content = content.replace(old_app_name_prefix, app_name_prefix)
            content = content.replace(old_app_name_suffix, app_name_suffix)
            content = content.replace(
                old_app_name_prefix.upper(), app_name_prefix.upper()
            )
            content = content.replace(old_app_class_prefix, app_class_prefix)
            if not f.name.endswith(".sh"):
                content = content.replace(old_author_name, author_name)
                content = content.replace(old_author_email, author_email)

        with open(f, "w") as fp:
            fp.write(content)


def rename_project_files():
    new_project_dir = Path(__file__).parent / app_name

    files_to_rename = list(new_project_dir.rglob(f"{old_app_id}*"))
    files_to_rename += list(new_project_dir.rglob(f"{old_app_name}*"))
    files_to_rename += list(new_project_dir.rglob(f"{old_app_name_suffix}*"))
    files_to_rename += list(new_project_dir.rglob(f"{old_app_name_prefix}*"))

    for f in files_to_rename:
        if f.name.find(old_app_id) != -1:
            new_path = f.parent / str(f.name).replace(old_app_id, app_id)
            shutil.move(f, new_path)
        elif f.name.find(old_app_name) != -1:
            new_path = f.parent / str(f.name).replace(old_app_name, app_name)
            shutil.move(f, new_path)
        elif f.name.find(old_app_name_prefix) != -1:
            new_path = f.parent / str(f.name).replace(
                old_app_name_prefix, app_name_prefix
            )
            shutil.move(f, new_path)
        elif f.name.find(old_app_name_suffix) != -1:
            new_path = f.parent / str(f.name).replace(
                old_app_name_suffix, app_name_suffix
            )
            shutil.move(f, new_path)


def cleanup_project_files():
    new_project_dir = Path(__file__).parent / app_name
    index = -1

    shutil.rmtree(new_project_dir / "build-aux" / "w32")

    with open(new_project_dir / "meson.build", "r") as fp:
        lines = fp.readlines()

    for i, line in enumerate(lines):
        if line.strip("\n") == "if host_machine.system() == 'windows'":
            index = i
            break

    # Delete w32 config as it's not tested with GTK4
    if index != -1:
        with open(new_project_dir / "meson.build", "w") as fp:
            fp.writelines(lines[:index])
            fp.writelines(lines[index + 4 :])


def main():
    global app_id
    global app_name
    global author_name
    global author_email
    global project_name
    global app_name_prefix
    global app_name_suffix
    global app_class_prefix

    print("Welcome to My GTemplate")

    # Real Application name shown in application list, about/help page.
    project_name = get_valid_str("Application Name", "My App")

    # app_name shall be used as the binary name, directory name.
    # The directory will be created in the project directory
    # (ie, in my-gtemplate directory)
    app_name = get_project_name(project_name)

    project_dir = Path(__file__).parent / app_name

    if project_dir.is_dir():
        remove_existing = ""
        while not remove_existing:
            remove_existing = input(
                f"Directory '{project_dir}' exists, do you want to remove it? [y/n]: "
            ).lower()
        if remove_existing == "y":
            shutil.rmtree(project_dir)
            print(f"Removed directory '{project_dir}'")
        else:
            exit()

    app_id = get_app_id(project_name)
    author_name, author_email = guess_author_details()

    author_name = get_valid_str("Author Name", author_name)
    author_email = get_valid_email("Author Email", author_email)

    app_name_prefix = get_app_name_prefix(project_name)
    app_name_suffix = get_app_name_suffix(project_name)
    app_class_prefix = get_app_class_prefix(app_name_prefix)

    copy_project_files()
    update_project_files_content()
    rename_project_files()
    cleanup_project_files()

    print("Copy complete.  Update README.md and update all http links")
    man_file = app_name + "/docs/man/" + app_name + ".xml"
    ref_file = app_name + "/docs/reference/" + app_name + "-docs.xml"
    print(f"Also update first and last names in '{man_file}' and '{ref_file}'")
    print("Happy Hacking!")


if __name__ == "__main__":
    main()
else:
    raise ImportError("create-project.py can't be imported")
