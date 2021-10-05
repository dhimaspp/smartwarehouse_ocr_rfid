class POList {
  String? message;
  List<DataPO>? data;
  Pagination? pagination;

  POList({this.message, this.data, this.pagination});

  POList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataPO>[];
      json['data'].forEach((v) {
        data!.add(new DataPO.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class DataPO {
  int? recId;
  String? poNo;
  String? poTgl;
  String? poFc;
  String? vendorNama;
  String? vendorAlamat;
  String? deliverTo;
  String? deliverAlamat;
  String? prNo;
  String? prTgl;
  String? oaNo;
  String? oaTgl;
  int? jmlQty;
  int? jmlHarga;
  int? modifiedBy;
  String? lastModified;
  String? status;

  DataPO(
      {this.recId,
      this.poNo,
      this.poTgl,
      this.poFc,
      this.vendorNama,
      this.vendorAlamat,
      this.deliverTo,
      this.deliverAlamat,
      this.prNo,
      this.prTgl,
      this.oaNo,
      this.oaTgl,
      this.jmlQty,
      this.jmlHarga,
      this.modifiedBy,
      this.lastModified,
      this.status});

  DataPO.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    poNo = json['po_no'];
    poTgl = json['po_tgl'];
    poFc = json['po_fc'];
    vendorNama = json['vendor_nama'];
    vendorAlamat = json['vendor_alamat'];
    deliverTo = json['deliver_to'];
    deliverAlamat = json['deliver_alamat'];
    prNo = json['pr_no'];
    prTgl = json['pr_tgl'];
    oaNo = json['oa_no'];
    oaTgl = json['oa_tgl'];
    jmlQty = json['jml_qty'];
    jmlHarga = json['jml_harga'];
    modifiedBy = json['modified_by'];
    lastModified = json['last_modified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['po_no'] = this.poNo;
    data['po_tgl'] = this.poTgl;
    data['po_fc'] = this.poFc;
    data['vendor_nama'] = this.vendorNama;
    data['vendor_alamat'] = this.vendorAlamat;
    data['deliver_to'] = this.deliverTo;
    data['deliver_alamat'] = this.deliverAlamat;
    data['pr_no'] = this.prNo;
    data['pr_tgl'] = this.prTgl;
    data['oa_no'] = this.oaNo;
    data['oa_tgl'] = this.oaTgl;
    data['jml_qty'] = this.jmlQty;
    data['jml_harga'] = this.jmlHarga;
    data['modified_by'] = this.modifiedBy;
    data['last_modified'] = this.lastModified;
    data['status'] = this.status;
    return data;
  }
}

class Pagination {
  String? newer;
  String? older;
  bool? hasOlder;
  bool? hasNewer;

  Pagination({this.newer, this.older, this.hasOlder, this.hasNewer});

  Pagination.fromJson(Map<String, dynamic> json) {
    newer = json['newer'];
    older = json['older'];
    hasOlder = json['hasOlder'];
    hasNewer = json['hasNewer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newer'] = this.newer;
    data['older'] = this.older;
    data['hasOlder'] = this.hasOlder;
    data['hasNewer'] = this.hasNewer;
    return data;
  }
}
