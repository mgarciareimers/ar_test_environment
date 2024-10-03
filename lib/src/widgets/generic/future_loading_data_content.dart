import 'package:flutter/material.dart';

// Bloc.
import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/backend.dart';
import 'package:ar_test_env_app/src/commons/constants/fields.dart';
import 'package:ar_test_env_app/src/commons/constants/strings.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/utils/utils.dart';

class FutureLoadingDataContent extends StatefulWidget {
  final bool hasLoaded;
  final String loadingText;
  final Color progressBarColor;
  final bool showCancelButton;

  final Widget Function() createLoadedContent;
  final void Function(String) changeLoadingText;
  final Future Function() getData;
  final void Function(Map<String, dynamic>) handleGetDataResponse;
  final void Function(BuildContext context) onErrorRetryButtonPressed;
  final void Function(BuildContext context)? onErrorCancelButtonPressed;
  final void Function() errorCallback;

  const FutureLoadingDataContent({
    required this.hasLoaded,
    required this.loadingText,
    this.progressBarColor = Colors.black,
    this.showCancelButton = true,
    required this.createLoadedContent,
    required this.changeLoadingText,
    required this.getData,
    required this.handleGetDataResponse,
    required this.onErrorRetryButtonPressed,
    this.onErrorCancelButtonPressed,
    required this.errorCallback,
    super.key
  });

  @override
  State<FutureLoadingDataContent> createState() => _FutureLoadingDataContentState();
}

class _FutureLoadingDataContentState extends State<FutureLoadingDataContent> {
  late StateBloc stateBloc;
  late bool openDialog; // Used because page is loaded twice.
  late bool hasError;

  @override
  void initState() {
    openDialog = false;
    hasError = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    if (hasError) {
      return Container();
    }

    if (widget.hasLoaded) {
      return widget.createLoadedContent();
    }

    widget.changeLoadingText(widget.loadingText);

    return FutureBuilder(
      future: widget.getData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(color: widget.progressBarColor)
            );
          case ConnectionState.done:
            break;
        }

        widget.changeLoadingText(Strings.emptyString);

        // Show no connection content.
        if (snapshot.data == null || (snapshot.data[Fields.statusCode] != Backend.code200 && snapshot.data[Fields.statusCode] != Backend.code201 )) {
          final title = snapshot.data != null && snapshot.data[Fields.title] != null ? snapshot.data[Fields.title] : AppLocalizations.of(context)!.translate('error_generic');
          final text = snapshot.data != null && snapshot.data[Fields.text] != null ? snapshot.data[Fields.text] : AppLocalizations.of(context)!.translate('error_generic_text');

          if (!openDialog) {
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                Utils.showMaterialAlertDialog(
                  context,
                  snapshot.data == null || snapshot.data[Fields.statusCode] == Backend.codeNoConnection ? AppLocalizations.of(context)!.translate('error_connection') : title,
                  snapshot.data == null || snapshot.data[Fields.statusCode] == Backend.codeNoConnection ? AppLocalizations.of(context)!.translate('error_connection_text') : text,
                  AppLocalizations.of(context)!.translate('retry'),
                  widget.showCancelButton ? AppLocalizations.of(context)!.translate('cancel') : null,
                  _onErrorRetryButtonPressed,
                  widget.showCancelButton ? (widget.onErrorCancelButtonPressed ?? _onErrorCancelButtonPressed) : null,
                );
              }
            });
          }

          openDialog = true;
          hasError = true;

          widget.errorCallback(); // Update hasLoaded value.

          return Container();
        }

        widget.handleGetDataResponse(snapshot.data!);

        return widget.createLoadedContent();
      }
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);
  }

  // Method that is called when the user clicks the retry button.
  void _onErrorRetryButtonPressed(BuildContext context) {
    openDialog = false;
    hasError = false;

    widget.onErrorRetryButtonPressed(this.context);
  }

  // Method that is called when the user clicks the no connection or error cancel button.
  void _onErrorCancelButtonPressed(BuildContext context) {
    Navigator.pop(this.context);
    Navigator.pop(this.context);
  }
}