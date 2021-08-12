import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/upload_service2.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class UploadWidget extends StatelessWidget {
  final String url = 'http://192.168.18.170:7030/v1/purchase-orders';
  final List<MultipartFile> multiPartfile;
  const UploadWidget(this.multiPartfile);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<UploadProgress>(
        builder: (context, status, _) {
          var progress = status.progress.toStringAsFixed(1);

          return Container(
            height: 55,
            margin: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: kMaincolor),
              child: Text('$progress %'),
              onPressed: () =>
                  status.start(url: url, multiPartfile: multiPartfile),
            ),
          );
        },
      ),
    );
  }
}
