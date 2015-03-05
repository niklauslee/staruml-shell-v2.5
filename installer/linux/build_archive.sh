#!/bin/bash

# grunt-contrib-copy doesn't preserve permissions
# https://github.com/gruntjs/grunt/issues/615
chmod 755 debian/package-root/opt/staruml/staruml
chmod 755 debian/package-root/opt/staruml/StarUML
chmod 755 debian/package-root/opt/staruml/Brackets-node

# set permissions on subdirectories
find debian -type d -exec chmod 755 {} \;

# delete old package
rm -f staruml.tar.gz

# Move everything we'll be using to a temporary directory for easy clean-up
mkdir -p archive/out
cp -r debian/package-root/opt/staruml archive/out

# Add staruml.svg
cp debian/package-root/usr/share/icons/hicolor/scalable/apps/staruml.svg archive/out/staruml

# Add the modified staruml.desktop file (call staruml instead of /opt/staruml/staruml)
cp archive/staruml.desktop archive/out/staruml

# Add the install.sh and uninstall.sh files.
cp archive/install.sh archive/out/staruml
cp archive/uninstall.sh archive/out/staruml
# README.md too.
cp archive/README.md archive/out/staruml

tar -cf staruml.tar -C archive/out staruml/

gzip staruml.tar

# Clean-up after ourselves once the tarball has been generated.
rm -rf archive/out
