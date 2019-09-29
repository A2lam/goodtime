class User
{
  int id;
  String firstname;
  String lastname;
  String phone;
  String username;
  String email;
  String password;
  String token;
  int favorite_item;
  double max_price;
  int favorite_transportation;
  int created_by;
  DateTime created_at;
  int updated_by;
  DateTime updated_at;
  bool is_active;

  User({ this.id, this.firstname, this.lastname, this.phone, this.username, this.email, this.password, this.token, this.favorite_item, this.max_price, this.favorite_transportation, this.created_by, this.created_at, this.updated_by, this.updated_at, this.is_active });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      favorite_item: json['favorite_item'],
      max_price: json['max_price'],
      favorite_transportation: json['favorite_transportation'],
      created_by: json['created_by'],
      created_at: json['created_at'],
      updated_by: json['updated_by'],
      updated_at: json['updated_at'],
      is_active: json['is_active'],
    );
  }
}