#!/usr/bin/env bash

# generate a temporary signing key adn apply its configuration
cd android
KEYFILE="$(pwd)/key.jks"
echo "Generating signing configuration with $KEYFILE..."
keytool -genkey -keyalg RSA -alias key -keysize 4096 -dname "cn=beep CI, ou=Head of bad integration tests, o=beep HQ, c=TLH" -keypass beep -storepass beep -validity 1 -keystore "$KEYFILE" -storetype "pkcs12"
echo "storePassword=beep" >> key.properties
echo "keyPassword=beep" >> key.properties
echo "keyAlias=key" >> key.properties
echo "storeFile=$KEYFILE" >> key.properties
ls | grep key
cd ..

# build release mode APK
flutter pub get
flutter build apk --release

# install and launch APK
flutter install
adb shell am start -n chat.fluffy.beep/chat.fluffy.beep.MainActivity

sleep 5

# check whether beep runs
adb shell ps | awk '{print $9}' | grep chat.fluffy.beep
