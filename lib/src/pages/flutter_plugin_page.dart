import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_node.dart';

// Utils.
import 'package:ar_test_env_app/src/commons/utils/app_localizations.dart';
import 'package:ar_test_env_app/src/commons/constants/ar_objects.dart';

// Widgets.
import 'package:ar_test_env_app/src/widgets/generic/app_bar_custom.dart';
import 'package:ar_test_env_app/src/widgets/generic/content_custom.dart';

class FlutterPluginPage extends StatefulWidget {
  const FlutterPluginPage({
    super.key
  });

  @override
  State<FlutterPluginPage> createState() => _FlutterPluginPageState();
}

class _FlutterPluginPageState extends State<FlutterPluginPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARNode arNode;

  late String nodeName;
  late ARNode selectedNode;

  @override
  void initState() {
    nodeName = 'chicken';

    super.initState();
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: AppLocalizations.of(context)!.translate('flutter_plugin'),
        onBackButtonClicked: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      body: ContentCustom(
        leftPadding: 0,
        rightPadding: 0,
        bottomPadding: 0,
        topPadding: 0,
        child: _createContent()
      ),
    );
  }

  // Method that creates the content.
  Widget _createContent() {
    return ARView(
      onARViewCreated: onARViewCreated,
      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
    );
  }

  // Method that is called when the AR view has been created.
  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arObjectManager.onPanEnd = _onPanEnd;

    this.arObjectManager.onInitialize();

    _addObjectToScene();
  }

  // Method that adds the object to the scene.
  void _addObjectToScene() async {
    selectedNode = ARNode(
      type: NodeType.localGLTF2,
      uri: ARObjects.chicken,
      name: nodeName,
      scale: vector.Vector3(0.1, 0.1, 0.1),
      position: vector.Vector3(0.0, 0.0,0.0),
      rotation: vector.Vector4(0.0, 0.0, 0.0, 0.0),
    );

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: 'assets/images/triangle.png',
      showWorldOrigin: true,
      handlePans: true,
      showAnimatedGuide: false,
    );

    await arObjectManager.addNode(selectedNode);
  }

  // Method that is called when the user end the pan.
  void _onPanEnd(String node, Matrix4 transform) {
    selectedNode.transform = transform;
  }
}

