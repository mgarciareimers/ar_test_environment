import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

// Pages.
import 'package:ar_test_env_app/src/pages/flutter_plugin_page.dart';
import 'package:ar_test_env_app/src/pages/home_page.dart';
import 'package:ar_test_env_app/src/pages/native_plugin_page.dart';
import 'package:ar_test_env_app/src/pages/splash_page.dart';
import 'package:ar_test_env_app/src/pages/test_cylinder_page.dart';

class Routes {
  static const String flutterPlugin = 'flutter_plugin';
  static const String home = 'home';
  static const String nativePlugin = 'native_plugin';
  static const String splash = 'splash';
  static const String testCylinder = 'test_cylinder';

  // Method that defines the routes for the router.
  static void defineRoutes(FluroRouter router) {
    router.define(flutterPlugin, handler: getRouterHandler(flutterPlugin), transitionType: TransitionType.none);
    router.define(home, handler: getRouterHandler(home), transitionType: TransitionType.none);
    router.define(nativePlugin, handler: getRouterHandler(nativePlugin), transitionType: TransitionType.none);
    router.define(splash, handler: getRouterHandler(splash), transitionType: TransitionType.none);
    router.define(testCylinder, handler: getRouterHandler(testCylinder), transitionType: TransitionType.none);

    // Not found.
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) => const SplashPage(),
    );
  }

  // Method that gets the handler of the router.
  static Handler? getRouterHandler(String routeName) {
    return Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
      switch (routeName) {
        case flutterPlugin: return const FlutterPluginPage();
        case home: return const HomePage();
        case nativePlugin: return const NativePluginPage();
        case splash: return const SplashPage();
        case testCylinder: return const TestCylinderPage();
        default: return const SplashPage();
      }
    });
  }
}