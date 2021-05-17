import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/ocr_service/detector_painter.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

import 'scanner_utils.dart';

class OCRscreen extends StatefulWidget {
  const OCRscreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OCRscreenState();
}

class _OCRscreenState extends State<OCRscreen> {
  dynamic _scanResults;
  CameraController? _camera;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.medium
          : ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera!.initialize();

    await _camera!.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _recognizer.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (!mounted) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera!.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );

    if (_scanResults is! VisionText) return noResultsText;
    painter = TextDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                    fontFamily: "DimPro",
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: kMaincolor),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera!),
                _buildResults(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildImage(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _camera!.dispose().then((_) {
      _recognizer.close();
    });

    super.dispose();
  }
}
