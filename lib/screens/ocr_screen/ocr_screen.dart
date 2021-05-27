// import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/ocr_service/detector_painter.dart';
// import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/ocr_service/result_preview.dart';
// import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

// import 'ocr_service/scanner_utils.dart';

// class OCRscreen extends StatefulWidget {
//   const OCRscreen({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _OCRscreenState();
// }

// class _OCRscreenState extends State<OCRscreen> {
//   XFile? imageFile;
//   String? imagePath;
//   dynamic _scanResults;
//   CameraController? _camera;

//   bool _isDetecting = false;
//   CameraLensDirection _direction = CameraLensDirection.back;

//   final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final CameraDescription description =
//         await ScannerUtils.getCamera(_direction);

//     _camera = CameraController(
//       description,
//       defaultTargetPlatform == TargetPlatform.android
//           ? ResolutionPreset.veryHigh
//           : ResolutionPreset.high,
//       enableAudio: false,
//     );
//     await _camera!.initialize();

//     await _camera!.startImageStream((CameraImage image) {
//       if (_isDetecting) return;

//       _isDetecting = true;

//       ScannerUtils.detect(
//         image: image,
//         detectInImage: _recognizer.processImage,
//         imageRotation: description.sensorOrientation,
//       ).then(
//         (dynamic results) {
//           if (!mounted) return;
//           setState(() {
//             _scanResults = results;
//           });
//         },
//       ).whenComplete(() => _isDetecting = false);
//     });
//   }

//   Widget _buildResults() {
//     const Text noResultsText = Text('No results!');

//     if (_scanResults == null ||
//         _camera == null ||
//         !_camera!.value.isInitialized) {
//       return noResultsText;
//     }

//     CustomPainter painter;

//     final Size imageSize = Size(
//       _camera!.value.previewSize!.height,
//       _camera!.value.previewSize!.width,
//     );

//     if (_scanResults is! VisionText) return noResultsText;
//     painter = TextDetectorPainter(imageSize, _scanResults);

//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   Future<void> takePicture() async {
//     await Future.delayed(Duration(milliseconds: 500));
//     await _camera!.stopImageStream();
//     await Future.delayed(Duration(milliseconds: 200));
//     XFile file = await _camera!.takePicture();
//     imagePath = file.path;
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => PreviewScreen(imagePath)));
//   }
//   // Future<XFile?> takePicture() async {
//   //   if (_camera == null || _camera!.value.isInitialized) {
//   //     showInSnackBar('Error: select a camera first.');
//   //     return null;
//   //   }

//   //   if (_camera!.value.isTakingPicture) {
//   //     // A capture is already pending, do nothing.
//   //     return null;
//   //   }

//   //   try {
//   //     XFile file = await _camera!.takePicture();
//   //     return file;
//   //   } on CameraException catch (e) {
//   //     _showCameraException(e);
//   //     return null;
//   //   }
//   // }

//   // void onTakePictureButtonPressed() {
//   //   takePicture().then((XFile? file) {
//   //     if (mounted) {
//   //       setState(() {
//   //         imageFile = file;
//   //       });
//   //       if (file != null) showInSnackBar('Picture saved to ${file.path}');
//   //     }
//   //   });
//   // }

//   // void showInSnackBar(String message) {
//   //   // ignore: deprecated_member_use
//   //   _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
//   // }

//   // void _showCameraException(CameraException e) {
//   //   logError(e.code, e.description);
//   //   showInSnackBar('Error: ${e.code}\n${e.description}');
//   // }

//   // void logError(String code, String? message) {
//   //   if (message != null) {
//   //     print('Error: $code\nError Message: $message');
//   //   } else {
//   //     print('Error: $code');
//   //   }
//   // }

//   Widget _buildImage() {
//     return Container(
//       color: Colors.black,
//       constraints: const BoxConstraints.expand(),
//       child: _camera == null
//           ? const Center(
//               child: Text(
//                 'Initializing Camera...',
//                 style: TextStyle(
//                     fontFamily: "Anodina",
//                     fontSize: 30,
//                     fontWeight: FontWeight.w300,
//                     color: kMaincolor),
//               ),
//             )
//           : Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.width /
//                   _camera!.value.aspectRatio,
//               child: Container(
//                 child: Stack(
//                   alignment: FractionalOffset.center,
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     CameraPreview(_camera!),
//                     // _buildResults(),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         height: 120,
//                         width: double.infinity,
//                         padding: EdgeInsets.all(20),
//                         color: Color.fromRGBO(00, 00, 00, 0.7),
//                         child: Stack(
//                           children: <Widget>[
//                             Align(
//                               alignment: Alignment.center,
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(50.0)),
//                                     onTap: () {
//                                       takePicture();
//                                     },
//                                     child: Padding(
//                                       padding: EdgeInsets.all(4.0),
//                                       child: Image.asset(
//                                         'assets/images/shutter.png',
//                                         width: 67.0,
//                                         height: 67.0,
//                                         color: Colors.white,
//                                       ),
//                                     )),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildImage(),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   @override
//   void dispose() {
//     _camera!.dispose().then((_) {
//       _recognizer.close();
//     });

//     super.dispose();
//   }
// }
