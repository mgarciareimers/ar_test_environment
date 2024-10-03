import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// Config.
import 'package:ar_test_env_app/src/config/config.dart';

// Models.
import 'package:ar_test_env_app/src/models/session_model.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/strings.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

class StateBloc {
  final _sessionController = BehaviorSubject<SessionModel>();
  final _appBuildNumberController = BehaviorSubject<String>();
  final _routeNameController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<SessionModel> get sessionStream => _sessionController.stream;
  Stream<String> get appBuildNumberStream => _appBuildNumberController.stream;
  Stream<String> get routeNameStream => _routeNameController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(SessionModel) get changeSession => _sessionController.sink.add;
  Function(String) get changeAppBuildNumber => _appBuildNumberController.sink.add;
  Function(String) get changeRouteName => _routeNameController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  SessionModel get session => _sessionController.value;
  String get appBuildNumber => _appBuildNumberController.value;
  String get routeName => _routeNameController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  dispose() {
    _sessionController.close();
    _routeNameController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeSession(Preferences().session);
    changeRouteName(Strings.emptyString);
    changeLoadingText(Strings.emptyString);
  }

  // Update session.
  void updateSession(SessionModel session) {
    changeSession(session);
    Preferences().session = session;
  }

  // Update session language.
  void updateSessionLanguage(Locale locale, String languageCode) {
    session.languageCode = languageCode;

    Preferences().session = session;
    AppLocalizations(locale).reload();

    changeSession(session);
  }
}