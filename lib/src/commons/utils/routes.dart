import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Pages.
import 'package:ar_test_env_app/src/pages/home_page.dart';
import 'package:ar_test_env_app/src/pages/splash_page.dart';

class Routes {
  static const String home = 'home';
  static const String splash = 'splash';

  // Method that defines the routes for the router.
  static void defineRoutes(FluroRouter router) {
    router.define(home, handler: getRouterHandler(home), transitionType: TransitionType.none);
    router.define(splash, handler: getRouterHandler(splash), transitionType: TransitionType.none);

    // Not found.
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) => const SplashPage(),
    );
  }

  // Method that gets the handler of the router.
  static Handler? getRouterHandler(String routeName) {
    return Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
      switch (routeName) {
        case home: return const HomePage();
        case splash: return const SplashPage();
        default: return const SplashPage();
      }
    });
  }

  // Method that gets the tab title.
  static String getTabTitle(BuildContext context, String routeName) {
    String title = AppLocalizations.of(context)!.translate('app_name');

    switch (routeName) {
      case home: title = '${ AppLocalizations.of(context)!.translate('home') } - $title'; break;
      default: break;
    }

    return title;
  }
}