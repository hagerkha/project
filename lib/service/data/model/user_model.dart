class UserModel {
  final String email;
  final String? name;
  final String? imgUrl;
  final String id;

  UserModel({
    required this.email,
    this.name,
    this.imgUrl,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'imgUrl': imgUrl,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'],
      imgUrl: map['imgUrl'],
      id: map['id'] ?? '',
    );
  }
}