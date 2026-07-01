import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('uk')];

  /// Application title.
  ///
  /// In uk, this message translates to:
  /// **'Ім’я малюка'**
  String get appTitle;

  /// No description provided for @mainEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Більше немає варіантів імен'**
  String get mainEmpty;

  /// No description provided for @searchEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Такого імені не знайдено'**
  String get searchEmpty;

  /// No description provided for @favoritesTitle.
  ///
  /// In uk, this message translates to:
  /// **'Вподобане ім’я'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Ви ще не вибрали жодного імені'**
  String get favoritesEmpty;

  /// No description provided for @details.
  ///
  /// In uk, this message translates to:
  /// **'Деталі'**
  String get details;

  /// No description provided for @detailClose.
  ///
  /// In uk, this message translates to:
  /// **'Закрити'**
  String get detailClose;

  /// No description provided for @listAgain.
  ///
  /// In uk, this message translates to:
  /// **'Переглянути список імен ще раз'**
  String get listAgain;

  /// No description provided for @like.
  ///
  /// In uk, this message translates to:
  /// **'Подобається'**
  String get like;

  /// No description provided for @dislike.
  ///
  /// In uk, this message translates to:
  /// **'Не подобається'**
  String get dislike;

  /// No description provided for @likedThisName.
  ///
  /// In uk, this message translates to:
  /// **'Ви вподобали це імʼя'**
  String get likedThisName;

  /// No description provided for @dislikedThisName.
  ///
  /// In uk, this message translates to:
  /// **'Ви не вподобали це імʼя'**
  String get dislikedThisName;

  /// No description provided for @ok.
  ///
  /// In uk, this message translates to:
  /// **'Добре'**
  String get ok;

  /// No description provided for @add.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get add;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In uk, this message translates to:
  /// **'Збережено'**
  String get saved;

  /// No description provided for @copied.
  ///
  /// In uk, this message translates to:
  /// **'Скопійовано'**
  String get copied;

  /// No description provided for @searchHint.
  ///
  /// In uk, this message translates to:
  /// **'Пошук імен'**
  String get searchHint;

  /// No description provided for @addFavoriteHint.
  ///
  /// In uk, this message translates to:
  /// **'Додати імʼя'**
  String get addFavoriteHint;

  /// No description provided for @nameAlreadyLiked.
  ///
  /// In uk, this message translates to:
  /// **'Це імʼя вже є у вподобаних.'**
  String get nameAlreadyLiked;

  /// No description provided for @nameAlreadyDisliked.
  ///
  /// In uk, this message translates to:
  /// **'Це імʼя вже було відхилено.'**
  String get nameAlreadyDisliked;

  /// No description provided for @copyFavorites.
  ///
  /// In uk, this message translates to:
  /// **'Скопіювати список'**
  String get copyFavorites;

  /// No description provided for @copyNameId.
  ///
  /// In uk, this message translates to:
  /// **'Скопіювати ID імені'**
  String get copyNameId;

  /// No description provided for @detailFullName.
  ///
  /// In uk, this message translates to:
  /// **'ПІБ'**
  String get detailFullName;

  /// No description provided for @detailInitials.
  ///
  /// In uk, this message translates to:
  /// **'Ініціали'**
  String get detailInitials;

  /// No description provided for @detailVersions.
  ///
  /// In uk, this message translates to:
  /// **'Варіанти'**
  String get detailVersions;

  /// No description provided for @detailDescription.
  ///
  /// In uk, this message translates to:
  /// **'Значення'**
  String get detailDescription;

  /// No description provided for @detailTransliteration.
  ///
  /// In uk, this message translates to:
  /// **'Транслітерація'**
  String get detailTransliteration;

  /// No description provided for @detailEnglishVersion.
  ///
  /// In uk, this message translates to:
  /// **'Англійська версія'**
  String get detailEnglishVersion;

  /// No description provided for @detailLanguages.
  ///
  /// In uk, this message translates to:
  /// **'Варіанти імені мовами світу'**
  String get detailLanguages;

  /// No description provided for @detailNameDays.
  ///
  /// In uk, this message translates to:
  /// **'Іменини'**
  String get detailNameDays;

  /// No description provided for @detailFamousPeople.
  ///
  /// In uk, this message translates to:
  /// **'Видатні люди'**
  String get detailFamousPeople;

  /// No description provided for @detailCharacters.
  ///
  /// In uk, this message translates to:
  /// **'Персонажі'**
  String get detailCharacters;

  /// No description provided for @detailMedia.
  ///
  /// In uk, this message translates to:
  /// **'Медіа'**
  String get detailMedia;

  /// No description provided for @detailChildren.
  ///
  /// In uk, this message translates to:
  /// **'Діти відомих людей'**
  String get detailChildren;

  /// No description provided for @detailRelatedNames.
  ///
  /// In uk, this message translates to:
  /// **'Споріднені імена'**
  String get detailRelatedNames;

  /// No description provided for @profileTitle.
  ///
  /// In uk, this message translates to:
  /// **'Імʼя дитини'**
  String get profileTitle;

  /// No description provided for @lastName.
  ///
  /// In uk, this message translates to:
  /// **'Прізвище'**
  String get lastName;

  /// No description provided for @fatherName.
  ///
  /// In uk, this message translates to:
  /// **'По батькові'**
  String get fatherName;

  /// No description provided for @settingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settingsTitle;

  /// No description provided for @clearCache.
  ///
  /// In uk, this message translates to:
  /// **'Очистити дані'**
  String get clearCache;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Очистити всі збережені дані?'**
  String get clearCacheConfirm;

  /// No description provided for @clear.
  ///
  /// In uk, this message translates to:
  /// **'Очистити'**
  String get clear;

  /// No description provided for @cleared.
  ///
  /// In uk, this message translates to:
  /// **'Очищено'**
  String get cleared;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get remove;

  /// No description provided for @removeFavoriteTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити імʼя'**
  String get removeFavoriteTitle;

  /// No description provided for @removeFavoriteConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Видалити це імʼя з вподобаних?'**
  String get removeFavoriteConfirm;

  /// No description provided for @privacyPolicy.
  ///
  /// In uk, this message translates to:
  /// **'Політика приватності'**
  String get privacyPolicy;

  /// No description provided for @reviewApp.
  ///
  /// In uk, this message translates to:
  /// **'Оцінити додаток'**
  String get reviewApp;

  /// No description provided for @maleNames.
  ///
  /// In uk, this message translates to:
  /// **'Чоловічі'**
  String get maleNames;

  /// No description provided for @femaleNames.
  ///
  /// In uk, this message translates to:
  /// **'Жіночі'**
  String get femaleNames;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
