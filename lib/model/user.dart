

class User {
  String username;
  String email;
  String imageUrl;
  int level;
  String phone;
  int points;
  String id;
  String address;

  User({
    this.username,
    this.email,
    this.imageUrl,
    this.level,
    this.phone,
    this.id,
    this.points,
    this.address
  });

  User.fromData(Map<String, dynamic> data)
      : username = data['username'],
        id = data['id'],
        imageUrl = data['imageUrl'],
        level = data['level'],
        phone = data['phone'],
        email = data['email'],
        points = data['points'],
        address = data['address'];
}