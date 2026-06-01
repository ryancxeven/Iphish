#!/bin/bash

# Make Deb Package for IPhish (^.^)

_PACKAGE=iphish
_VERSION=2.0
_ARCH="all"
PKG_NAME="${*PACKAGE}*${*VERSION}*${_ARCH}.deb"

if [[ ! -e "scripts/launch.sh" ]]; then
echo "launch.sh should be in the `scripts` directory. Exiting..."
exit 1
fi

# Detect Termux / Android

if [[ ${1,,} == "termux" || $(uname -o) == *'Android'* ]]; then
_depend="ncurses-utils, proot, resolv-conf, "
_bin_dir="data/data/com.termux/files/"
_opt_dir="data/data/com.termux/files/usr/"
fi

# Required dependencies

_depend+="curl, php, wget, git, unzip"

_bin_dir+="usr/bin"
_opt_dir+="opt/${_PACKAGE}"

# Clean previous build

if [[ -d "build_env" ]]; then
rm -fr build_env
fi

# Create directories

mkdir -p build_env
mkdir -p ./build_env/${_bin_dir}
mkdir -p ./build_env/${_opt_dir}
mkdir -p ./build_env/DEBIAN

# Debian Control File

cat <<- CONTROL_EOF > ./build_env/DEBIAN/control
Package: ${_PACKAGE}
Version: ${_VERSION}
Architecture: ${_ARCH}
Maintainer: Ry4nCxeven
Depends: ${_depend}
Homepage: https://github.com/ryancxeven/Iphish
Description: Beginner-friendly phishing awareness and cybersecurity training toolkit for educational and authorized security testing purposes.
CONTROL_EOF

# Remove package on uninstall

cat <<- PRERM_EOF > ./build_env/DEBIAN/prerm
#!/bin/bash
rm -fr /${_opt_dir}
exit 0
PRERM_EOF

# Permissions

chmod 755 ./build_env/DEBIAN
chmod 755 ./build_env/DEBIAN/control
chmod 755 ./build_env/DEBIAN/prerm

# Copy launcher

cp -fr scripts/launch.sh ./build_env/${_bin_dir}/${_PACKAGE}
chmod 755 ./build_env/${_bin_dir}/${_PACKAGE}

# Copy project files

cp -fr LICENSE README.md iphish.sh ./build_env/${_opt_dir}

# Build package

dpkg-deb --build ./build_env ${PKG_NAME}

# Cleanup

rm -fr ./build_env

echo "[+] Package created successfully: ${PKG_NAME}"
