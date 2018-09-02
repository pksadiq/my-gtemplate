<div align="center">
  <a href="https://www.sadiqpk.org/projects/my-gtemplate.html">
    <img src="https://gitlab.com/sadiq/my-gtemplate/raw/master/data/icons/hicolor/256x256/apps/org.sadiqpk.GTemplate.png" width="150" />
  </a>
  <br>

  <a href="https://www.sadiqpk.org/projects/my-gtemplate.html"><b>My GTemplate</b></a>
  <br><br>

  <a href="https://gitlab.com/sadiq/my-gtemplate/commits/master"><img
       src="https://gitlab.com/sadiq/my-gtemplate/badges/master/build.svg" /></a>
  <a href="https://gitlab.com/sadiq/my-gtemplate/commits/master"><img
       src="https://gitlab.com/sadiq/my-gtemplate/badges/master/coverage.svg" /></a>
  <br>

  A Simple feature rich GTK3/GTK4 Application template in C
</div>

---

My GTemplate is a simple Gtk+ Application that can be used as a
template to begin your Gtk+ Application developement.

By default, the template itself does nothing other than showing
an empty window.
The template includes lots of features above which you can build
your own application.

If you wish to support me, you may kindly donate me at
https://liberapay.com/sadiq/donate

Source Repository: [GitLab][gitlab], [GitHub][github]

Issues and Feature Requests: [GitLab][issues]

Please visit the [website][home] for more details.

## License

Despite of whatever some source file contain as License blurb,
All code included in this repository are released into Public
Domain.  If you wish to contribute to this project, it is assumed
that you are contributing under the same terms below.

Some source files have GNU GPLv3+ blurb to simply ease creating
free software projects.  If you wish to use a different license
term for you project, go for it.  Don’t even mention me.

Written in 2017, 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to
the public domain worldwide.  This software is distributed without
any warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software.  If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.


## Features

* Written in C programming language
* [G]Object Oriented Design
* Supports GTK3 and GTK4
* Meson build system with fallback configure script
* Configure script for compatibility.
  * the good old `./configure && make && make install` works out of
    the box
  * **Note:** If you are intending to package it in Distributions like
    Debian, you may better rename `configure` script to something else,
    so that it won’t interfere with the the distribution build scripts.
* Builtin flatpak support
* GitLab CI configuration included (Gtk3 only)
* Microsoft Windows support with MinGW and msitools
* GtkBuilder .ui templates for UI
* Application specific CSS
* Keyboard shortcuts window
* Handles commandline arguments
* Tab completion for commandline
* Internationalisation using gettext
* Documentations for code using `gtk-doc`
  * This will be added to `devhelp` on install.
* Mallard based help using `yelp` (That is, GNOME Help)
* Manpage in docbook XML format
* GSettings integration
  * window states (size, position and maximized state) are stored
    and loaded by default
* Symbolic and non-symbolic icons
* Script to generate png icons from scalable icons
* Script to generate non-symbolic icons from symbolic ones
* Uncrustify configuration and script
* Meson based unit tests


## Build system

`meson` is used as the build system.
`./configure && make && sudo make install` will build the application
and install it to the install directory (by default `/usr/local/`).

The following arguments are understood by `make`:
* `make`: Build the application.
* `make install`: Install the application built.
* `make check`: Run meson tests.
* `make authors`: Build AUTHORS file, sorted with commit count
                   in the repository.
* `make po`: Create po file for the Application in the languages
             given.  The languages are also added to `po/LINGUAS`
             file if required.
* `make help-po`: The same for help files
* `make update-po`: update the po files with adding new strings.

And much more.  You can get the targets via TAB completion after `make`
command.


### Detailing the paths and files

```
my-gtemplate
├── build-aux ── Helper scripts for build
├── completion
│   └── my-gtemplate ── Add your commandline TAB completions in this file
├── configure
├── COPYING ── By default GNU GPLv3.  Use the one you wish
├── data
│   ├── icons
│   │   ├── hicolor
│   │   │   ├── render-icons.sh ── Run this script once you add app icon
│   │   │   ├── scalable ── Add your Application icon here
│   │   │   │   └── apps
│   │   │   │       └── org.sadiqpk.GTemplate.svg
│   │   │   └── symbolic
│   │   │       └── apps
│   │   │           └── org.sadiqpk.GTemplate-symbolic.svg ── symbolic version
│   ├── org.sadiqpk.GTemplate.desktop.in
│   └── org.sadiqpk.gtemplate.gschema.xml
├── docs
│   ├── help ──
│   │   ├── C
│   │   │   └── index.page ── Add the help pages shown in GNOME Help
│   │   ├── LINGUAS ── Automatilly updated with ~make help-po~
│   ├── man
│   │   └── my-gtemplate.xml
│   └── reference
│       ├── my-gtemplate-docs.xml
│       └── my-gtemplate-sections.txt
├── flatpak
│   └── org.sadiqpk.GTemplate.yml
├── po
│   ├── LINGUAS ── List of languages for which translations are included.
│   └── POTFILES.in ── List of files to be considered for translation
├── README.org
├── src ── The real source of your application
│   └── resources
│       ├── css
│       │   └── mgt.css
│       ├── gtemplate.gresource.xml
│       ├── gtk
│       │   ├── help-overlay.ui
│       └── ui
│           └── mgt-window.ui
├── tests
│   └── settings.c ── Simple test to show how to add one
├── uncrustify.cfg
└── uncrustify.sh ── Script to keep your code clean and tidy
```

<!-- Links referenced elsewhere -->
[home]: https://www.sadiqpk.org/projects/my-gtemplate.html
[gitlab]: https://gitlab.com/sadiq/my-gtemplate
[github]: https://github.com/pksadiq/my-gtemplate
[issues]: https://gitlab.com/sadiq/my-gtemplate/issues
