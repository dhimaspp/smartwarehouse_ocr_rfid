class UserAuthentication {
  String? message;
  dynamic token;

  UserAuthentication({this.message, this.token});

  UserAuthentication.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        token = json['access_token'];
}
