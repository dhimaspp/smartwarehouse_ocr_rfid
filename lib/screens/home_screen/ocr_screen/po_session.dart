// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:smartwarehouse_ocr_rfid/bloc/list_images_bloc.dart';
// import 'package:smartwarehouse_ocr_rfid/screens/home_screen/ocr_screen/images_page.dart';
// import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
// import 'package:path_provider/path_provider.dart';

// class POScanSession extends StatefulWidget {
//   final File? image;
//   const POScanSession({this.image, Key? key}) : super(key: key);
//   @override
//   POScanSessionState createState() => POScanSessionState();
// }

// class POScanSessionState extends State<POScanSession> {
//   final _cropController = CropController();
//   final _imageDataList = <Uint8List?>[];
//   List<String> assets = <String>[];
//   DateTime now = DateTime.now();
//   late File thisImage;

//   var _currentImage = 0;
//   set currentImage(int value) {
//     setState(() {
//       _currentImage = value;
//     });
//     _cropController.image = _imageDataList[_currentImage]!;
//   }

//   var _isSumbnail = false;

//   var _isCircleUi = false;
//   Uint8List? _croppedData;

//   @override
//   void initState() {
//     _loadImages();
//     super.initState();
//   }

//   Future<void> _loadImages() async {
//     _imageDataList.add(await _load(widget.image!.path));

//     // _cropController.image = _imageDataList[0];
//   }

//   Future<Uint8List?> _load(String assetName) async {
//     Uri myUri = Uri.parse(assetName);
//     File imgFile = new File.fromUri(myUri);
//     Uint8List? bytes;
//     await imgFile.readAsBytes().then((value) {
//       bytes = Uint8List.fromList(value);
//       print("Reading byte is completed");
//     }).catchError((onError) {
//       print("Error get byte");
//       onError.toString();
//     });
//     // final assetData = await widget._image!.path;
//     return bytes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Center(
//           child: Visibility(
//             child: Column(children: [
//               Container(
//                 height: MediaQuery.of(context).size.aspectRatio,
//                 color: Colors.white24,
//               ),
//               Expanded(
//                 child: Visibility(
//                   visible: _croppedData == null,
//                   child: Stack(
//                     children: [
//                       if (_imageDataList.isNotEmpty)
//                         Crop(
//                           controller: _cropController,
//                           baseColor: Colors.white24,
//                           image: _imageDataList[0]!,
//                           onCropped: (croppedData) {
//                             setState(() {
//                               _croppedData = croppedData;
//                               print(
//                                   'Print cropped image 1 ${_croppedData.toString()}');
//                             });
//                           },
//                           withCircleUi: _isCircleUi,
//                           initialSize: 0.8,
//                           maskColor: _isSumbnail ? Colors.white : null,
//                           cornerDotBuilder: (size, index) => _isSumbnail
//                               ? const SizedBox.shrink()
//                               : const DotControl(),
//                         ),
//                       Positioned(
//                           right: 16,
//                           bottom: 16,
//                           child: GestureDetector(
//                             onTapDown: (_) =>
//                                 setState(() => _isSumbnail = true),
//                             onTapUp: (_) => setState(() => _isSumbnail = false),
//                             child: Container(
//                               height: 32,
//                               width: 32,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: _isSumbnail
//                                     ? kFillColor
//                                     : Colors.white.withOpacity(0.2),
//                               ),
//                               // color: _isSumbnail
//                               //     ? kFillColor.withOpacity(0.5)
//                               //     : kFillColor,
//                               child: Center(
//                                 child: Icon(
//                                   Icons.crop_free_rounded,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ))
//                     ],
//                   ),
//                   replacement: Center(
//                     child: _croppedData == null
//                         ? SizedBox.shrink()
//                         : Image.memory(_croppedData!),
//                   ),
//                 ),
//               ),
//               _croppedData == null
//                   ? Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 16,
//                           ),
//                           Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text(
//                                         'Cancel',
//                                         style: textInputDecoration.labelStyle!
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Colors.white),
//                                       )),
//                                   // _isCropping == true
//                                   //     ? Center(
//                                   //         child: SpinKitThreeBounce(
//                                   //         color: Colors.white,
//                                   //         size: 80,
//                                   //       ))
//                                   //     : Container(),
//                                   TextButton(
//                                       onPressed: () async {
//                                         EasyLoading.show(
//                                             status: 'Cropping Image');
//                                         _cropController.crop();
//                                         // print(
//                                         //     'Print cropped image ${_imageDataList[_currentImage].toString()}');
//                                         Future.delayed(
//                                             const Duration(seconds: 7),
//                                             () async {
//                                           print('delay -----');
//                                           print(
//                                               'Print cropped image 2 ${_croppedData.toString()}');
//                                           Directory tempDir =
//                                               await getApplicationDocumentsDirectory();
//                                           final String tempPath = tempDir.path;
//                                           Future<File> image = await File(
//                                                   '$tempPath/PO${now.millisecond}.jpg')
//                                               .writeAsBytes(_croppedData!)
//                                               .then((value) {
//                                             thisImage = value;
//                                           } as FutureOr<Future<File>> Function(File));
//                                           // File thisImage = await image;
//                                           imagePathBloc
//                                             ..addImagePath(thisImage.path);

//                                           // final myImagePathTemp =
//                                           //     tempPath + thisImage.path;
//                                           // File saveImage = File(myImagePathTemp);
//                                           EasyLoading.showSuccess(
//                                               'Success Cropping Image');

//                                           print(
//                                               'image path ${thisImage.path} ++++++++++');
//                                           return Navigator.of(context).push(
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ImagesPages()));
//                                         });
//                                       },
//                                       child: Text(
//                                         'Next',
//                                         style: textInputDecoration.labelStyle!
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Colors.white),
//                                       )),
//                                 ],
//                               )
//                               // ElevatedButton(
//                               //   style: ElevatedButton.styleFrom(primary: kFillColor),
//                               //   onPressed: () {l56
//                               //     setState(() {
//                               //       _isCropping = true;
//                               //     });
//                               //     _cropController.crop();
//                               //   },
//                               //   child: Padding(
//                               //       padding: const EdgeInsets.symmetric(vertical: 16),
//                               //       child: Text('Crop')),
//                               // ),
//                               ),
//                           SizedBox(
//                             height: 50,
//                           )
//                         ],
//                       ),
//                     )
//                   : Container()
//             ]),
//             replacement: CircularProgressIndicator(
//               color: kFillColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
