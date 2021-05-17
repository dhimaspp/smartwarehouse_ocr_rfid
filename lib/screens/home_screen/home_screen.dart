import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/auth_repository/user_api.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/login.dart';
import 'package:smartwarehouse_ocr_rfid/screens/ocr_screen/ocr_screen.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'HI, $name',
                    style: textInputDecoration.labelStyle!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: RichText(
                        text: TextSpan(
                            style: textInputDecoration.labelStyle!.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 20),
                            children: <InlineSpan>[
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child:
                                // IconButton(
                                //     icon:
                                Icon(Icons.logout, color: kMaincolor),
                            // onPressed: () {
                            //   // logout();
                            // }),
                          ),
                          TextSpan(text: 'Logout'),
                        ])),
                  )
                ]),
          ),
          Divider(),
          Container(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 155,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Image.asset(
                          'assets/images/ocr_icon2.png',
                          height: 100,
                          width: 175,
                        ),
                        Text(
                          'Scanning PO with OCR',
                          style: textInputDecoration.labelStyle!.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 20),
                          textAlign: TextAlign.center,
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
                            blurRadius: 1.5,
                          )
                        ]),
                  ),
                  Container(
                    height: 60,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OCRscreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kMaincolor,
                          alignment: Alignment.centerRight),
                      child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                              style: textInputDecoration.labelStyle,
                              children: <InlineSpan>[
                                TextSpan(
                                    text: 'Start',
                                    style: textInputDecoration.labelStyle!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20)),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.arrow_right_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ])),
                    ),
                    decoration: BoxDecoration(
                        color: kMaincolor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black,
                              blurRadius: 3.0,
                              offset: Offset(0, 0.9))
                        ]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 155,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        Image.asset(
                          'assets/images/rfid.png',
                          height: 100,
                          width: 175,
                        ),
                        Text(
                          'PO Regist (RFID Tag)',
                          style: textInputDecoration.labelStyle!.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 20),
                          textAlign: TextAlign.center,
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
                            blurRadius: 1.5,
                          )
                        ]),
                  ),
                  Container(
                    height: 60,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        // logout();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kMaincolor,
                          alignment: Alignment.centerRight),
                      child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                              style: textInputDecoration.labelStyle,
                              children: <InlineSpan>[
                                TextSpan(
                                    text: 'Open',
                                    style: textInputDecoration.labelStyle!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20)),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.arrow_right_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ])),
                    ),
                    decoration: BoxDecoration(
                        color: kMaincolor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black,
                              blurRadius: 3.0,
                              offset: Offset(0, 0.9))
                        ]),
                  )
                ]),
          )
        ]),
      ),
    );
  }

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
