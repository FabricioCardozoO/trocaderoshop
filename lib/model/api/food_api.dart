import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trocaderoshop/model/food.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Alias para la importación de firebase_auth
import 'package:trocaderoshop/model/user.dart' as model;
import 'package:trocaderoshop/notifier/food_notifier.dart';
import 'package:trocaderoshop/screens/login_signup_page.dart';
import 'package:trocaderoshop/screens/navigation_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

//USER PART
login(model.User user, AuthNotifier authNotifier, BuildContext context) async {
  try {
    auth.UserCredential userCredential = await auth.FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
    
    auth.User? firebaseUser = userCredential.user;
    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
      await getUserDetails(authNotifier);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return NavigationBarPage(selectedIndex: 0);
        }),
      );
    }
  } catch (error) {
    print(error);
  }
}

signUp(model.User user, AuthNotifier authNotifier, BuildContext context) async {
  try {
    auth.UserCredential userCredential = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email!.trim(), password: user.password!);
    
    auth.User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await firebaseUser.updateDisplayName(user.displayName);
      await firebaseUser.reload();

      print("Sign Up: $firebaseUser");

      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        authNotifier.setUser(currentUser);
        uploadUserData(user, false);
        await getUserDetails(authNotifier);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return NavigationBarPage(
              selectedIndex: 0,
            );
          }),
        );
      }
    }
  } catch (error) {
    print(error);
  }
}

signOut(AuthNotifier authNotifier, BuildContext context) async {
  try {
    // Cierra la sesión del usuario
    await auth.FirebaseAuth.instance.signOut();

    // Actualiza el estado del AuthNotifier
    authNotifier.setUser(null);

    // Imprime un mensaje en la consola
    print('User signed out successfully');

    // Navega a la página de inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }),
    );
  } catch (e) {
    // Manejo de errores
    print('Error signing out: $e');
  }
}

initializeCurrentUser(AuthNotifier authNotifier, BuildContext context) async {
  auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
    await getUserDetails(authNotifier);
  }
}

uploadFoodAndImages(Food food, File localFile, BuildContext context) async {
  if (localFile != null) {
    print('uploading img file');

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$uuid$fileExtension');

    UploadTask task = firebaseStorageRef.putFile(localFile);

    TaskSnapshot taskSnapshot = await task;

    String url = await taskSnapshot.ref.getDownloadURL();
    print('dw url $url');
    _uploadFood(food, context, imageUrl: url);
  } else {
    print('skipping img upload');
    _uploadFood(food, context);
  }
}

uploadProfilePic(File localFile, model.User user) async {
  print("Entro a actualizar pic");
  print(localFile.toString());
  print(user.toString());

  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  if (localFile != null) {
    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures/$uuid$fileExtension');

    UploadTask task = firebaseStorageRef.putFile(localFile);

    TaskSnapshot taskSnapshot = await task;

    String profilePicUrl = await taskSnapshot.ref.getDownloadURL();
    print('dw url of profile img $profilePicUrl');

    try {
      user.profilePic = profilePicUrl;
      print(user.profilePic);
      await userRef.doc(currentUser!.uid).set(
          {'profilePic': user.profilePic},
          SetOptions(merge: true)).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  } else {
    print('skipping profilepic upload');
  }
}

_uploadFood(Food food, BuildContext context, {String? imageUrl}) async {
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  CollectionReference foodRef = FirebaseFirestore.instance.collection('foods');
  bool complete = true;
  print("APAAAAAAAAAAAAA2");
  print(imageUrl);

  food.createdAt = Timestamp.now();
  food.userUuidOfPost = currentUser!.uid;
  await foodRef
      .add(food.toMap())
      .catchError((e) => print(e))
      .then((value) => complete = true);

  print('uploaded food successfully');
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return NavigationBarPage(
          selectedIndex: 0,
        );
      },
    ),
  );

  return complete;
}

uploadUserData(model.User user, bool userdataUpload) async {
  print("Hola esto aqui");
  print(userdataUpload);
  print(user.toString());
  bool userDataUploadVar = userdataUpload;
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  print("Pase por aqui");
  print(currentUser.toString());
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  user.uuid = currentUser!.uid;
  if (userDataUploadVar != true) {
    await userRef
        .doc(currentUser.uid)
        .set(user.toMap())
        .catchError((e) => print(e))
        .then((value) => userDataUploadVar = true);
  } else {
    print('already uploaded user data PROBLEMASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
  }
  print('user data uploaded successfully');
}

getUserDetails(AuthNotifier authNotifier) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(authNotifier.user?.uid)
      .get()
      .catchError((e) => print(e))
      .then((value) => authNotifier.setUserDetails(model.User.fromMap(value.data()!)));
}

getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('foods')
      .orderBy('createdAt', descending: true)
      .get();

  List<Food> foodList = [];

  await Future.forEach(snapshot.docs, (QueryDocumentSnapshot doc) async {
    Food food = Food.fromMap(doc.data() as Map<String, dynamic>);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(doc['userUuidOfPost'])
        .get()
        .catchError((e) => print(e))
        .then((value) {
      food.userName = value.data()!['displayName'];
      food.profilePictureOfUser = value.data()!['profilePic'];
    }).whenComplete(() => foodList.add(food));
  });

  if (foodList.isNotEmpty) {
    foodNotifier.foodList = foodList;
    print("dine");
    print(foodList[0].userName);
  }
}