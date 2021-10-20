import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/assign_rfid.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/bt_pairing/select_bounded_device.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/ocr_screen/images_page.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/login.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  bool loading = false;
  Future<bool>? back;
  String? token;
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    _loadDataUser();
  }

  _loadDataUser() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var data = jsonDecode(localData.getString('data')!);
    localData.remove('ListImagePath');
    localData.remove('poNumber');

    localData.setString('username', json.encode(data['username']));
    token = jsonDecode(localData.getString('access_token')!);
    DateTime expirationDate = JwtDecoder.getExpirationDate(token!);
    bool hasExpired = JwtDecoder.isExpired(token!);
    if (hasExpired == true) {
      EasyLoading.showError('Your session login has Expired');
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
    print('Token Expired Date: $expirationDate');

    var username = jsonDecode(localData.getString('username')!);

    if (username != null) {
      setState(() {
        name = username;
      });
    } else {
      EasyLoading.showError('Your session login has Expired');
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
    // connection.dispose();
  }

  // ignore: unused_field
  File? _image;
  bool? anyImage;

  // ignore: unused_element
  _imageFromCamera() async {
    XFile? pick = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    File pickeds;
    if (pick == null) {
      return Container();
    } else {
      setState(() {
        loading = true;
      });

      pickeds = File(pick.path);
      _image = pickeds;
      setState(() => loading = false);
    }
    // return Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => POScanSession(_image)));
    // File? picked = File(pick.path);
    // _image = pickeds;
    // return Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => POScanSession(_image)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(alignment: AlignmentDirectional.topCenter, children: <
              Widget>[
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: kFillColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(18))),
            ),
            Positioned(
              top: 60,
              left: 15,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello!',
                      textAlign: TextAlign.left,
                      style: textInputDecoration.labelStyle!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    Text(
                      '$name',
                      style: textInputDecoration.labelStyle!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                  ]),
            ),
            Positioned(
              top: 60,
              right: 15,
              child: IconButton(
                  icon: Image.asset(
                    "assets/logos/Logout-Button.png",
                    height: 30,
                  ),
                  onPressed: () {
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) => MyApp()));
                    logout();
                  }),
            ),
            Positioned(
              top: 50,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.1,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      loading ? _loading() : SizedBox(height: 50),
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(children: <Widget>[
                            Image.asset(
                              'assets/images/OCR-Icon.png',
                              height: 160,
                              width: 230,
                            ),
                          ]),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 0.7,
                              )
                            ]),
                      ),
                      Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "Scanning PO With OCR",
                              style: textInputDecoration.labelStyle!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 51,
                                  width: 125,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImagesPages()));

                                      // setState(() {
                                      //   loading = true;
                                      // });
                                      //   final PickedFile pick =
                                      //       await ImagePicker().getImage(
                                      //           source: ImageSource.camera,
                                      //           imageQuality: 50);
                                      //   File pickeds;
                                      //   if (pick == null) {
                                      //     return Container();
                                      //   } else {
                                      //     pickeds = File(pick.path);
                                      //     _image = pickeds;
                                      //   }
                                      //   setState(() => loading = false);
                                      //   return Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               POScanSession(_image)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: kTextColor,
                                        alignment: Alignment.centerRight),
                                    child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            style:
                                                textInputDecoration.labelStyle,
                                            children: <InlineSpan>[
                                              TextSpan(
                                                  text: 'Start',
                                                  style: textInputDecoration
                                                      .labelStyle!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16)),
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Icon(
                                                  Icons.arrow_right_outlined,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                            ])),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: kFillColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 1.0,
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(children: <Widget>[
                            Image.asset(
                              'assets/images/RFID-Icon.png',
                              height: 150,
                              width: 220,
                            ),
                          ]),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 0.7,
                              )
                            ]),
                      ),
                      Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              "PO Registration (RFID Tag)",
                              style: textInputDecoration.labelStyle!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 51,
                                  width: 125,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) {
                                      //   return AssignRFID();
                                      // }));
                                      final BluetoothDevice? selectedDevice =
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                        return SelectBondedDevicePage(
                                          checkAvailability: false,
                                        );
                                      }));
                                      if (selectedDevice != null) {
                                        print('Connect to Device :' +
                                            selectedDevice.address);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AssignRFID(selectedDevice);
                                        }));
                                      } else {
                                        print('no device selected');
                                      }
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) => BTScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: kTextColor,
                                        alignment: Alignment.centerRight),
                                    child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                            style:
                                                textInputDecoration.labelStyle,
                                            children: <InlineSpan>[
                                              TextSpan(
                                                  text: 'Open   ',
                                                  style: textInputDecoration
                                                      .labelStyle!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16)),
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.top,
                                                child: Icon(
                                                  Icons.file_copy_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ])),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: kFillColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black,
                                blurRadius: 1.0,
                              )
                            ]),
                      ),
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void logout() async {
    // var res = await UserAuth().getData();
    // var body = json.decode(res.body);
    // if (body['success']) {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('username');
    localStorage.remove('access_token');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // }
  }

  Widget _loading() {
    return Text("Waiting");
    // new Stack(
    //   children: [
    //     new Opacity(
    //       opacity: 0.3,
    //       child: ModalBarrier(dismissible: false, color: Colors.grey),
    //     ),
    //     new Center(
    //       child: new CircularProgressIndicator(),
    //     ),
    //   ],
    // );
  }

  // Widget imageCroping() {
  //   return Scaffold(
  //     body: _image == null
  //         ? Container(child: Image.asset("assets/images/header-login.png"))
  //         : Container(
  //             child: Image.file(_image!),
  //           ),
  //   );
  // }

  // void logout() async {
  //   var res = await UserAuth().getData('/logout');
  //   var body = json.decode(res.body);
  //   if (body['success']) {
  //     SharedPreferences localData = await SharedPreferences.getInstance();
  //     localData.remove('username');
  //     localData.remove('token');
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //   }
  // }
}
