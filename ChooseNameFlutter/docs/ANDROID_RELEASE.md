# Android Release Setup

The debug build works without release credentials. For Play Store release builds,
create `ChooseNameFlutter/android/key.properties` from
`ChooseNameFlutter/android/key.properties.example` and point `storeFile` to the
upload keystore.

`android/key.properties`, `*.jks`, and `*.keystore` are ignored by git.

Build commands:

```bash
flutter build apk --release
flutter build appbundle --release
```

Or run the migration verification helper with release builds enabled:

```bash
RUN_RELEASE=1 tool/verify_android.sh
```

Firebase Android config is separate: place `google-services.json` at
`ChooseNameFlutter/android/app/google-services.json` before verifying live
Firebase services or creating a store build.

For the full Android verification checklist, see `docs/ANDROID_VERIFICATION.md`.
