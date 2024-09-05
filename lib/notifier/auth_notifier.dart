import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Alias para la importación de firebase_auth
import 'package:trocaderoshop/model/user.dart' as model; // Alias para la importación de tu modelo de usuario

class AuthNotifier extends ChangeNotifier {
  auth.User? _user; // Permitir que _user pueda ser null

  auth.User? get user => _user; // Permitir que el getter devuelva null

  void setUser(auth.User? user) { // Permitir que el setter acepte null
    _user = user;
    notifyListeners();
  }

  // Test
  model.User? _userDetails; // Permitir que _userDetails pueda ser null

  model.User? get userDetails => _userDetails; // Permitir que el getter devuelva null

  void setUserDetails(model.User? user) { // Permitir que el setter acepte null
    _userDetails = user;
    notifyListeners();
  }
}
