import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_assign_tag.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_delete_PO.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AssignTagCubit(),
        ),
        BlocProvider(
          create: (context) => DeletePOCubit(),
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        title: 'Smart Warehouse',
        theme: themePP,
        home: AuthCheck(),
      ),
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
    var token = localData.getString('access_token');
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
