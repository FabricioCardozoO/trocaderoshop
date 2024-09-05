import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:trocaderoshop/screens/navigation_bar.dart';
import 'package:trocaderoshop/widget/custom_raised_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Alias para la importación de firebase_auth
import 'package:trocaderoshop/model/user.dart' as model;

TextEditingController _editBioController = TextEditingController();
TextEditingController _editDisplayNameController = TextEditingController();
LatLng? _selectedPosition;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  model.User _user = model.User();
  late File? _profileImageFile;
  late LatLng? _currentPosition;

  Future<void> _pickImage() async {
    final XFile? selected = await ImagePicker().pickImage(source: ImageSource.gallery);

    
    setState(() {
      _profileImageFile = File(selected!.path);
    });
  }

  void _clear() {
    setState(() {
      _profileImageFile = null;
    });
  }

  Future<void> _getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();
    setState(() {
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Editar'),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Color.fromRGBO(255, 63, 111, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _profileImageFile != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: FileImage(_profileImageFile!),
                          radius: 60,
                        ),
                          TextButton(
                            child: Icon(Icons.refresh),
                            onPressed: _clear,
                          ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              width: 100,
                              child: Icon(
                                Icons.person,
                                size: 80,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              'Seleccionar imagen de perfil',
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _editDisplayNameController
                    ..text = authNotifier.userDetails!.displayName!,
                  onSaved: (String? value) {
                    _user.displayName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _editBioController
                    ..text = authNotifier.userDetails!.bio!,
                  onChanged: (String value) {
                    _user.bio = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition ?? LatLng(4.7109886, -74.072092),
                    zoom: 15,
                  ),
                  onTap: _onMapTapped,
                  markers: _selectedPosition == null
                      ? {
                          Marker(
                            markerId: MarkerId('currentLocation'),
                            position: _currentPosition ?? LatLng(0, 0),
                          ),
                        }
                      : {
                          Marker(
                            markerId: MarkerId('selectedLocation'),
                            position: _selectedPosition!,
                            draggable: true,
                            onDragEnd: (newPosition) {
                              setState(() {
                                _selectedPosition = newPosition;
                              });
                            },
                          ),
                        },
                ),
              ),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                child: CustomRaisedButton(buttonText: 'Guardar'),
                onTap: () async {
                  await uploadProfilePic(_profileImageFile!, _user);

                  _user.displayName = _editDisplayNameController.text;
                  _user.bio = _editBioController.text;
                  _user.location = GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);
                  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

                  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

                  AuthNotifier authNotifier =
                      Provider.of<AuthNotifier>(context, listen: false);

                  await userRef
                  .doc(currentUser?.uid) // Cambiado de document a doc
                  .set({
                    'bio': _user.bio,
                    'displayName': _user.displayName,
                    'location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
                  }, SetOptions(merge: true)) // Cambiado de setData a set con SetOptions para merge
                  .catchError((e) => print(e))
                  .whenComplete(() => getUserDetails(authNotifier));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return NavigationBarPage(selectedIndex: 2);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _selectedPosition = tappedPoint;
    });
  }
  
}
