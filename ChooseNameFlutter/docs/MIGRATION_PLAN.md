# ChooseName iOS to Flutter Migration Plan

## Implementation Status

Current Flutter project location: `ChooseNameFlutter/`.

Completed locally:

- Flutter project scaffolded for Android and iOS, with Android SDK/JDK setup validated on this machine.
- Supported Android x86_64 emulator images/AVDs (`Pixel_2_API_30_x64`, `ChooseName_API_35_x64`) are installed for device smoke testing.
- Layered Flutter architecture created with `data`, `domain`, and `ui` folders.
- Firebase bootstrap added with anonymous-auth attempt and graceful fallback while config is missing.
- Crashlytics error handlers and Analytics route/action logging are wired conditionally when Firebase initializes.
- Android Gradle is ready for Firebase: local `google-services.json` is installed at `ChooseNameFlutter/android/app/google-services.json`, ignored by git, and the Google Services plugin is applied only when that file exists.
- Android main manifest has the app label, launcher icon, and release/runtime internet permission configured.
- Flutter package/build metadata is aligned to the native iOS release lineage (`1.6.0+17`), and Android/iPhone orientation is locked to portrait to match the source app's phone UX.
- Android release signing scaffolding is configured through ignored `android/key.properties`, with `android/key.properties.example` and `docs/ANDROID_RELEASE.md`; local release APK and AAB builds validate with debug-signing fallback until real upload keystore details are supplied.
- Android verification is scripted in `tool/verify_android.sh`, with the repeatable Firebase/device/release checklist captured in `docs/ANDROID_VERIFICATION.md`.
- iOS Runner display/bundle name metadata is set to the app name; `GoogleService-Info.plist` is installed into the Runner target locally and the iOS bundle id is aligned to `com.itworksinua.BabysName2`; full iOS build validation remains deferred to the other Mac.
- Firestore service maps the existing `maleNames`, `femaleNames`, `customNames`, and `favoriteNames` collections, and live name snapshots hydrate the Drift cache when Firebase is configured.
- Drift local cache replaces Core Data, preserves `select` semantics (`0` neutral, `1` liked, `-1` disliked), and stores the Android database in the app-private package `databases` directory.
- Shared preferences preserve selected gender, surname/father-name inputs, and shown-card count; settings clear-data resets all of them with the local cache.
- Main screen has gender switching, local search, real horizontal card swipes, like/dislike buttons, generated full-name card lines, liked/disliked card status, and "list again".
- Main screen preserves the native `shownCardsCount` tracking but does not enforce the legacy 12-card monetization gate, matching the current iOS app where payment and ads are not connected.
- Favorites screen has gender switching, add/search custom name flow, duplicate cached/custom liked/disliked warnings, confirmed removal, single chosen favorite, native-style Ukrainian share text, and Android native share-sheet support with clipboard fallback.
- Profile screen persists surname/father-name values per gender and enforces the native 50-character field limit.
- Detail screen builds the native section set: name, full name, initials, description, versions, transliteration/English, languages, days, celebrities, characters, songs, children, and related names.
- Detail celebrity/character sections render remote image rows with description, link affordance, and initials fallback without adding a native image plugin.
- Detail screen supports copy-name-ID and local-cache related-name drilldown.
- Montserrat Alternates fonts, Lottie JSON assets, and native `.xcassets` raster images are copied into Flutter assets.
- Android launcher mipmap icons are regenerated from the original iOS app artwork.
- Localization is configured as Ukrainian-only with generated Flutter ARB output.
- Settings screen includes clear-data, privacy policy, and platform-aware review links: Android opens the Play Store package URL, while iOS keeps the native App Store URL.
- Validation is green through `RUN_RELEASE=1 tool/verify_android.sh`: `flutter analyze`, `flutter test` (23 tests), `flutter build apk --debug`, `flutter build apk --release`, and `flutter build appbundle --release`.
- The Android `applicationId`, Play Store link, and Android private database path are aligned to the Firebase Android config package `com.itworksinua.BabysName2`; the Kotlin namespace remains `com.memedko.choose_name`.
- The rebuilt release APK metadata verifies `applicationId` `com.itworksinua.BabysName2`, `versionCode` `17`, and `versionName` `1.6.0`.
- `integration_test/app_smoke_test.dart` and `test_driver/integration_test.dart` are in place for device-based smoke testing.

Still pending or intentionally deferred:

- Verify live Firestore/Auth/Crashlytics on an Android device with the installed Android Firebase config.
- Run the integration smoke test on a stable Android device/emulator with `RUN_INTEGRATION=1 ANDROID_DEVICE_ID=<device-id> tool/verify_android.sh`. Supported x86_64 AVDs now exist, and direct `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_smoke_test.dart -d emulator-5554` reached the Dart test body on the lean Android 35 emulator, but this Mac's headless emulator/ADB transport still wedged before completion.
- iOS Firebase/Xcode validation with the installed `GoogleService-Info.plist` is deferred to the other Mac.
- Payment and ads are intentionally inactive to mimic the current iOS app; the old StoreKit/ad remnants are not connected there either, and Flutter no longer includes `in_app_purchase` or an active billing path.
- Android upload keystore credentials, final package metadata, and Play Store listing assets still need final product details.

## Current iOS App Inventory

The existing app is a UIKit iOS project using storyboards/xibs. Its core experience is a baby-name picker with swipe cards, gender switching, search, detail pages, favorites, custom favorites, share text, and saved surname/father-name inputs. The app currently launches straight into the main picker screen; the intro/initial-form launch path exists but is commented out in `SceneDelegate`.

Main dependencies and platform services:

- Firebase: Core, Analytics, Auth, Firestore, Crashlytics.
- Core Data: local cache for names and related records.
- Firebase Auth: anonymous sign-in on launch when no current user exists.
- StoreKit: purchase/restore helper exists, with a 12-card viewing limit constant in code, but no active product IDs were found.
- Koloda: swipe-card deck.
- SDWebImage: remote image loading.
- Lottie: JSON animations.
- SkyFloatingLabelTextField: floating label text inputs.
- Google Mobile Ads metadata exists in `Info.plist`, and ad-deactivation storyboards/controllers exist, but ads are not wired through `Podfile` and ad display code appears commented out.

Important source areas:

- `ChooseName/Controllers/CNMainViewController.swift`: main swipe screen, gender switch, search, like/dislike.
- `ChooseName/Controllers/CNCardViewController.swift`: detail modal with sections.
- `ChooseName/Controllers/CNFavoritesViewController.swift`: favorites list, add/search custom names, delete/share.
- `ChooseName/Controllers/CNInitialViewController.swift`: initial surname/father-name input.
- `ChooseName/Controllers/CNPipMaleViewController.swift` and `CNPipFemaleViewController.swift`: edit surname/father-name popup.
- `ChooseName/Controllers/CNSettingsViewController.swift` and `CNMenuViewController.swift`: settings/menu/privacy/review flows, currently not fully reachable from the active main screen.
- `ChooseName/DataSource/DataSource.swift`: local cache, name state, search, like/dislike, favorites.
- `ChooseName/DataSource/HttpService.swift`: Firestore reads/listeners and telemetry writes.
- `ChooseName/Models/Models.swift`: app data models.
- `ChooseName/DataSource/babysname.xcdatamodeld/.../contents`: Core Data schema.
- `ChooseName/Assets.xcassets`: icons, app art, color tokens.
- `ChooseName/Resources`: fonts, Lottie JSON, Firebase config, localization strings.

## Target Flutter Architecture

This plan is revised after installing and reading the official Flutter/Dart Agent Skills from `flutter/skills` and `dart-lang/skills`.

Installed skills used to shape this plan:

- `flutter-apply-architecture-best-practices`
- `flutter-build-responsive-layout`
- `flutter-fix-layout-issues`
- `flutter-implement-json-serialization`
- `flutter-setup-declarative-routing`
- `flutter-setup-localization`
- `flutter-add-widget-test`
- `flutter-add-integration-test`
- `flutter-add-widget-preview`
- `flutter-use-http-package`
- `dart-add-unit-test`
- `dart-generate-test-mocks`
- `dart-resolve-package-conflicts`
- `dart-run-static-analysis`

Codex should be restarted to auto-discover these newly installed skills in future turns.

Recommended app stack:

- Architecture: Flutter recommended layered architecture with UI, data, and optional domain/use-case layers.
- UI state: MVVM with `ChangeNotifier`/`Listenable` view models. Keep widgets lean and inject repositories into view models.
- Dependency injection: `provider` for app-level dependency wiring, or `get_it` if constructor wiring becomes too noisy.
- Navigation: `go_router`.
- Firebase: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_analytics`, `firebase_crashlytics`.
- Local database: `drift` with `sqlite3_flutter_libs`.
- Preferences: `shared_preferences`.
- Swipe cards: `appinio_swiper` or a custom `PageView`/gesture card deck if exact Koloda behavior is needed.
- Images: `cached_network_image`.
- Lottie: `lottie`.
- Monetization: inactive for now, matching the current iOS runtime.
- Sharing/open links: `share_plus`, `url_launcher`.
- Clipboard: Flutter `Clipboard`.
- Localization: Flutter `gen-l10n` using ARB files.
- Static analysis: `flutter_lints` plus strict analyzer language settings.
- Android release readiness: later add release signing config, package metadata, launcher icon replacement, and Firebase Android config.

Suggested folder layout after `flutter create`:

```text
ChooseNameFlutter/
  lib/
    data/
      models/
        name_api_model.dart
        person_ref_api_model.dart
      repositories/
        name_repository.dart
        purchase_repository.dart
        user_preferences_repository.dart
      services/
        firestore_name_service.dart
        local_name_database.dart
        analytics_service.dart
        purchase_service.dart
    domain/
      models/
        name.dart
        celebrity.dart
        character.dart
        child.dart
        song.dart
      use_cases/
        build_name_detail_sections.dart
        reset_disliked_names.dart
        select_favorite_name.dart
    ui/
      core/
        app.dart
        router.dart
        app_colors.dart
        app_text_styles.dart
        constants.dart
        widgets/
      features/
        names/
          view_models/
            main_swipe_view_model.dart
            name_detail_view_model.dart
          views/
            main_swipe_screen.dart
            name_card.dart
            name_detail_sheet.dart
            search_bar.dart
        favorites/
          view_models/
            favorites_view_model.dart
            add_name_view_model.dart
          views/
            favorites_screen.dart
            add_name_overlay.dart
        profile/
          view_models/
            profile_view_model.dart
          views/
            initial_name_form.dart
            patronymic_editor_sheet.dart
        purchase/
          view_models/
            purchase_view_model.dart
          views/
            purchase_sheet.dart
    l10n/
      app_uk.arb
  assets/
    images/
    lottie/
    fonts/
  integration_test/
  test/
```

## Data Model Mapping

Port these Swift models to Dart first. Keep API/local storage mapping separate from clean domain models:

- API/local models parse Firestore/local DB records using explicit `fromJson` and `toJson` methods.
- Domain models are immutable, UI-safe objects consumed by view models.
- If a payload becomes large enough to jank the UI, move parsing into `compute()`.

Domain models:

- `Name`: `nameID`, `name`, `versions`, `nameDays`, `descriptionName`, `name_en`, `name_ru`, `transliteration`, `celebrities`, `characters`, `songs`, `children`, `select`, `liked`, `sameNames`, `langs`.
- `Celebrity`: `name`, `url`, `imgUrl`, `description`, `sort`.
- `Character`: same shape as `Celebrity`.
- `Song`: `title`, `singer`, `url`, `sort`.
- `Child`: `name`, `parents`, `birthday`, `yearOfDeath`, `sort`.

Local database tables should mirror the Core Data entities:

- `CNNameMale`
- `CNNameFemale`
- `CNCelebrity`
- `CNCharacter`
- `CNSong`
- `CNChild`

Keep the same `select` semantics:

- `0`: unseen/neutral.
- `1`: liked/favorite.
- `-1`: disliked.

Keep the same Firestore collections:

- `maleNames`
- `femaleNames`
- `customNames`
- `favoriteNames`

## Screen-by-Screen Migration

1. App bootstrap
   - Initialize Firebase.
   - If no authenticated Firebase user exists, sign in anonymously, matching `AppDelegate`.
   - Set default gender selection to male.
   - Load shared preferences and local database.
   - Configure Crashlytics and Analytics.
   - Configure `MaterialApp.router` with `go_router`.
   - Configure localization delegates and supported locales.
   - Register repositories, services, and view models with dependency injection.

2. Initial profile screen
   - Rebuild surname and father-name inputs for both genders.
   - Persist values using `shared_preferences`.
   - Keep 50-character limit.
   - Implement as a lean view plus `ProfileViewModel`.
   - Treat this as an optional route at first, because the current iOS launch flow skips it.

3. Main swipe screen
   - Match boy/girl gradient themes.
   - Load cached names first, then Firestore if cache is empty.
   - Add live Firestore listeners to update local cache.
   - Implement swipe right as `select = 1`.
   - Implement swipe left as `select = -1`.
   - Implement search by name prefix or `versions` contains search text.
   - Implement "list again" by resetting all disliked names for the selected gender back to `0`.
   - Use `LayoutBuilder` and width constraints, not device checks, so the screen behaves on phones, tablets, and resizable windows.

4. Name card widget
   - Show name, generated full-name line, selected/disliked status, and details button.
   - Recreate the existing compact card look using ported assets and Montserrat Alternates font.
   - Add stable `ValueKey`s for swipe buttons, detail button, gender toggles, search field, and card root so widget/integration tests can target them.

5. Name detail sheet/screen
   - Build dynamic section list exactly like `CNCardViewController`.
   - Sections: name, full name, initials, description, versions, transliteration/English version, language variants, name days, celebrities, characters, songs/media, children, related names.
   - Add copy-name-ID behavior.
   - Add link opening for celebrity/character/song URLs.
   - Allow related-name drilldown.
   - Put section-building logic in a domain use case so the view stays declarative.

6. Favorites screen
   - Gender switch with same shared selected gender.
   - Show `select == 1` names.
   - Allow one "chosen" favorite via `liked = true`.
   - Add custom name flow.
   - Search local names while typing before adding.
   - Warn if name is already liked/disliked.
   - Remove favorite with confirmation.
   - Share Ukrainian text matching the iOS app.

7. Edit surname/father-name popup
   - One reusable Flutter bottom sheet/dialog for both male and female themes.
   - Save values and notify main/favorites/detail screens through state providers.

8. Settings, menu, review, and privacy
   - Decide whether to restore the side/menu flow that exists in storyboard but is commented out from the main screen.
   - Port settings clear-cache behavior if the menu/settings flow remains in scope.
   - Preserve privacy policy link: `http://babysname.tilda.ws/app-privacy-policy`.
   - Replace `SKStoreReviewController.requestReview()` with the Flutter equivalent only after app IDs/platform package names are finalized.

9. IAP, ads, and card limit
   - Keep payment and ads inactive, matching the current iOS runtime.
   - Preserve `shownCardsCount` as legacy telemetry/state only; do not enforce `shownCardsLimit = 12`.
   - Do not include `in_app_purchase` until product IDs and a real monetization scope are confirmed.
   - Current iOS metadata references AdMob, but active ad code/dependencies are not present.

10. Localization
   - Convert `.strings` files into ARB.
   - Add `flutter_localizations` and `intl`.
   - Enable `flutter: generate: true`.
   - Add `l10n.yaml` using `lib/l10n/app_uk.arb` as the template.
   - Keep Ukrainian as the only active app interface language unless product requirements change.

11. Assets
   - Export `.xcassets` images into `assets/images`.
   - Copy fonts from `ChooseName/Resources/MontserratAlternates-*.ttf`.
   - Copy Lottie files: `childSmiles.json`, `starsAnimation.json`.
   - Convert color assets to Dart constants:
     - Main gradient: `#2C919E` to `#0B1B43`.
     - Boy gradient: `#4E1D8C` to `#320A51`.
     - Boy actions: `#772BD8`, `#5B22B7`.
     - Girl gradient: `#841763` to `#4D0636`.
     - Girl actions: `#D82B7D`, `#C52168`.

## Milestones

1. Scaffold and configuration
   - Flutter SDK installed: `3.44.2`.
   - Generated `ChooseNameFlutter` scaffold with iOS and Android platforms.
   - Android toolchain is ready locally: Android SDK `36.0.0`, OpenJDK `17.0.19`, licenses accepted, debug APK builds.
   - iOS build setup will be completed on another Mac with full Xcode.
   - Add Firebase configs for iOS/Android.
   - Add package dependencies and asset declarations.
   - Add `go_router`, localization config, dependency injection, `analysis_options.yaml`, and app shell.
   - Android release signing scaffold is in place; debug, release APK, and release AAB builds validate locally with fallback signing.

2. Data foundation
   - Port API/local models with explicit JSON serialization.
   - Port immutable domain models.
   - Build Drift local database schema.
   - Implement Firestore repository and cache synchronization.
   - Add unit tests for model parsing and select-state transitions.
   - Run `dart analyze` with strict casts/inference/raw-types.

3. Core experience
   - Build main swipe screen.
   - Build gender themes.
   - Build detail view.
   - Match local search and list-again behavior.
   - Add widget tests for gender switching, search, empty state, swipe actions, and detail opening.

4. Favorites and user data
   - Build favorites screen.
   - Build add-name/search flow.
   - Build profile/edit forms.
   - Build share and clipboard flows.
   - Add widget tests for add-name duplicate/disliked/liked warnings and favorite removal.

5. Monetization/analytics
   - Add anonymous Firebase Auth bootstrap.
   - Wire IAP once product IDs are confirmed.
   - Decide whether ads/ad-deactivation alerts are in scope.
   - Restore analytics events if desired.
   - Enable Crashlytics.

6. Integration tests and visual QA
   - Port all assets and fonts.
   - Compare iOS screenshots with Flutter screens.
   - Test on iPhone SE, standard iPhone, large iPhone, Android compact/large.
   - Test offline startup after cache is populated.
   - Add `integration_test` flows for first launch, swipe-like, swipe-dislike, favorite selection, add custom name, and share entry point.
   - Use constrained layouts on larger screens and verify no text overflow.

## Risks and Open Questions

- Flutter SDK is installed locally, and the generated scaffold passes `flutter analyze` and `flutter test`.
- Android setup is complete on this Mac, and `flutter build apk --debug` succeeds.
- `flutter doctor` still reports incomplete iOS setup on this Mac: Xcode needs full setup/selection. CocoaPods 1.16.2 is installed through Homebrew, but the active `pod` command remains the older shadowing install unless relinked.
- Firebase config is installed locally for Android and iOS Flutter targets; live device/Xcode validation is still required.
- StoreKit product IDs were not found in the inspected code.
- Firebase anonymous auth must be preserved because Firestore rules may depend on it.
- Ukrainian is the only active app interface language; remaining copy polish should be checked with product before release.
- The iOS project includes `GADApplicationIdentifier` and ad-deactivation screens, but Google Mobile Ads is not present in `Podfile` and active ad display code appears commented out; confirm whether ads are still required.
- Settings/menu screens exist in the native storyboard but were not clearly reachable from the active native main screen; the Flutter main screen exposes settings directly.
- Core Data has no explicit relationships; Flutter can model related records by `nameID`, matching current behavior.
- Android upload keystore credentials and Play Store package metadata are still future release tasks.

## Recommended Next Step

Add `ChooseNameFlutter/android/app/google-services.json`, then run the app on an Android device or emulator to verify live Firebase Auth, Firestore hydration, Analytics, Crashlytics, and the integration smoke test. iOS build validation remains intentionally deferred to the other Mac.
