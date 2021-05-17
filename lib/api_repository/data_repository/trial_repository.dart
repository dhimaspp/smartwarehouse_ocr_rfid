import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';

class TrialRepository {
  Future<POResponse> getJson() async {
    final String response = await rootBundle.loadString('assets/jajal.json');
    final data = await json.decode(response);

    return POResponse.fromJson(data);
  }

  // Future<POResponseV3> getPO() async {
  //   var trialData = json.decode(await getJson());

  //   return POResponseV3(trialData);
  // }
}
