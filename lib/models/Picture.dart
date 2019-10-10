class Picture
{
  int id;
  String name;
  String path;

  Picture({ this.id, this.name, this.path });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json["id"],
      name: json["name"],
      path: json["path"],
    );
  }
}