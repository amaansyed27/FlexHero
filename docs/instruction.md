# Instructions for FlexHero

This document provides comprehensive instructions for building, running, testing, and deploying the FlexHero app.

## Prerequisites

Before working with FlexHero, ensure you have the following installed:

1. **Flutter SDK**: Version 3.10.0 or higher
   - Visit [Flutter installation guide](https://flutter.dev/docs/get-started/install)

2. **Dart SDK**: Version 3.0.0 or higher (usually comes with Flutter)

3. **IDE**: Visual Studio Code with Flutter extension or Android Studio with Flutter plugin

4. **For mobile deployment**: Android SDK or Xcode (for iOS)

5. **For web deployment**: Chrome browser

## Environment Setup Verification

Run the following command to verify your Flutter environment:

```powershell
flutter doctor
```

This will check your installation and identify any issues that need to be addressed.

## Getting Started

### 1. Clone the Repository

```powershell
git clone https://github.com/your-username/FlexHero.git
cd FlexHero/flexhero
```

### 2. Install Dependencies

```powershell
flutter pub get
```

## Running the App

### Run on Android Emulator or Device

```powershell
flutter run
```

This will automatically select a connected device or emulator.

To specify a device:

```powershell
flutter devices                # List available devices
flutter run -d device_id       # Run on specific device
```

### Run on iOS Simulator (macOS only)

```powershell
open -a Simulator
flutter run
```

### Run on Web

```powershell
flutter run -d chrome
```

### Run on Desktop (Windows/macOS/Linux)

```powershell
flutter run -d windows          # For Windows
flutter run -d macos            # For macOS
flutter run -d linux            # For Linux
```

## Building the App

### Build for Android

#### Debug APK

```powershell
flutter build apk --debug
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

#### Release APK

```powershell
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

#### App Bundle for Google Play

```powershell
flutter build appbundle
```

The bundle will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

### Build for iOS (macOS only)

#### Build for Testing

```powershell
flutter build ios --debug
```

#### Build for App Store

```powershell
flutter build ios --release
```

Then open the Xcode project:
```powershell
open ios/Runner.xcworkspace
```

From Xcode, you can archive and upload to the App Store.

### Build for Web

```powershell
flutter build web
```

The web files will be located at:
```
build/web/
```

### Build for Windows

```powershell
flutter build windows
```

The executable will be located at:
```
build/windows/runner/Release/
```

### Build for macOS

```powershell
flutter build macos
```

The app will be located at:
```
build/macos/Build/Products/Release/
```

### Build for Linux

```powershell
flutter build linux
```

The executable will be located at:
```
build/linux/release/bundle/
```

## Testing

### Run All Tests

```powershell
flutter test
```

### Run Specific Test File

```powershell
flutter test test/widget_test.dart
```

### Run Tests with Coverage

```powershell
flutter test --coverage
```

Coverage report will be generated at:
```
coverage/lcov.info
```

## Flutter Commands Reference

### Project Management

```powershell
flutter create flexhero           # Create new project
flutter pub add package_name      # Add dependency
flutter pub remove package_name   # Remove dependency
flutter pub outdated              # Check for outdated packages
flutter pub upgrade               # Upgrade all packages
```

### Development Tools

```powershell
flutter analyze                   # Static analysis
flutter clean                     # Clean build outputs
flutter format lib/               # Format code
flutter doctor --verbose          # Check environment in detail
```

### Asset Management

```powershell
flutter pub run flutter_launcher_icons:main   # Update launcher icons (requires package)
flutter pub run flutter_native_splash:create  # Generate splash screens (requires package)
```

### Code Generation

If your project uses code generation tools:

```powershell
flutter pub run build_runner build   # One-time build
flutter pub run build_runner watch   # Continuous generation on changes
```

## Application-specific Commands

### Development Mode with Hot Reload

```powershell
flutter run --debug
```

### Performance Profiling

```powershell
flutter run --profile
```

### Release Mode Testing

```powershell
flutter run --release
```

## Deployment

### Android Deployment

1. Create a keystore (if you haven't already):
```powershell
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Configure `android/key.properties` with your keystore details

3. Build the release APK or App Bundle (see Building the App section)

4. Upload to Google Play Console

### iOS Deployment (macOS only)

1. Update version in `pubspec.yaml`

2. Build the release IPA (see Building the App section)

3. Use Xcode to archive and upload to App Store Connect

### Web Deployment

1. Build the web version (see Building the App section)

2. Deploy the `build/web/` directory to your web hosting service

For Firebase Hosting:
```powershell
firebase init hosting
firebase deploy --only hosting
```

## Troubleshooting

### Common Issues and Solutions

#### Dependency Conflicts

```powershell
flutter pub cache repair
flutter clean
flutter pub get
```

#### Build Failures

```powershell
flutter clean
flutter pub get
flutter run
```

#### Device Connection Issues

```powershell
flutter devices
flutter doctor -v
```

#### Performance Issues

- Check for widget rebuilds with Flutter DevTools
- Run in profile mode to identify performance bottlenecks

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package Documentation](https://pub.dev/packages/provider)
- [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview/) (if using Firebase)

## Project-specific Notes

- The app requires SharedPreferences for local storage, so first-run initialization might take a moment
- For development, mock data is available in the `ExerciseDatabase` class
- When deploying to the App Store or Google Play, ensure the app's privacy policy is updated
- For web deployment, CORS issues might arise with certain APIs
