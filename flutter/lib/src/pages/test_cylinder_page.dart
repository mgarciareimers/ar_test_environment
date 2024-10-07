import 'package:flutter/material.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/content_custom.dart';

class TestCylinderPage extends StatefulWidget {
  const TestCylinderPage({
    super.key
  });

  @override
  State<TestCylinderPage> createState() => _TestCylinderPageState();
}

class _TestCylinderPageState extends State<TestCylinderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: AppLocalizations.of(context)!.translate('test_cylinder'),
        onBackButtonClicked: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      body: ContentCustom(
        child: _createContent()
      ),
    );
  }

  // Method that creates the content.
  Widget _createContent() {
    return Container();
  }
}

