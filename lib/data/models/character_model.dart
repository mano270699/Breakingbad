class Character {
  late int charId;
  late String name;
  late String birthday;
  late List<dynamic> occupation;
  late String img;
  late String status;
  late String nickname;
  late List<dynamic> appearance;
  late String portrayed;
  late String category;
  late List<dynamic> betterCallSaulAppearance;
  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    birthday = json['birthday'];
    img = json['img'];
    status = json['status'];
    nickname = json['nickname'];
    portrayed = json['portrayed'];
    category = json['category'];
    appearance = json['appearance'];
    occupation = json['occupation'];
    betterCallSaulAppearance = json['better_call_saul_appearance'];
  }
}
