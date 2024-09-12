# beep AppImage

beep is provided as AppImage too. To Download, visit beep.im.

## Building

- Ensure you install `appimagetool`

```shell
flutter build linux

# copy binaries to appimage dir
cp -r build/linux/{x64,arm64}/release/bundle appimage/beep.AppDir
cd appimage

# prepare AppImage files
cp beep.desktop beep.AppDir/
mkdir -p beep.AppDir/usr/share/icons
cp ../assets/logo.svg beep.AppDir/beep.svg
cp AppRun beep.AppDir

# build the AppImage
appimagetool beep.AppDir
```
