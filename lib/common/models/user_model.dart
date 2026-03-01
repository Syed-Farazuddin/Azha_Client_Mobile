class User {
  int? id;
  String? name;
  String? email;
  int? age;

  User({
    required this.age,
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }
}
