import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class IPSetting extends StatefulWidget {
  const IPSetting({Key? key}) : super(key: key);

  @override
  _IPSettingState createState() => _IPSettingState();
}

class _IPSettingState extends State<IPSetting> {
  String? ipAddress;
  final _textController = TextEditingController();

  final formKey2 = GlobalKey<FormState>();
  String? currentIP;
  bool _isEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadIP();
  }

  _loadIP() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var data = localData.getString('ipAddress')!;
    print('current ip: $data');
    setState(() {
      currentIP = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: kFillColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(18))),
                ),
                Positioned(
                    top: 40,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 52,
                    left: 50,
                    child: Text(
                      'Setup IP or Web Address',
                      style: textInputDecoration.labelStyle!
                          .copyWith(color: Colors.white),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Text(
                'Current IP or Web Address:\n$currentIP',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 50,
              child: Form(
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
                        ? 'Number must be at least 6 digits'
                        : // return an error message
                        null;

                    // value!.length < 8
                    //     ? _isEnable = false
                    //     : _isEnable = true;
                  },
                  controller: _textController,
                  cursorColor: kFillColor,
                  decoration: textInputDecoration.copyWith(
                      labelText: "IP or Web address",
                      labelStyle: textInputDecoration.labelStyle!
                          .copyWith(color: Colors.black54, fontSize: 16),
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
                ),
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
                onPressed: _isEnable
                    ? () async {
                        SharedPreferences localData =
                            await SharedPreferences.getInstance();
                        print('saving ip ${_textController.text}');
                        localData.setString('ipAddress', _textController.text);
                        setState(() {
                          currentIP = _textController.text;
                        });
                      }
                    : null)
          ],
        ),
      ),
    );
  }
}
