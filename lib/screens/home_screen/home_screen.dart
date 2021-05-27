import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/auth_repository/user_api.dart';
import 'package:smartwarehouse_ocr_rfid/main.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/login.dart';
import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/ocr_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/po_session.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;

  // @override
  // void initState() {
  //   _loadDataUser();
  //   super.initState();
  // }

  // _loadDataUser() async {
  //   SharedPreferences localData = await SharedPreferences.getInstance();
  //   var username = jsonDecode(localData.getString('username'));

  //   if (username != null) {
  //     setState(() {
  //       name = username['name'];
  //     });
  //   }
  // }

  File? _image;
  bool? anyImage;

  _imageFromCamera() async {
    PickedFile? pick = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    File pickeds;
    if (pick == null) {
      return Container();
    } else {
      pickeds = File(pick.path);
      _image = pickeds;
    }
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => POScanSession(_image)));
    // File? picked = File(pick.path);
    // _image = pickeds;
    // return Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => POScanSession(_image)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child:
            Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
          Container(
            height: 140,
            decoration: BoxDecoration(
                color: kFillColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
          ),
          Positioned(
            top: 60,
            left: 15,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Hello,',
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyApp()));
                  // logout();
                }),
          ),
          Positioned(
            top: 60,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                                  onPressed: () {
                                    _imageFromCamera();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: kTextColor,
                                      alignment: Alignment.centerRight),
                                  child: RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          style: textInputDecoration.labelStyle,
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
                                  onPressed: () {
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) => OCRscreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: kTextColor,
                                      alignment: Alignment.centerRight),
                                  child: RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          style: textInputDecoration.labelStyle,
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
    );
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
