import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// Constants.
import 'package:ar_test_env_app/src/commons/constants/strings.dart';
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/utils.dart';

class NativeArCore extends StatefulWidget {
  const NativeArCore({super.key});

  @override
  State<NativeArCore> createState() => _NativeArCoreState();
}

class _NativeArCoreState extends State<NativeArCore> {
  late ArCoreController arCoreController;

  late bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
  }

  @override
  void dispose() {
    try {
      arCoreController.dispose();
    } catch(e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ArCoreView(
      onArCoreViewCreated: _onArCoreViewCreated,
      //enableTapRecognizer: true,
    );
  }

  // Method that initializes the variables.
  void _init() {
    if (hasLoaded) {
      return;
    }

    hasLoaded = true;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => setState(() {}));
  }

  // Method that is called when view has been created.
  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    //arCoreController.onNodeTap = _onNodeTapped;
    //arCoreController.onPlaneTap = _onPlaneTapped;
    //arCoreController.onPlaneDetected = _onPlaneDetected;

    _displayCylinder();
  }

  // Method that displays a cylinder.
  void _displayCylinder() {
    final cylinderNode = ArCoreNode(
      shape: ArCoreCylinder(
        materials: [ ArCoreMaterial(color: Colors.green) ],
        height: 0.7,
        radius: 0.5
      ),
      position: vector.Vector3(-0, -0.5, -2),
    );

    arCoreController.addArCoreNodeWithAnchor(cylinderNode);
  }
}
