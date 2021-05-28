import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class POScanSession extends StatefulWidget {
  final File? _image;
  const POScanSession(this._image);
  @override
  _POScanSessionState createState() => _POScanSessionState();
}

class _POScanSessionState extends State<POScanSession> {
  final _cropController = CropController();
  final _imageDataList = <Uint8List>[];

  var _loadingImage = false;
  var _currentImage = 0;
  set currentImage(int value) {
    setState(() {
      _currentImage = value;
    });
    _cropController.image = _imageDataList[_currentImage];
  }

  var _isSumbnail = false;
  var _isCropping = false;
  var _isCircleUi = false;
  Uint8List? _croppedData;

  @override
  void initState() {
    _loadImages();
    super.initState();
  }

  Future<void> _loadImages() async {
    setState(() {
      _loadingImage = true;
    });

    _imageDataList.add(await _load(widget._image!.path));

    setState(() {
      _loadingImage = false;
    });
  }

  Future<Uint8List> _load(String assetName) async {
    Uri myUri = Uri.parse(assetName);
    File imgFile = new File.fromUri(myUri);
    Uint8List? bytes;
    await imgFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print("Reading byte is completed");
    }).catchError((onError) {
      print("Error get byte");
      onError.toString();
    });
    // final assetData = await widget._image!.path;
    return bytes!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Visibility(
            child: Column(children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
              ),
              Expanded(
                child: Visibility(
                  visible: _croppedData == null,
                  child: Stack(
                    children: [
                      if (_imageDataList.isNotEmpty)
                        Crop(
                          image: _imageDataList[_currentImage],
                          onCropped: (croppedData) {
                            setState(() {
                              _croppedData = croppedData;
                              _isCropping = false;
                            });
                          },
                          withCircleUi: _isCircleUi,
                          initialSize: 0.5,
                          maskColor: _isSumbnail ? Colors.white : null,
                          cornerDotBuilder: (size, index) => _isSumbnail
                              ? const SizedBox.shrink()
                              : const DotControl(),
                        ),
                      Positioned(
                          right: 16,
                          bottom: 16,
                          child: GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _isSumbnail = true),
                            onTapUp: (_) => setState(() => _isSumbnail = false),
                            child: CircleAvatar(
                              backgroundColor: _isSumbnail
                                  ? kFillColor.withOpacity(0.5)
                                  : kFillColor,
                              child: Center(
                                child: Icon(
                                  Icons.crop_free_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  replacement: Center(
                    child: _croppedData == null
                        ? SizedBox.shrink()
                        : Image.memory(_croppedData!),
                  ),
                ),
              ),
              if (_croppedData == null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: kFillColor),
                          onPressed: () {
                            setState(() {
                              _isCropping = true;
                            });
                            _cropController.crop();
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text('Crop')),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )
            ]),
            replacement: CircularProgressIndicator(
              color: kFillColor,
            ),
          ),
        ),
      ),
    );
  }
}
