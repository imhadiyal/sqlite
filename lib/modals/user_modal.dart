class User {
  int id;
  String name;
  // String email;

  User(
      this.name
      // , this.email
      ,
      this.id);

  factory User.fromMap({required Map data}) => User(
        data['name'],
        // data['email'],
        data['id'],
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        // 'email': email,
      };
}
