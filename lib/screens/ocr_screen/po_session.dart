import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class POScanSession extends StatefulWidget {
  final File? _image;
  const POScanSession(this._image);
  @override
  _POScanSessionState createState() => _POScanSessionState();
}

class _POScanSessionState extends State<POScanSession> {
  bool anyImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.file(widget._image!),
      ),
    );
  }
}
