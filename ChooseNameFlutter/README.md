# ChooseName Flutter

This is the separate Flutter implementation workspace for the existing native iOS `ChooseName` app.

## Current SDK

- Flutter: `3.44.2`
- Dart: `3.12.2`
- Android SDK: `36.0.0`
- JDK: OpenJDK `17.0.19`
- Package name: `choose_name`
- Organization: `com.memedko`

## Validation

The generated scaffold currently passes:

```sh
flutter analyze
flutter test
flutter build apk --debug
```

`flutter doctor` reports Android as ready:

- Android SDK path: `/Users/memedko/Library/Android/sdk`
- Platform/build tools: Android `36`
- Java: `/usr/local/opt/openjdk@17/bin/java`
- Android licenses: accepted

Remaining iOS setup is intentionally left for the other Mac:

- Xcode installation is incomplete/not selected on this machine.
- CocoaPods is installed through Homebrew but the active `pod` command is still the older shadowing version.

The migration plan lives in [docs/MIGRATION_PLAN.md](docs/MIGRATION_PLAN.md).
