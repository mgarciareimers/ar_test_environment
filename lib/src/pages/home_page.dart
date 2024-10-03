import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:ar_test_env_app/src/bloc/bloc_provider.dart';

// Constants.
import 'package:ar_test_env_app/src/commons/constants/sizes.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/utils/routes.dart';
import 'package:ar_test_env_app/src/commons/utils/utils.dart';

// Utils.
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/content_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/text_lato.dart';

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
      body: ContentCustom(
        child: _createContent()
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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: Sizes.margin20,
        mainAxisSpacing: Sizes.margin20,
      ),
      children: [
        _createItem(Routes.testCylinder),
      ],
    );
  }
  
  // Method that creates an item.
  Widget _createItem(String route) {
    return InkWell(
      onTap: () => _onItemClicked(route),
      child: Card(
        elevation: Sizes.defaultElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadius10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.margin20),
          child: Center(
            child: TextLato(
              text: AppLocalizations.of(context)!.translate(route).toUpperCase(),
              fontSize: Sizes.font20,
              fontWeight: FontWeight.w800,
              color: Colors.purple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Method that is called when the user clicks an item.
  void _onItemClicked(String route) {
    Utils.navigatorPush(context: context, newRouteName: route, originalRouteName: stateBloc.routeName);
  }
}
