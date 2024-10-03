import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Bloc.
import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/backend.dart';
import 'package:ar_test_env_app/src/commons/constants/fields.dart';
import 'package:ar_test_env_app/src/commons/constants/numbers.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/utils/routes.dart';
import 'package:ar_test_env_app/src/commons/utils/utils.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/future_loading_data_content.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late StateBloc stateBloc;

  late bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureLoadingDataContent(
        changeLoadingText: stateBloc.changeLoadingText,
        createLoadedContent: _createContent,
        getData: _getData,
        handleGetDataResponse: _handleGetDataResponse,
        hasLoaded: hasLoaded,
        loadingText: AppLocalizations.of(context)!.translate('loading'),
        showCancelButton: false,
        onErrorRetryButtonPressed: _onErrorRetryButtonPressed,
        errorCallback: () => hasLoaded = true,
      ),
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);

    if (hasLoaded) {
      return;
    }

    stateBloc.reset();
    stateBloc.changeRouteName(Routes.splash);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => Future.delayed(const Duration(milliseconds: Numbers.delaySplash), () => _loadPage()));
  }

  // Method that handles the get data response.
  void _handleGetDataResponse(Map<String, dynamic> data) {
    hasLoaded = true;

    try {
      stateBloc.changeAppBuildNumber(data[Fields.appBuildNumber]);
    } catch(e) {}

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: Numbers.delaySplash), () => _loadPage());
    });
  }

  // Method that creates the content.
  Widget _createContent() {
    return const Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
    );
  }

  // Method that gets the data.
  Future<Map<String, dynamic>> _getData() async {
    // Get package info.
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return {
      Fields.statusCode: Backend.code200,
      Fields.appBuildNumber: packageInfo.buildNumber,
    };
  }

  // Method that loads the page.
  void _loadPage() {
    Utils.navigatorPushAndRemoveUntil(
      context: context,
      newRouteName: Routes.home
    );
  }

  // Method that is called when the user clicks the no connection or error retry button.
  void _onErrorRetryButtonPressed(BuildContext context) {
    Navigator.pop(this.context);
    hasLoaded = false;

    setState(() {});
  }
}
