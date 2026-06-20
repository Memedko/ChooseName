# Android Verification

Use `tool/verify_android.sh` as the repeatable Android migration gate.

## Local verification without Firebase

This checks static analysis, unit/widget tests, and a debug Android build. It is
expected to pass before `google-services.json` exists:

```bash
tool/verify_android.sh
```

## Firebase and device smoke test

1. Place the Firebase Android config at:

   ```text
   android/app/google-services.json
   ```

2. Connect a physical Android device or start a stable emulator, then find the
   device id:

   ```bash
   flutter devices
   ```

3. Run the app smoke test:

   ```bash
   RUN_INTEGRATION=1 ANDROID_DEVICE_ID=<device-id> tool/verify_android.sh
   ```

This runs the same local checks first, then executes:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_smoke_test.dart -d <device-id>
```

## Release build verification

To include release APK and Play Store AAB builds:

```bash
RUN_RELEASE=1 tool/verify_android.sh
```

For a final store build, also create `android/key.properties` from
`android/key.properties.example` and point it to the upload keystore.
