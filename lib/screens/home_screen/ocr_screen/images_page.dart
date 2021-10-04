import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/model/upload_response.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/ocr_screen/po_session.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class ImagesPages extends StatefulWidget {
  // const ImagesPages({this.imagePath, Key key}) : super(key: key);
  // final List<String> imagePath;

  @override
  _ImagesPagesState createState() => _ImagesPagesState();
}

class _ImagesPagesState extends State<ImagesPages> {
  List<Widget> imagesAsset = <Widget>[];
  List<String> assets = <String>[];
  List<MultipartFile> listMultiPartFile = [];
  bool finishAdding, _onLongPressed;
  bool _isEmpty = true;
  int indexPressed = 0;
  final Dio _dio = Dio();
  String token;
  File pickeds;

  @override
  void initState() {
    super.initState();
    _getAssetsImage();

    print('isi assets list ${assets.length}');
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  _getAssetsImage() async {
    setState(() {
      _isEmpty = true;
    });
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();

    List<String> tempList = [];
    // List<String> listPref = sharedLocal.getStringList('ListImagePath');

    List<String> listPrefFix = sharedLocal.getStringList('ListImagePathFix');
    tempList = listPrefFix;
    token = jsonDecode(sharedLocal.getString('access_token'));
    // print('listPref = $listPref');
    print('listPrefFix = $listPrefFix');

    // if (listPrefFix != null) {
    //   setState(() {
    //     assets = tempList;
    //     _isEmpty = false;
    //     sharedLocal.setStringList('ListImagePathFix', assets);
    //   });
    //   print('assets = listPref');
    // } else
    if (tempList.length != 0) {
      setState(() {
        _isEmpty = false;
        assets = tempList;
        // if (listPref.isNotEmpty) {
        //   var listIndex = listPref[0];
        //   for (var i = 0; i < assets.length; i++) {
        //     if (listIndex == assets[i]) {
        //       print('print image path $listIndex');
        //     } else {
        //       assets.add(listIndex);
        //       print('print success adding image');
        //       // sharedLocal.remove('ListImagePath');
        //       sharedLocal.setStringList('ListImagePathFix', assets);
        //       break;
        //     }

        //     // ListTempImage().imagePath.add(widget.imagePath);
        //     // return assets;
        //     // ListTempImage().imagePath;
        //   }
        // }
      });

      print('assets = listPrefix');
    } else {
      setState(() {
        _isEmpty = true;
      });
    }
    // assets = listPrefFix;

    // print('print image path $listPref');

    // if (listPref.first != null) {
    //   var listIndex = listPref[0];
    //   for (var i = 0; i < assets.length; i++) {
    //     if (listIndex == assets[i]) {
    //       print('print image path $listIndex');
    //     } else {
    //       assets.add(listIndex);
    //       break;
    //     }

    //     sharedLocal.remove('ListImagePath');
    //     sharedLocal.setStringList('ListImagePathFix', assets);
    //     // ListTempImage().imagePath.add(widget.imagePath);
    //     // return assets;
    //     // ListTempImage().imagePath;
    //   }
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 110,
          child: Stack(
              overflow: Overflow.visible,
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: kFillColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(18))),
                ),
                Positioned(
                  top: 55,
                  left: 5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, primary: kFillColor),
                            onPressed: () {
                              // SharedPreferences sharedLocal =
                              //     await SharedPreferences.getInstance();
                              // sharedLocal.remove('ListImagePath');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                            },
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            )),
                        Text(
                          'PO Images Preview',
                          style: textInputDecoration.labelStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ]),
                ),
              ]),
        ),
        _isEmpty == true
            ? GestureDetector(
                onTap: () async {
                  EasyLoading.show(
                      dismissOnTap: true,
                      indicator: Center(
                          // heightFactor: MediaQuery.of(context).size.height,
                          child: SpinKitRipple(
                        color: kMaincolor,
                        size: 80,
                      )));
                  final PickedFile pick = await ImagePicker()
                      .getImage(source: ImageSource.camera, imageQuality: 50);

                  if (pick == null) {
                    return Container();
                  } else {
                    pickeds = File(pick.path);
                    _cropImage();
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) {
                    //   return POScanSession(
                    //     image: pickeds,
                    //   );
                    // }));
                  }
                  EasyLoading.dismiss();

                  // setState(() {
                  //   _loadingImage = false;
                  // });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'There is no image PO\nClick here to take picture PO',
                            textAlign: TextAlign.center,
                            style: textInputDecoration.labelStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.black)),
                        Container(
                          // alignment: Alignment.center,
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 80,
                            color: Colors.black38,
                          ),
                        )
                      ]),
                ),
              )
            : Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.85),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 12),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black12, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[100],
                                      blurRadius: 10.0,
                                      spreadRadius: 5.0,
                                      offset: Offset(
                                        3.0,
                                        1.0,
                                      ),
                                    )
                                  ],
                                ),
                                child: Image.file(File(assets[index]))),
                            Positioned(
                              right: -2,
                              top: -8,
                              child: GestureDetector(
                                onTap: () {
                                  _showDeleteModalBottomSheet(index, context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2.0,
                                          // spreadRadius: 1.0,
                                          // offset: Offset(
                                          //   // 1.0,
                                          //   // 1.0,
                                          // ),
                                        )
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.red[600]),
                                  child: Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
      ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked.getOffset(ScaffoldGeometry(12, )),
      floatingActionButton: _isEmpty == true
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 46.0),
              child: FloatingActionButton(
                onPressed: () async {
                  EasyLoading.show(
                      dismissOnTap: true,
                      indicator: Center(
                          // heightFactor: MediaQuery.of(context).size.height,
                          child: SpinKitRipple(
                        color: kMaincolor,
                        size: 80,
                      )));
                  final XFile pick = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 50);
                  // File pickeds;
                  if (pick == null) {
                    return Container();
                  } else {
                    pickeds = File(pick.path);
                  }

                  _cropImage();
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return POScanSession(
                  //     image: pickeds,
                  //   );
                  // }));
                  EasyLoading.dismiss();
                  // setState(() {
                  //   assets.add(pickeds.path);
                  //   _loadingImage = false;
                  // });
                },
                child: Icon(Icons.add_a_photo_rounded),
                backgroundColor: kMaincolor,
              ),
            ),
      bottomSheet: _isEmpty == true
          ? null
          : Container(
              height: 55,
              margin: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: kMaincolor),
                  onLongPress: () {
                    setState(() {
                      if (indexPressed == 0) {
                        indexPressed = 1;
                        print('index press = $indexPressed');
                        _onLongPressed = true;
                      } else if (indexPressed == 1) {
                        indexPressed = 0;
                        print('index press = $indexPressed');
                        _onLongPressed = false;
                      }
                    });
                  },
                  onPressed: () async {
                    if (_onLongPressed == true) {
                      EasyLoading.show(
                          status: 'getting ready to upload',
                          dismissOnTap: true,
                          indicator: Center(
                              // heightFactor: MediaQuery.of(context).size.height,
                              child: SpinKitRipple(
                            color: Colors.white,
                            // size: 80,
                          )));
                      SharedPreferences sharedLocal =
                          await SharedPreferences.getInstance();
                      var listData =
                          sharedLocal.getStringList('ListImagePathFix');

                      String baseName;
                      for (var i = 0; i < listData.length; i++) {
                        print('adding image : $basename');
                        print('listData index: ${listData[i]}');
                        Uri myUri = Uri.parse(listData[i]);
                        File imageFile = new File.fromUri(myUri);
                        var bytesUri = await imageFile.readAsBytes();
                        // ByteData bytes =  listData[i].;
                        List<int> imageData = bytesUri;
                        // var buffer = bytes.buffer;
                        // var m = base64.encode(Uint8List.view(buffer));

                        MultipartFile multipartFileBytes =
                            MultipartFile.fromBytes(
                          imageData,
                          filename: basename(listData[i]),
                          contentType: MediaType('image', 'jpg'),
                        );
                        // MultipartFile multipartFile =
                        //     await MultipartFile.fromFile(listData[i],
                        //         filename: basename(listData[i]));
                        listMultiPartFile.add(multipartFileBytes);
                      }

                      var formdata =
                          FormData.fromMap({"image": listMultiPartFile});
                      var postRegister =
                          "http://100.68.1.32:7030/v1/purchase-orders";

                      try {
                        // Response<ResponseBody> rs;
                        print(
                            'list data form: ${formdata.files.map((e) => e.value.filename.toString())}');
                        var response = await _dio.post(
                          postRegister,
                          data: formdata,
                          options: Options(
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Connection': 'keep-alive',
                            },
                            contentType: 'multipart/form-data;',
                            method: 'post',
                            responseType: ResponseType.json,
                          ),
                          onSendProgress: (received, total) {
                            if (total != -1) {
                              double progress = (received / total);
                              String progressString;
                              setState(() {
                                progressString = (received / total * 100)
                                        .toStringAsFixed(0) +
                                    '%';
                              });

                              print('progress : $progress');
                              EasyLoading.showProgress(progress,
                                      status:
                                          'Uploading images to OCR\n$progressString')
                                  .whenComplete(() => EasyLoading.show(
                                      status: 'Processing OCR to Text',
                                      dismissOnTap: true,
                                      indicator: Center(
                                          // heightFactor: MediaQuery.of(context).size.height,
                                          child: SpinKitRipple(
                                        color: Colors.white,
                                        // size: 80,
                                      ))));
                              print(
                                  (received / total * 100).toStringAsFixed(0) +
                                      '%');
                            }
                          },

                          // responseType: ResponseType.stream),
                        );
                        // rs = response.data;
                        // print('-------------------${rs.data!.stream}');
                        print('response upload : $response');
                        UploadPOResponse.fromJson(response.data);
                        EasyLoading.showSuccess('Success Processing Images!',
                            duration: Duration(seconds: 6));
                        sharedLocal.remove('ListImagePathFix');
                        setState(() {
                          _isEmpty = true;
                        });

                        return Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      } catch (error, stacktrace) {
                        EasyLoading.showError('Error: $error',
                            duration: Duration(seconds: 6), dismissOnTap: true);
                        print(
                            "Exception occured:$error stacktrrace:$stacktrace");
                        return error.toString();
                      }

                      // UploadWidget(listMultiPartFile);
                    }
                    // setState(() {
                    //   _isLoading = true;
                    // });
                    // await context.read<AddProductCubit>().addProduct(idProduct);
                    // setState(() {
                    //   _isLoading = false;
                    //   Get.to(() => MainPage(
                    //         initialPage: 1,
                    //       ));
                    // });
                  },
                  child: _onLongPressed == true
                      ? Text(
                          'Procces to OCR',
                          style: textInputDecoration.labelStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.white),
                        )
                      : Text(
                          'Long Press to Set Ready',
                          style: textInputDecoration.labelStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.white),
                        )),
            ),
    );
  }

  _showDeleteModalBottomSheet(int index, BuildContext context) {
    return showBarModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 390,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Are you sure want to delete this photo?",
                    style: TextStyle(
                        color: kFillColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100],
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              3.0,
                              1.0,
                            ),
                          )
                        ],
                      ),
                      child: Image.file(
                        File(assets[index]),
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // list.isEmpty
                        //     ? Text('')
                        //     : list[0],
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width / 1.1,
                                    40),
                                elevation: 2,
                                primary: kFillColor),
                            onPressed: () async {
                              // _showDeleteModalBottomSheet(index);
                              SharedPreferences sharedData =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                assets.removeAt(index);

                                sharedData
                                    .setStringList('ListImagePathFix', assets)
                                    .whenComplete(
                                        () => Navigator.of(context).pop());
                                var localDataFix = sharedData
                                    .getStringList('ListImagePathFix');
                                if (localDataFix.isEmpty) {
                                  setState(() {
                                    _isEmpty = true;
                                  });
                                }
                              });
                            },
                            child:
                                Text("Delete", style: TextStyle(fontSize: 16))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width / 1.1,
                                    40),
                                elevation: 2,
                                primary: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black))),
                      ]),
                ],
              ),
            ));
  }

  Future _cropImage() async {
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickeds.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            statusBarColor: kMaincolor,
            toolbarTitle: 'Cropper',
            toolbarColor: kMaincolor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            activeControlsWidgetColor: kMaincolor,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      pickeds = croppedFile;
      setState(() {
        print('image cropper file : $pickeds');
        assets.add(pickeds.path);

        sharedLocal.setStringList('ListImagePathFix', assets);
        _getAssetsImage();
      });
    }
  }
}
