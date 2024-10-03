import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Models.
import 'package:ar_test_env_app/src/models/session_model.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/fields.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  SharedPreferences? _sharedPreferences;

  initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Session.
  SessionModel get session { return _sharedPreferences!.get(Fields.session) == null ? SessionModel() : SessionModel.fromJson(jsonDecode(_sharedPreferences!.getString(Fields.session)!)); }
  set session (SessionModel session) { _sharedPreferences!.setString(Fields.session, jsonEncode(session.toJson())); }

  // Check if shared preferences is initialized.
  bool sharedPreferencesIsInitialized() => _sharedPreferences != null;

  // Reset.
  void reset() {
    session = SessionModel();
  }
}