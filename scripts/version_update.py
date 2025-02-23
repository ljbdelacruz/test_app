import re
import os

# Increment iOS build number and project version
def increment_ios_version():
    pbxproj_path = 'ios/Runner.xcodeproj/project.pbxproj'
    version_txt_path = 'VERSION.txt'

    try:
        with open(pbxproj_path, 'r') as file:
            content = file.read()
        with open(version_txt_path, 'r') as file:
            current_version = file.read().strip()

        # Find and increment the build number
        content = re.sub(r'FLUTTER_BUILD_NAME = [^;]+;', f'FLUTTER_BUILD_NAME = {current_version};', content)

        # Replace the MARKETING_VERSION value
        content = re.sub(r'MARKETING_VERSION = [^;]+;', f'MARKETING_VERSION = {current_version};', content)

        build_number_match = re.search(r'FLUTTER_BUILD_NUMBER = (\d+);', content)
        if build_number_match:
            build_number = int(build_number_match.group(1)) + 1
            content = re.sub(r'FLUTTER_BUILD_NUMBER = \d+;', f'FLUTTER_BUILD_NUMBER = {build_number};', content)
            print(f'iOS build number incremented to {build_number}')
        else:
            build_number = 1
            content = re.sub(r'FLUTTER_BUILD_NUMBER = \d+;', f'FLUTTER_BUILD_NUMBER = {build_number};', content)
            print(f'iOS build number set to {build_number}')

        with open(pbxproj_path, 'w') as file:
            file.write(content)

        print(f'iOS project version incremented to {current_version}')
    except FileNotFoundError as e:
        print(f'Error: {e.filename} not found.')
    except Exception as e:
        print(f'Error: {str(e)}')

# Increment Android version code and version name in build.gradle
def increment_android_version():
    build_gradle_path = 'android/app/build.gradle.kts'
    version_txt_path = 'VERSION.txt'

    try:
        with open(build_gradle_path, 'r') as file:
            content = file.read()
        with open(version_txt_path, 'r') as file:
            current_version = file.read().strip()

        version_code_match = re.search(r'versionCode (\d+)', content)
        if version_code_match:
            current_version_code = int(version_code_match.group(1))
            new_version_code = current_version_code + 1
        else:
            raise ValueError("versionCode not found in build.gradle")

        content = re.sub(r'versionCode \d+', f'versionCode {new_version_code}', content)

        # Replace the versionName value
        content = re.sub(r'versionName "[^"]+"', f'versionName "{current_version}"', content)

        with open(build_gradle_path, 'w') as file:
            file.write(content)

        print(f'build.gradle version incremented to versionCode {new_version_code}, versionName {current_version}')
    except FileNotFoundError as e:
        print(f'Error: {e.filename} not found.')
    except Exception as e:
        print(f'Error: {str(e)}')

if __name__ == '__main__':
    increment_ios_version()
    increment_android_version()