import 'package:flutter/material.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

class ContentCustom extends StatelessWidget {
  final Widget child;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  const ContentCustom({
    required this.child,
    this.leftPadding = Sizes.margin20,
    this.rightPadding = Sizes.margin20,
    this.topPadding = Sizes.margin20,
    this.bottomPadding = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: child,
    );
  }
}
