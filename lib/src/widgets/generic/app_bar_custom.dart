import 'package:flutter/material.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

// Text.
import 'package:ar_test_env_app/src/widgets/generic/text_lato.dart';

class AppBarCustom extends StatelessWidget implements PreferredSize {
  @override
  final Size preferredSize;

  final String title;
  final void Function()? onBackButtonClicked;

  const AppBarCustom({
    required this.title,
    this.onBackButtonClicked,
    super.key
  }) : preferredSize = const Size.fromHeight(Sizes.appBarHeight);

  @override
  Widget get child => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      leading: Container(),
      titleSpacing: 0,
      title: Stack(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                onBackButtonClicked == null ? Container() : _createBackButton(),
                SizedBox(width: onBackButtonClicked == null ? Sizes.margin20 : Sizes.margin12),

                Flexible(
                  child: TextLato(
                    text: title,
                    fontSize: Sizes.font17,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
      toolbarHeight: double.maxFinite,
      elevation: 0,
      actions: [
        Builder(builder: (BuildContext context) => Container())
      ],
    );
  }

  // Method that creates the back button.
  Widget _createBackButton() {
    return InkWell(
      onTap: onBackButtonClicked,
      child: Container(
        padding: const EdgeInsets.only(left: Sizes.margin16),
        color: Colors.white,
        height: Sizes.appBarHeight,
        child: const Icon(
          Icons.keyboard_arrow_left,
          size: Sizes.font24,
          color: Colors.white,
        ),
      ),
    );
  }
}