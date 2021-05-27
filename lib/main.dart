import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/screens/assign_rfid_screen/assign_rfid.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/login.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Warehouse',
      theme: themePP,
      home: LoginScreen(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  AuthCheckState createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLogin();
    super.initState();
  }

  void _checkIfLogin() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var token = localData.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = HomeScreen();
    } else {
      child = LoginScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}
