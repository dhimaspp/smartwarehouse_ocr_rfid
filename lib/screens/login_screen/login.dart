import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/auth_repository/user_api.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/ip_setting.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
import 'package:smartwarehouse_ocr_rfid/widgets/exit_transition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool loading = false;
  String username = '';
  String password = '';
  String error = '';
  bool _obscure = true;
  bool _isEnable = false;

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          _textController.clear();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          // fit: StackFit.expand,
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            // Container(
            //   height: 261,
            //   color: kFillColor,
            // ),
            Container(
              // height: 280,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/header-login.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 70,
              child: Image.asset(
                'assets/logos/pp-construction-&-investment.png',
                height: 150,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 250,
              child: ocrTextBox(),
            ),
            Positioned(
              top: 350,
              child: formLogin(),
            ),
            Positioned(
              top: 30,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(EnterExitRoute(
                        exitPage: LoginScreen(), enterPage: IPSetting()));
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white60,
                    size: 28,
                  )),
            )
          ],
          // clipBehavior: Clip.hardEdge,
          // overflow: Overflow.visible,
        ),
      ),
    );
  }

  Widget ocrTextBox() {
    return Container(
      height: 48,
      width: 278,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 20)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "OCR & RFID Login",
          style: textInputDecoration.labelStyle!.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget formLogin() {
    return Column(
      children: <Widget>[
        Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    // controller: _textController,
                    cursorColor: kFillColor,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Username",
                        labelStyle: textInputDecoration.labelStyle!
                            .copyWith(color: Colors.black54, fontSize: 16),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.black38,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kMaincolor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.3))),
                    style: textInputDecoration.labelStyle!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlignVertical: TextAlignVertical.center,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Masukan Username';
                      }
                      if (val.length < 3) {
                        return 'Username Harus lebih dari \n 3 karakter';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => username = val);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // controller: _textController,
                    cursorColor: kFillColor,
                    decoration: textInputDecoration.copyWith(
                        labelStyle: textInputDecoration.labelStyle!
                            .copyWith(color: Colors.black54, fontSize: 16),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kFillColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.3))),
                    style: textInputDecoration.labelStyle!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlignVertical: TextAlignVertical.center,
                    // validator: (val) {
                    //   // String pattern =
                    //   //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                    //   // RegExp regExp = new RegExp(pattern);
                    //   // if (val.isEmpty) {
                    //   //   return 'Masukan Password';
                    //   // }
                    //   // if (!regExp.hasMatch(val)) {
                    //   //   return 'Password harus terdiri dari 8 karakter dan \n kombinasi angka dan huruf';
                    //   // }
                    //   // return null;
                    // },
                    onChanged: (password) {
                      setState(() => this.password = password);
                    },
                    obscureText: _obscure,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      clipBehavior: Clip.hardEdge,
                      style: ElevatedButton.styleFrom(
                        primary: kFillColor,
                      ),
                      child: Text(
                        "LOGIN",
                        style: textInputDecoration.labelStyle!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      onPressed: () {
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, anotherAnimation) =>
                        //             HomeScreen(),
                        //     transitionDuration: Duration(milliseconds: 350),
                        //     transitionsBuilder:
                        //         (context, animation, anotherAnimation, child) {
                        //       // animation = SlideTransition(position: Tween(begin: Off));
                        //       return SlideTransition(
                        //         position: Tween(
                        //                 begin: Offset(1.0, 0.0),
                        //                 end: Offset(0.0, 0.0))
                        //             .animate(animation),
                        //         child: child,
                        //       );
                        //     }));
                        if (formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                    ),
                  ),
                ]),
          ),
        ),
        Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
      ],
    );
  }

  // Widget _loading() {
  //   return Center(child: EasyLoading.show(),);
  // }

  void _login() async {
    EasyLoading.show(
        status: 'Loading login',
        dismissOnTap: false,
        indicator: Center(
            child: SpinKitRipple(
          color: kMaincolor,
          size: 80,
        )));
    var data = {
      'username': username,
      'password': password,
    };

    var res = await UserAuth().authData(data);
    if (res.statusCode == 500) {
      EasyLoading.showError(
          'Connectin timeout please check your local connection',
          duration: Duration(seconds: 15),
          dismissOnTap: true);
    } else {
      print(res);
      var body = json.decode(res.body);

      if (body['message'] == "Login success!") {
        SharedPreferences localData = await SharedPreferences.getInstance();
        // localData.setString('message', 'Login success!');
        localData.setString('access_token', json.encode(body['access_token']));
        localData.setString('data', json.encode(body['data']));
        print('$body');

        setState(() {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      } else {
        EasyLoading.dismiss();
        _showMsg(body['message']);
      }
    }
    EasyLoading.dismiss();
  }

  void presentLoader(BuildContext context,
      {String textIP = 'Aguarde...',
      String uid = '',
      bool barrierDismissible = true,
      bool error = false,
      bool willPop = true,
      bool success = false,
      List<Widget>? action,
      Widget? elevatedButton,
      // required VoidCallback onPressed,
      TextEditingController? ipEditingText,
      double? value}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Container(
                height: 180,
                width: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current IP or Web: \n$textIP',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: formKey2,
                      onChanged: () => setState(() {
                        _isEnable = formKey2.currentState!.validate();
                      }),
                      child: TextFormField(
                        // autovalidateMode: AutovalidateMode.always,
                        // autovalidate: true,
                        validator: (value) {
                          value!.length < 6
                              // ignore: unnecessary_statements
                              ? 'Number must be at least 8 digits'
                              : // return an error message
                              null;

                          // value!.length < 8
                          //     ? _isEnable = false
                          //     : _isEnable = true;
                        },
                        controller: ipEditingText,
                        cursorColor: kFillColor,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Type here to edit address",
                            labelStyle: textInputDecoration.labelStyle!
                                .copyWith(color: Colors.black54, fontSize: 16),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kMaincolor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1.3))),
                        style: textInputDecoration.labelStyle!
                            .copyWith(fontWeight: FontWeight.w500),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        clipBehavior: Clip.hardEdge,
                        style: ElevatedButton.styleFrom(
                          primary: kFillColor,
                        ),
                        child: Text(
                          "EDIT ADDRESS",
                          style: textInputDecoration.labelStyle!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                        onPressed: () async {
                          SharedPreferences localData =
                              await SharedPreferences.getInstance();
                          print('saving ip ${ipEditingText!.text}');
                          localData.setString('username', ipEditingText.text);
                        })
                  ],
                ),
              ),
              actions: action,
            ),
          );
        });
  }
}
