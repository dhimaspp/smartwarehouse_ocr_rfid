class TagModel {
  String message;
  DataTag data;

  TagModel({this.message, this.data});

  TagModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new DataTag.fromJson(json['data']) : null;
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

class DataTag {
  String uid;
  int swhPoItemId;

  DataTag({this.uid, this.swhPoItemId});

  DataTag.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    swhPoItemId = json['swh_po_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['swh_po_item_id'] = this.swhPoItemId;
    return data;
  }
}
