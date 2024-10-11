import 'package:flutter/material.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/content_custom.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late UnityWidgetController unityWidgetController;

  @override
  void dispose() {
    try {
      unityWidgetController.dispose();
    } catch(e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: AppLocalizations.of(context)!.translate('test'),
        onBackButtonClicked: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      body: ContentCustom(
        leftPadding: 0,
        rightPadding: 0,
        topPadding: 0,
        bottomPadding: 0,
        child: _createContent()
      ),
    );
  }

  // Method that creates the content.
  Widget _createContent() {
    return UnityWidget(
      onUnityCreated: _onUnityCreated
    );
  }

  // Method that is called when the unity widget has been created.
  void _onUnityCreated(UnityWidgetController controller) {
    unityWidgetController = controller;
  }
}

