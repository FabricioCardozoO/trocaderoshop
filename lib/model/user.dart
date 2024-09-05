import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? displayName;
  String? email;
  String? password;
  String? uuid;
  String? bio;
  String? profilePic;
  File? profileFile;
  GeoPoint? location; // Propiedad para almacenar la ubicación

  User();

  User.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    email = data['email'];
    password = data['password'];
    uuid = data['uuid'];
    bio = data['bio'];
    profilePic = data['profilePic'];
    // Asegúrate de manejar correctamente la asignación de GeoPoint desde Firestore si es necesario
    if (data['location'] != null) {
      var geoPoint = data['location'] as GeoPoint;
      location = GeoPoint(geoPoint.latitude, geoPoint.longitude);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'password': password,
      'uuid': uuid,
      'bio': bio,
      'profilePic': profilePic,
      'location': location, // Asegúrate de incluir la ubicación aquí si la necesitas guardar
    };
  }
}
