import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:googoogagaapp/components/loading.dart';
import 'package:googoogagaapp/models/routes.dart';
import 'package:googoogagaapp/providers/app_state_manager.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: Routes.camera,
        key: ValueKey(Routes.camera),
        child: CameraScreen());
  }

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Camera'),
            ),
            body: CameraPreview(_controller),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Colors.black87,
              child: Icon(Icons.camera),
              onPressed: () => _takePicture(context),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }
        return LoadingScreen(message: 'Initializing camera...');
      },
    );
  }

  _takePicture(BuildContext context) async {
    final picture = await (await _controller.takePicture()).readAsBytes();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Image.memory(picture),
          );
        });
    Provider.of<AppStateManager>(context).takingPhoto(false);
  }

  _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.singleWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    _controller.initialize();
  }
}
