class Session {
  final String accessToken;

  Session({required this.accessToken});

  static fromJson(Map<String, dynamic> json) {
    return Session(accessToken: json['accessToken']);
  }
}
