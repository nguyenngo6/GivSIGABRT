
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String imageUrl;
  int level;
  String phone;
  String id;

  User({
    this.username,
    this.email,
    this.imageUrl,
    this.level,
    this.phone,
    this.id,
  });

  User.fromData(Map<String, dynamic> data)
      : username = data['username'],
        id = data['id'],
        imageUrl = data['imageUrl'],
        level = data['level'],
        phone = data['phone'],
        email = data['email'];

  User.fromSnapshot(DocumentSnapshot snapShot) :
        username = snapShot['username'],
        id = snapShot['id'],
        imageUrl = snapShot['imageUrl'],
        level = snapShot['level'],
        phone = snapShot['phone'],
        email = snapShot['email'];


}