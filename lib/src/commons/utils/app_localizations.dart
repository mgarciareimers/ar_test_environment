import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Config.
import 'package:ar_test_env_app/src/config/config.dart';

// Models.
import 'package:ar_test_env_app/src/models/session_model.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/strings.dart';

class AppLocalizations {
  static const String englishCode = 'en';
  static const String spanishCode = 'es';

  static const List<String> languageCodes = [
    englishCode,
    spanishCode,
  ];

  Locale locale;

  AppLocalizations(this.locale);

  // Helper method that keeps the code in the widgets concise.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp.
  static LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, String>? _localizedStrings;
  static Map<String, String>? _localizedCountries;

  void reload() async {
    delegate = _AppLocalizationsDelegate();
    await load();
  }

  Future<bool> load() async {
    SessionModel session = Preferences().session;
    String languageCode = session.languageCode;

    if (languageCode.isEmpty) {
      languageCode = locale.languageCode;

      session.languageCode = languageCode;
      Preferences().session = session;
    }

    String jsonStrings = await rootBundle.loadString('lang/strings/$languageCode.json');
    String jsonCountries = await rootBundle.loadString('lang/countries/$languageCode.json');

    Map<String, dynamic> jsonStringsMap = json.decode(jsonStrings);
    Map<String, dynamic> jsonCountriesMap = json.decode(jsonCountries);

    _localizedStrings = jsonStringsMap.map((key, value) => MapEntry(key, value.toString()));
    _localizedCountries = jsonCountriesMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  // Method that will be called from every widget which needs a localized text.
  String translate(String key) {
    return _localizedStrings![key] ?? Strings.nullString;
  }

  // Method that will be called from every widget which needs a localized country text.
  String translateCountry(String key) {
    return _localizedCountries![key] ?? Strings.nullString;
  }

  // Get locale by language code.
  static Locale getLocaleByLanguageCode(String? languageCode) {
    switch(languageCode) {
      case AppLocalizations.englishCode: return Locale(languageCode!, 'US');
      case AppLocalizations.spanishCode: return Locale(languageCode!, 'ES');
      default: return const Locale(AppLocalizations.englishCode, 'US');
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources.
// In this case, the localized strings will be gotten in an AppLocalizations object.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  // This delegate instance will never change.
  _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      AppLocalizations.englishCode,
      AppLocalizations.spanishCode,
    ].contains(locale.languageCode); // Include all supported language codes.
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}