import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/model/upload_response.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/ocr_screen/images_page.dart';

// ignore: non_constant_identifier_names
PDFUpload(BuildContext context, File pdfPath, String token) {
  final Dio _dio = Dio();
  String fileName = basename(pdfPath.path);

  void presentLoader(BuildContext context,
      {String text1 = 'Aguarde...',
      String text = 'Process PDF',
      String uid = '',
      bool barrierDismissible = true,
      bool error = false,
      bool willPop = true,
      bool success = false,
      List<Widget>? action,
      Widget? elevatedButton,
      required VoidCallback onPressed,
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
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text('Are you sure want to OCR PDF file $fileName?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onPressed,
                            child:
                                Text('Yes', style: TextStyle(fontSize: 16.0))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ImagesPages()));
                            },
                            child: Text('Cancel',
                                style: TextStyle(fontSize: 16.0)))
                      ],
                    )
                  ],
                ),
              ),
              actions: action,
            ),
          );
        });
  }

  return presentLoader(context, onPressed: () async {
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();
    var formdata = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        pdfPath.path,
        contentType: MediaType(
          'image',
          'pdf',
        ),
      )
    });
    var postRegister = sharedLocal.getString('ipAddress')!;
    try {
      // Response<ResponseBody> rs;
      print(
          'list data form: ${formdata.files.map((e) => e.value.filename.toString())}');
      print('print ip post image ocr : $postRegister');
      var response = await _dio.post(
        postRegister + '/v1/purchase-orders',
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
            // String? progressString;
            // setState(() {
            //   progressString =
            //       (received / total * 100).toStringAsFixed(0) + '%';
            // });

            print('progress : $progress');
            EasyLoading.showProgress(progress,
                    status: 'Uploading images to OCR')
                .whenComplete(() => EasyLoading.show(
                    status: 'Processing OCR to Text\nThis may take a while',
                    dismissOnTap: false,
                    indicator: Center(
                        // heightFactor: MediaQuery.of(context).size.height,
                        child: SpinKitRipple(
                      color: Colors.white,
                      // size: 80,
                    ))));
            print((received / total * 100).toStringAsFixed(0) + '%');
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

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } on DioError catch (error) {
      if (error.type == DioErrorType.response) {
        String errorMessage;
        // UploadPOResponse.fromJson(error.response!.data);
        var resError = UploadPOResponse.fromJson(error.response!.data);
        errorMessage = resError.message!;
        EasyLoading.showError('Error: ${errorMessage.toString()}',
            duration: Duration(seconds: 15), dismissOnTap: true);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ImagesPages()));

      print("Exception occured:$error");
      return;
    }
  });
}
