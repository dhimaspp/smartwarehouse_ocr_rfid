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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SizedBox(
        // height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 18),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/logos/pp-construction-&-investment.png',
                  height: 200,
                ),
                Divider(
                  thickness: 2.0,
                  color: kSecondaryColor.withOpacity(0.3),
                ),
                SizedBox(height: 25),
                Text(
                  "- OCR & RFID Registration -",
                  style: textInputDecoration.labelStyle!.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: -1),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _textController,
                            decoration: textInputDecoration.copyWith(
                                hintText: "Username",
                                suffixIcon: Icon(
                                  Icons.person,
                                  color: kMaincolor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kMaincolor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kSecondaryColor, width: 1.3))),
                            style: textInputDecoration.labelStyle!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.center,
                            validator: (val) {
                              if (val!.isEmpty) {
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
                            controller: _textController,
                            decoration: textInputDecoration.copyWith(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  },
                                  color: kMaincolor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kMaincolor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kSecondaryColor, width: 1.3))),
                            style: textInputDecoration.labelStyle!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.center,
                            validator: (val) {
                              String pattern =
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              RegExp regExp = new RegExp(pattern);
                              if (val!.isEmpty) {
                                return 'Masukan Password';
                              }
                              if (!regExp.hasMatch(val)) {
                                return 'Password harus terdiri dari 8 karakter dan \n kombinasi angka dan huruf';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            obscureText: _obscure,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kMaincolor,
                            ),
                            child: Text(
                              "Login",
                              style: textInputDecoration.labelStyle!
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login();
                              }
                            },
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
            ),
          ),
        ),
      ),
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

    var res = await UserAuth().authData(data, '/login');
    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localData = await SharedPreferences.getInstance();
      localData.setString('token', json.encode(body['token']));
      localData.setString('username', json.encode(body['username']));
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      _showMsg(body['message']);
    }
    setState(() {
      loading = false;
    });
  }
}
