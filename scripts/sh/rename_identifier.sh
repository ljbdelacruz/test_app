#!/bin/bash

# Usage: ./rename_identifier.sh com.example.newpackage

NEW_PACKAGE_NAME=$1

if [ -z "$NEW_PACKAGE_NAME" ]; then
  echo "Usage: $0 <new-package-name>"
  exit 1
fi

# Update Android package name
ANDROID_MANIFEST="android/app/src/main/AndroidManifest.xml"
GRADLE_FILE="android/app/build.gradle.kts"
MAIN_ACTIVITY="android/app/src/main/kotlin"

# Extract the current package name from AndroidManifest.xml
CURRENT_PACKAGE_NAME=$(grep -oE 'package="[^"]+"' $ANDROID_MANIFEST | cut -d'"' -f2)

# Update package name in AndroidManifest.xml
sed -i '' "s/package=\"$CURRENT_PACKAGE_NAME\"/package=\"$NEW_PACKAGE_NAME\"/" $ANDROID_MANIFEST

# Update applicationId in build.gradle
sed -i '' "s/applicationId \"$CURRENT_PACKAGE_NAME\"/applicationId \"$NEW_PACKAGE_NAME\"/" $GRADLE_FILE

# Update package name in MainActivity.kt and other Kotlin files
find $MAIN_ACTIVITY -type f -name "*.kt" -exec sed -i '' "s/$CURRENT_PACKAGE_NAME/$NEW_PACKAGE_NAME/g" {} +

# Rename the directory structure to match the new package name
NEW_PACKAGE_DIR=$(echo $NEW_PACKAGE_NAME | tr '.' '/')
CURRENT_PACKAGE_DIR=$(echo $CURRENT_PACKAGE_NAME | tr '.' '/')
NEW_PACKAGE_PATH="android/app/src/main/kotlin/$NEW_PACKAGE_DIR"
CURRENT_PACKAGE_PATH="android/app/src/main/kotlin/$CURRENT_PACKAGE_DIR"

mkdir -p "$NEW_PACKAGE_PATH"
mv "$CURRENT_PACKAGE_PATH"/* "$NEW_PACKAGE_PATH"
rm -rf "$CURRENT_PACKAGE_PATH"

# Update iOS bundle identifier
IOS_INFO_PLIST="ios/Runner/Info.plist"
IOS_PROJECT_FILE="ios/Runner.xcodeproj/project.pbxproj"

sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]*;/PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE_NAME;/" $IOS_PROJECT_FILE
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $NEW_PACKAGE_NAME" $IOS_INFO_PLIST

echo "Package name and bundle identifier updated to $NEW_PACKAGE_NAME"