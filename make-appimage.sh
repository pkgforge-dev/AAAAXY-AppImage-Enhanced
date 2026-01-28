#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q aaaaxy | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/divVerent/aaaaxy/4fc3e4a1448e402b0c948b318b46f54d873c1573/aaaaxy.svg
export DESKTOP=/usr/share/applications/aaaaxy.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/aaaaxy

# Add SDL gamecontroller database
wget --retry-connrefused --tries=30 "https://github.com/divVerent/aaaaxy/releases/download/v${VERSION}/sdl-gamecontrollerdb-for-aaaaxy-v${VERSION}.zip" -O /tmp/sdldb.zip
mkdir -p ./AppDir/share/AAAAXY-sdlgamecontrollerdb
unzip /tmp/sdldb.zip  -d ./AppDir/share/AAAAXY-sdlgamecontrollerdb
echo 'SDL_GAMECONTROLLERCONFIG=${SHARUN_DIR}/share/AAAAXY-sdlgamecontrollerdb'

# Turn AppDir into AppImage
quick-sharun --make-appimage
