import 'package:flutter/services.dart' show rootBundle;

class PO {
  String? poNo;
  String? barang;
  int? qty;

  PO({this.poNo, this.barang, this.qty});

  PO.fromJson(Map<String, dynamic> json)
      : poNo = json["PO_no"],
        barang = json["barang"],
        qty = json["qty"];
}

class POResponse {
  final List<PO> po;

  POResponse(this.po);

  POResponse.fromJson(Map<String, dynamic> json)
      : po = (json["articles"] as List).map((i) => new PO.fromJson(i)).toList();
}

Future<String> getJson() {
  return rootBundle.loadString('assets/jajal.json');
}
