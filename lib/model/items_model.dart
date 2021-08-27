class ItemsPOModel {
  String message;
  List<DataItem> data;

  ItemsPOModel({this.message, this.data});

  ItemsPOModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataItem>[];
      json['data'].forEach((v) {
        data.add(new DataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataItem {
  int recId;
  String poNo;
  int noLine;
  String kodeMaterial;
  String deskripsi;
  String uom;
  int qty;
  int harga;
  int modifiedBy;
  String lastModified;
  List<Rfids> rfids;
  int countTagged;

  DataItem(
      {this.recId,
      this.poNo,
      this.noLine,
      this.kodeMaterial,
      this.deskripsi,
      this.uom,
      this.qty,
      this.harga,
      this.modifiedBy,
      this.lastModified});

  DataItem.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    poNo = json['po_no'];
    noLine = json['no_line'];
    kodeMaterial = json['kode_material'];
    deskripsi = json['deskripsi'];
    uom = json['uom'];
    qty = json['qty'];
    harga = json['harga'];
    modifiedBy = json['modified_by'];
    lastModified = json['last_modified'];
    if (json['rfids'] != null) {
      rfids = <Rfids>[];
      json['rfids'].forEach((v) {
        rfids.add(new Rfids.fromJson(v));
      });
    }
    countTagged = json['count_tagged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['po_no'] = this.poNo;
    data['no_line'] = this.noLine;
    data['kode_material'] = this.kodeMaterial;
    data['deskripsi'] = this.deskripsi;
    data['uom'] = this.uom;
    data['qty'] = this.qty;
    data['harga'] = this.harga;
    data['modified_by'] = this.modifiedBy;
    data['last_modified'] = this.lastModified;
    if (this.rfids != null) {
      data['rfids'] = this.rfids.map((v) => v.toJson()).toList();
    }
    data['count_tagged'] = this.countTagged;
    return data;
  }
}

class Rfids {
  String uid;

  Rfids({this.uid});

  Rfids.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    return data;
  }
}
