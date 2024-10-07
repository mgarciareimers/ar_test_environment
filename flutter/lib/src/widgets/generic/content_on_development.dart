import 'package:flutter/material.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/text_lato.dart';

class ContentOnDevelopment extends StatelessWidget {
  const ContentOnDevelopment({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.margin20),
        child: TextLato(
          text: AppLocalizations.of(context)!.translate('functionality_on_development'),
          fontSize: Sizes.font16,
          fontStyle: FontStyle.italic,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
