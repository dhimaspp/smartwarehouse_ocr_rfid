class TagModel {
  String? message;
  DataTag? data;
  Errors? errors;

  TagModel({this.message, this.data});

  TagModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new DataTag.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  TagModel.withError(Map<String, dynamic> json) {
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
  }
  Map<String, dynamic> errorToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    return data;
  }
}

// class Error {
//   Errors errors;

//   Error({this.errors});

//   Error.fromJson(Map<String, dynamic> json) {
//     errors =
//         json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.errors != null) {
//       data['errors'] = this.errors.toJson();
//     }
//     return data;
//   }
// }

class Errors {
  Uid? uid;

  Errors({this.uid});

  Errors.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] != null ? new Uid.fromJson(json['uid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uid != null) {
      data['uid'] = this.uid!.toJson();
    }
    return data;
  }
}

class Uid {
  String? message;

  Uid({this.message});

  Uid.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class DataTag {
  String? uid;
  int? swhPoItemId;

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
