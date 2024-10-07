import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:ar_flutter_plugin_flutterflow/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_flutterflow/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_flutterflow/datatypes/config_planedetection.dart';
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
  late ARAnchorManager arAnchorManager;
  late ARNode arNode;

  late String nodeName;
  late ARNode? selectedNode;

  late List<ARPlaneAnchor> anchors;

  @override
  void initState() {
    nodeName = 'chicken';
    selectedNode = null;

    anchors = [];

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _onDeleteAllButtonClicked,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
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
    this.arAnchorManager = arAnchorManager;

    this.arObjectManager.onPanEnd = _onPanEnd;

    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: 'assets/images/triangle.png',
      showWorldOrigin: false,
      handlePans: true,
      showAnimatedGuide: false,
    );

    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = _onPlaneOrPointTapped;
  }

  // Method that is called when the user taps a plane or a point.
  Future<void> _onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    print('>>> HUUU');
    print('>>> hitTestResults: $hitTestResults');
    if (selectedNode != null) {
      return;
    }

    dynamic singleHitTestResult = hitTestResults.firstWhere((hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

    if (singleHitTestResult == null) {
      return;
    }

    // Add hit anchor.
    ARPlaneAnchor newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager.addAnchor(newAnchor);

    if (didAddAnchor == null || !didAddAnchor) {
      return;
    }

    anchors.add(newAnchor);

    // Add note to anchor
    ARNode newNode = _getNode();

    bool? didAddNodeToAnchor = await arObjectManager.addNode(newNode, planeAnchor: newAnchor);

    if (didAddNodeToAnchor!) {
      selectedNode = newNode;
    } else {
      arSessionManager.onError!("Adding Node to Anchor failed");
    }
  }

  // Method that gets a node.
  ARNode _getNode() {
    return ARNode(
      type: NodeType.localGLTF2,
      uri: ARObjects.chicken,
      name: nodeName,
      scale: vector.Vector3(0.1, 0.1, 0.1),
      position: vector.Vector3(0.0, 0.0, 0.0),
      rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
    );
  }

  // Method that is called when the user clicks the delete all button.
  void _onDeleteAllButtonClicked() {
    for (ARPlaneAnchor anchor in anchors) {
      arAnchorManager.removeAnchor(anchor);
    }

    anchors.clear();
    selectedNode = null;
  }

  // Method that is called when the user ends the pan.
  void _onPanEnd(String node, Matrix4 transform) {
    print('>>> HI');
    selectedNode?.transform = transform;
  }
}

