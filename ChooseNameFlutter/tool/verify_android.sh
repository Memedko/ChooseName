#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

GOOGLE_SERVICES="android/app/google-services.json"
RUN_RELEASE="${RUN_RELEASE:-0}"
RUN_INTEGRATION="${RUN_INTEGRATION:-0}"
ANDROID_DEVICE_ID="${ANDROID_DEVICE_ID:-}"

echo "== ChooseName Android verification =="

if [[ -f "$GOOGLE_SERVICES" ]]; then
  echo "Firebase config: found $GOOGLE_SERVICES"
else
  echo "Firebase config: missing $GOOGLE_SERVICES"
  echo "Live Firebase and integration verification will be skipped unless config is added."
fi

echo
echo "== flutter analyze =="
flutter analyze

echo
echo "== flutter test =="
flutter test

echo
echo "== flutter build apk --debug =="
flutter build apk --debug

if [[ "$RUN_RELEASE" == "1" ]]; then
  echo
  echo "== flutter build apk --release =="
  flutter build apk --release

  echo
  echo "== flutter build appbundle --release =="
  flutter build appbundle --release
else
  echo
  echo "Skipping release builds. Set RUN_RELEASE=1 to include release APK and AAB."
fi

if [[ "$RUN_INTEGRATION" == "1" ]]; then
  if [[ ! -f "$GOOGLE_SERVICES" ]]; then
    echo "Cannot run integration: missing $GOOGLE_SERVICES." >&2
    exit 1
  fi

  if [[ -z "$ANDROID_DEVICE_ID" ]]; then
    echo "Cannot run integration: set ANDROID_DEVICE_ID to a connected Android device/emulator id." >&2
    flutter devices
    exit 1
  fi

  echo
  echo "== flutter drive integration smoke =="
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/app_smoke_test.dart \
    -d "$ANDROID_DEVICE_ID"
else
  echo
  echo "Skipping integration smoke. Set RUN_INTEGRATION=1 and ANDROID_DEVICE_ID=<id> to enable."
fi

echo
echo "Android verification complete."
