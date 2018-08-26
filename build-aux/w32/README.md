# Build my-gtemplate for MS windows

The scripts in this directory shall build my-gtemplate
for MS windows platform using MinGW environment.  An
installer can also be created using msitools.
Until GTK4 is realeased, only GTK3 is supported.

## Required software pieces

To build my-gtemplate for MS windows, latest version
of Fedora is required (64 bit recommended).


The following tools are used to build msi:
* [msitools](https://wiki.gnome.org/msitools)
* [MinGW](http://www.mingw.org)


## Building my-gtemplate

To build for windows and to create an installer do:

```
meson _build -Dw32=true
ninja -C _build dist-msi
```

This will create an installable `msi` file.  Please note that
when running the above command for the first time, packages of
size to several 100 MiBs shall be downloaded.


## Install and run using wine

You may use wine to test the application.  To run the application
in wine, do the following after installing wine:

Assuming that the file is `installer.msi`

```sh
# Installing installer.msi, writing installation logs to log.txt
wine msiexec /i installer.msi /l*v log.txt
# Running the application.
# Change the path to match you installation
cd "$HOME/.wine/drive_c/Program Files/My GTemplate"
XDG_DATA_DIRS="./share" wine bin/my-gtemplate.exe
```
