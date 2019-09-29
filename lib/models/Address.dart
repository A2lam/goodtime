class Address
{
  int id;
  int number;
  String street;
  String complement;
  int post_code;
  String city;
  double latitude;
  double longitude;

  Address({ this.id, this.number, this.street, this.complement, this.post_code, this.city, this.latitude, this.longitude });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      number: json['number'],
      street: json['street'],
      complement: json['complement'],
      post_code: json['post_code'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}