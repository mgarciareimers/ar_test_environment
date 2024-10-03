import 'package:flutter/material.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/utils.dart';

class ProgressBar extends StatelessWidget {
  final Stream? stream;
  final Color color;

  const ProgressBar({
    this.stream,
    this.color = Colors.black,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(Sizes.margin16 * 2),
              padding: const EdgeInsets.all(Sizes.margin24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.borderRadius10),
              ),
              width: Utils.screenIsPhone(context) ? double.infinity : Sizes.maxWidthScreenPhone - 2 * Sizes.margin20,
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color)),
                  const SizedBox(width: Sizes.margin24),
                  Expanded(child: Text(snapshot.data, style: const TextStyle(fontSize: Sizes.font14, color: Colors.black, fontWeight: FontWeight.normal))),
                ],
              )
            ),
          ),
        );
      },
    );
  }
}