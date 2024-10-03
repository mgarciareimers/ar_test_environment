import 'dart:convert';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/strings.dart';
import 'package:ar_test_env_app/src/commons/constants/fields.dart';

SessionModel sessionModelFromJson(String str) => SessionModel.fromJson(json.decode(str));

String sessionModelToJson(SessionModel data) => json.encode(data.toJson());

class SessionModel {
  String languageCode;

  SessionModel({
    this.languageCode = Strings.emptyString,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    languageCode: json[Fields.languageCode] ?? Strings.emptyString,
  );

  Map<String, dynamic> toJson() => {
    Fields.languageCode: languageCode,
  };
}