class Qoute {
  late String qoute;
  Qoute.fromjson(Map<String, dynamic> json) {
    qoute = json['quote'];
  }
}
