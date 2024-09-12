#!/usr/bin/env bash
git apply ./scripts/enable-android-google-services.patch
beep_ORIG_GROUP="im.beep"
beep_ORIG_TEAM="4NXF6Z997G"
#beep_NEW_GROUP="com.example.beep"
#beep_NEW_TEAM="ABCDE12345"

# In some cases (ie: running beta XCode releases) some pods haven't updated their minimum version
# but XCode will reject the package for using too old of a minimum version. 
# This will fix that, but. Well. Use at your own risk.
# export I_PROMISE_IM_REALLY_SMART=1

# If you want to automatically install the app
# export beep_INSTALL_IPA=1

### Rotate IDs ###
[ -n "${beep_NEW_GROUP}" ] && {
	# App group IDs
	sed -i "" "s/group.${beep_ORIG_GROUP}.app/group.${beep_NEW_GROUP}.app/g" "macos/Runner/Runner.entitlements"
	sed -i "" "s/group.${beep_ORIG_GROUP}.app/group.${beep_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
	# Bundle identifiers
	sed -i "" "s/${beep_ORIG_GROUP}.app/${beep_NEW_GROUP}.app/g" "macos/Runner.xcodeproj/project.pbxproj"
}

[ -n "${beep_NEW_TEAM}" ] && {
	# Code signing team
	sed -i "" "s/${beep_ORIG_TEAM}/${beep_NEW_TEAM}/g" "macos/Runner.xcodeproj/project.pbxproj"
}

### Make release build ###
flutter build macos --release

cp /usr/local/Cellar/libolm/**/lib/libolm.3.dylib build/macos/Build/Products/Release/beep.app/Contents/Frameworks/libolm.3.dylib

echo "Build build/macos/Build/Products/Release/beep.app"
