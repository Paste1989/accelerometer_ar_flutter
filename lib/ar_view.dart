import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARKitImageRecognitionPage extends StatefulWidget {
  final Function(double) onDistanceChange;

  ARKitImageRecognitionPage({required this.onDistanceChange});

  @override
  _ARKitImageRecognitionPageState createState() => _ARKitImageRecognitionPageState();
}

class _ARKitImageRecognitionPageState extends State<ARKitImageRecognitionPage> {
  late ARKitController arkitController;
  ARKitNode? imageNode;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARKitSceneView(
      onARKitViewCreated: onARKitViewCreated,
      configuration: ARKitConfiguration.imageTracking,
      trackingImagesGroupName: 'AR Resources',
      maximumNumberOfTrackedImages: 1,
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = (anchor) {
      if (anchor is ARKitImageAnchor) {
        _handleImageAnchor(anchor);
      }
    };
    arkitController.onUpdateNodeForAnchor = (anchor) {
      if (anchor is ARKitImageAnchor) {
        _updateImageAnchor(anchor);
      }
    };
    arkitController.onDidRemoveNodeForAnchor = (anchor) {
      if (anchor is ARKitImageAnchor) {
        _removeImageAnchor();
        // Reset AR session to allow re-detection
        _restartARSession();
      }
    };
  }

  void _handleImageAnchor(ARKitImageAnchor anchor) {
    // Calculate the distance from the camera to the anchor
    final position = vector.Vector3(
      anchor.transform.getColumn(3).x,
      anchor.transform.getColumn(3).y,
      anchor.transform.getColumn(3).z,
    );
    final distance = position.length;
    widget.onDistanceChange(distance);

    // Update the distance notifier

    // Create a node for the detected image
    imageNode = ARKitNode(
      geometry: ARKitPlane(
        width: 0.2, // Set a predefined width for the plane
        height: 0.2, // Set a predefined height for the plane
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty.color(Colors.green.withOpacity(0.5)),
          ),
        ],
      ),
      position: position,
      eulerAngles: vector.Vector3(-vector.radians(90.0), 0, 0),
    );

    arkitController.add(imageNode!);
  }

  void _updateImageAnchor(ARKitImageAnchor anchor) {
    // Calculate the distance from the camera to the anchor
    final position = vector.Vector3(
      anchor.transform.getColumn(3).x,
      anchor.transform.getColumn(3).y,
      anchor.transform.getColumn(3).z,
    );
    final distance = position.length;

    // Update the distance notifier
    widget.onDistanceChange(distance);

    // Update the node's position
    if (imageNode != null) {
      imageNode!.position = position;
    }
  }

  void _removeImageAnchor() {
    // Reset the distance notifier
    

    // Remove the node
    if (imageNode != null) {
      arkitController.remove(imageNode!.name);
      imageNode = null;
    }
  }

  void _restartARSession() {
    // Reset the AR session to allow re-detection of the image
    // arkitController.removeSession();
    // arkitController.runConfiguration(
    //   ARKitConfiguration.imageTracking,
    //   trackingImagesGroupName: 'AR Resources',
    //   maximumNumberOfTrackedImages: 1,
    // );
    @override
  Widget build(BuildContext context) {
    return ARKitSceneView(
      onARKitViewCreated: onARKitViewCreated,
      configuration: ARKitConfiguration.imageTracking,
      trackingImagesGroupName: 'AR Resources',
      maximumNumberOfTrackedImages: 1,
    );
  }
  }
}
