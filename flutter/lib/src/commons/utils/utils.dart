import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Bloc.
import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/progress_bar.dart';
import 'package:ar_test_env_app/src/widgets/generic/text_lato.dart';

class Utils {
  // Method that shows an alert dialog.
  static void showAlertDialog(BuildContext context, String? title, String? content, String? positiveName, String? negativeName, dynamic positiveAction, dynamic negativeAction) {
    if (Platform.isIOS) {
      showCupertinoAlertDialog(context, title, content, positiveName, negativeName, positiveAction, negativeAction);
    } else {
      showMaterialAlertDialog(context, title, content, positiveName, negativeName, positiveAction, negativeAction);
    }
  }

  // Method that shows the material alert dialog.
  static void showMaterialAlertDialog(BuildContext context, String? title, String? content, String? positiveName, String? negativeName, dynamic positiveAction, dynamic negativeAction) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              title: TextLato(
                text: title!,
                color: Colors.black,
                fontSize: Sizes.font17,
                fontWeight: FontWeight.w600,
              ),
              content: SizedBox(
                width: Utils.screenIsPhone(context) ? double.infinity : Sizes.maxWidthScreenPhone - 4 * Sizes.margin20,
                child: TextLato(
                  text: content!,
                  fontSize: Sizes.font15
                ),
              ),
              actions: <Widget>[
                negativeAction == null ? Container() : TextButton(
                  child: TextLato(
                    text: negativeName!,
                    color: Colors.red,
                    fontSize: Sizes.font18,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () => negativeAction(context),
                ),
                TextButton(
                  child: TextLato(
                    text: positiveName!,
                    color: Colors.black,
                    fontSize: Sizes.font18,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () => positiveAction(context),
                ),
              ]
            ),
          );
        }
    );
  }

  // Method that shows the cupertino alert dialog.
  static void showCupertinoAlertDialog(BuildContext context, String? title, String? content, String? positiveName, String? negativeName, dynamic positiveAction, dynamic negativeAction) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: TextLato(
              text: title!,
              fontSize: Sizes.font15
            ),
            content: SizedBox(
              width: Utils.screenIsPhone(context) ? double.infinity : Sizes.maxWidthScreenPhone - 4 * Sizes.margin20,
              child: TextLato(
                text: content!,
                fontSize: Sizes.font14
              ),
            ),
            actions: negativeAction == null ?
              <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: TextLato(
                    text: positiveName!,
                    color: Colors.black,
                    fontSize: Sizes.font16
                  ),
                  onPressed: () => positiveAction(context),
                ),
              ]
                :
              <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: TextLato(
                    text: positiveName!,
                    color: Colors.black,
                    fontSize: Sizes.font16
                  ),
                  onPressed: () => positiveAction(context),
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: TextLato(
                    text: negativeName!,
                    color: Colors.red,
                    fontSize: Sizes.font16
                  ),
                  onPressed: () => negativeAction(context),
                ),
              ],
            )
        );
      },
    );
  }

  // Method that checks if the screen is phone.
  static bool screenIsPhone(BuildContext context) {
    return MediaQuery.of(context).size.width <= Sizes.maxWidthScreenPhone;
  }

  // Method that shows the progressbar alert dialog.
  static void showProgressBarAlertDialog(BuildContext context, Stream stream, { Color color = Colors.black }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: ProgressBar(stream: stream, color: color)
        );
      },
    );
  }

  // Method that checks if the devices is connected to internet.
  static Future<bool> deviceIsConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi);
  }

  // Method that loads an url.
  static void loadUrl(String url, { LaunchMode mode = LaunchMode.platformDefault }) async {
    await launchUrl(
      Uri.parse(url),
      mode: mode,
    );
  }

  // Method that gets the bytes from an asset.
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Method that gets the bytes from an image in bytes.
  static Future<Uint8List> getBytesFromImageBytes(List<int> bytes, int width) async {
    ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Method used to navigate with push.
  static Future<dynamic> navigatorPush({ required BuildContext context, required String newRouteName, required String originalRouteName, dynamic arguments }) {
    return Navigator.pushNamed(context, newRouteName, arguments: arguments)
      .then((dynamic value) {
        if (!context.mounted) {
          return;
        }

        StateBloc stateBloc = BlocProvider.stateBloc(context);
        stateBloc.changeRouteName(originalRouteName);

        return value;
      });
  }

  // Method used to navigate with push.
  static Future<dynamic> navigatorPushAndRemoveUntil({ required BuildContext context, required String newRouteName, dynamic arguments }) {
    return Navigator.pushNamedAndRemoveUntil(context, newRouteName, arguments: arguments, (Route<dynamic> route) => false);
  }
}