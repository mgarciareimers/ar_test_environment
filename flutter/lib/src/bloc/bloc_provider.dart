import 'package:flutter/material.dart';

// Import.
import 'package:ar_test_env_app/src/bloc/state_bloc.dart';

// Export.
export 'package:ar_test_env_app/src/bloc/state_bloc.dart';

class BlocProvider extends InheritedWidget {
  static BlocProvider? _instance;

  factory BlocProvider({ Key? key, required Widget child }) {
    _instance ??= BlocProvider._internal(key: key, child: child);

    return _instance!;
  }

  BlocProvider._internal({ super.key, required super.child });

  final StateBloc _stateBloc = StateBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static StateBloc stateBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._stateBloc;
}