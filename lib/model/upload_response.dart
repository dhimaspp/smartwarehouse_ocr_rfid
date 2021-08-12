class UploadPOResponse {
  String message;
  DataUpload data;

  UploadPOResponse({this.message, this.data});

  UploadPOResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new DataUpload.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataUpload {
  String poNo;
  String poTgl;
  String profitCenter;
  String namaVendor;
  String alamatVendor;
  String dikirimKe;
  String dikirimKeAlamat;
  String purchaseRegulation;
  String outlineAgreement;
  List<Items> items;

  DataUpload(
      {this.poNo,
      this.poTgl,
      this.profitCenter,
      this.namaVendor,
      this.alamatVendor,
      this.dikirimKe,
      this.dikirimKeAlamat,
      this.purchaseRegulation,
      this.outlineAgreement,
      this.items});

  DataUpload.fromJson(Map<String, dynamic> json) {
    poNo = json['po_no'];
    poTgl = json['po_tgl'];
    profitCenter = json['profit_center'];
    namaVendor = json['nama_vendor'];
    alamatVendor = json['alamat_vendor'];
    dikirimKe = json['dikirim_ke'];
    dikirimKeAlamat = json['dikirim_ke_alamat'];
    purchaseRegulation = json['purchase_regulation'];
    outlineAgreement = json['outline_agreement'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['po_no'] = this.poNo;
    data['po_tgl'] = this.poTgl;
    data['profit_center'] = this.profitCenter;
    data['nama_vendor'] = this.namaVendor;
    data['alamat_vendor'] = this.alamatVendor;
    data['dikirim_ke'] = this.dikirimKe;
    data['dikirim_ke_alamat'] = this.dikirimKeAlamat;
    data['purchase_regulation'] = this.purchaseRegulation;
    data['outline_agreement'] = this.outlineAgreement;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String noLine;
  String kodeMaterial;
  String deskripsi;
  String unitOfMeasure;
  String qty;
  String harga;

  Items(
      {this.noLine,
      this.kodeMaterial,
      this.deskripsi,
      this.unitOfMeasure,
      this.qty,
      this.harga});

  Items.fromJson(Map<String, dynamic> json) {
    noLine = json['no_line'];
    kodeMaterial = json['kode_material'];
    deskripsi = json['deskripsi'];
    unitOfMeasure = json['unit_of_measure'];
    qty = json['qty'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no_line'] = this.noLine;
    data['kode_material'] = this.kodeMaterial;
    data['deskripsi'] = this.deskripsi;
    data['unit_of_measure'] = this.unitOfMeasure;
    data['qty'] = this.qty;
    data['harga'] = this.harga;
    return data;
  }
}
