import 'package:flutter/material.dart';

class User {

  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String phonenumber;

  //myFavoritePlaces
  //myPlaces
  User({
   Key Key,
   @required this.uid,
   @required this.name,
   @required this.email,
   @required this.photoURL,
    this.phonenumber,
   });
}
class UserId {
  final String uid;

  UserId({ this.uid });
}
