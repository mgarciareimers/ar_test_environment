import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Bloc.
import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';

// Config.
import 'package:ar_test_env_app/src/config/config.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/strings.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences.
  final preferences = Preferences();
  await preferences.initPreferences();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late FluroRouter router;

  @override
  void initState() {
    router = FluroRouter();
    Routes.defineRoutes(router);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: Strings.appName,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: Colors.black,
          fontFamily: 'Lato',
        ),
        onGenerateInitialRoutes: (String initialRoute) => [ router.generator(RouteSettings(name: initialRoute))! ],
        onGenerateRoute: router.generator,

        // Supported local languages.
        supportedLocales: [
          AppLocalizations.getLocaleByLanguageCode(AppLocalizations.englishCode),
        ],

        // Make sure that the localization data for the proper language is loaded.
        localizationsDelegates: [
          AppLocalizations.delegate, // A class which loads the translations from JSON files.
          GlobalMaterialLocalizations.delegate, // Built-in localization of basic text for Material widgets.
          GlobalCupertinoLocalizations.delegate, // Built-in localization of basic text for Cupertino widgets.
          GlobalWidgetsLocalizations.delegate, // Built-in localization for text direction LTR/RTL.
        ],

        // Returns a locale which will be used by the app.
        localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          return supportedLocales.first;
        },
      ),
    );
  }
}