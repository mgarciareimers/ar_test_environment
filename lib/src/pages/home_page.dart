import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/utils/routes.dart';
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBarCustom(
        title: AppLocalizations.of(context)!.translate('app_name'),
      ),
      backgroundColor: Colors.white,
      body: _createContent(),
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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() {
    return Container();
  }
}
