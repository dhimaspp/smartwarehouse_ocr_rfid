import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/auth_repository/user_api.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool loading = false;
  String username = '';
  String password = '';
  String error = '';
  bool _obscure = true;

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
            Container(
              height: 261,
              color: kFillColor,
            ),
            Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Image.asset("assets/images/header-login.png"),
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
          style: textInputDecoration.labelStyle.copyWith(
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
                        labelStyle: textInputDecoration.labelStyle
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
                    style: textInputDecoration.labelStyle
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlignVertical: TextAlignVertical.center,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Masukan Username';
                      }
                      if (val.length < 8) {
                        return 'Username Harus lebih dari \n 8 karakter';
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
                        labelStyle: textInputDecoration.labelStyle
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
                    style: textInputDecoration.labelStyle
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
                        style: textInputDecoration.labelStyle.copyWith(
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
                        if (formKey.currentState.validate()) {
                          _login();
                        }
                      },
                    ),
                  )
                ]),
          ),
        ),
        loading ? _loading() : SizedBox(height: 50),
        Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _loading() {
    return SpinKitPulse(
      color: kSecondaryColor,
      size: 50,
    );
  }

  void _login() async {
    setState(() {
      loading = true;
    });
    var data = {
      'username': username,
      'password': password,
    };

    var res = await UserAuth().authData(data);
    var body = json.decode(res.body);

    if (body['message'] == "Login success!") {
      SharedPreferences localData = await SharedPreferences.getInstance();
      // localData.setString('message', 'Login success!');
      localData.setString('access_token', json.encode(body['access_token']));
      localData.setString('data', json.encode(body['data']));
      print('$body');

      setState(() {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } else {
      _showMsg(body['message']);
    }
    setState(() {
      loading = false;
    });
  }
}
