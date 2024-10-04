import 'dart:io';
import 'package:ar_test_env_app/src/widgets/generic/content_on_development.dart';
import 'package:flutter/material.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/content_custom.dart';
import 'package:ar_test_env_app/src/widgets/native_plugin/native_ar_core.dart';

class NativePluginPage extends StatefulWidget {
  const NativePluginPage({super.key});

  @override
  State<NativePluginPage> createState() => _NativePluginPageState();
}

class _NativePluginPageState extends State<NativePluginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: AppLocalizations.of(context)!.translate('native_plugin'),
        onBackButtonClicked: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      body: ContentCustom(
        leftPadding: 0,
        rightPadding: 0,
        bottomPadding: 0,
        topPadding: 0,
        child: _createContent()
      ),
    );
  }

  // Method that creates the content.
  Widget _createContent() {
    switch (Platform.operatingSystem) {
      case 'android': return const NativeArCore();
      case 'ios': return const ContentOnDevelopment();
      default: return const ContentOnDevelopment();
    }
  }
}
