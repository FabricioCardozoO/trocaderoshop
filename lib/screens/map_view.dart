import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:trocaderoshop/model/user.dart'; // Asegúrate de importar tu modelo de usuario

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = _currentLocation;
    });

    _getUsersLocation();
  }

  void _getUsersLocation() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    Set<Marker> markers = snapshot.docs.where((DocumentSnapshot doc) {
      User user = User.fromMap(doc.data() as Map<String, dynamic>);
      return user.location != null;
    }).map((DocumentSnapshot doc) {
      User user = User.fromMap(doc.data() as Map<String, dynamic>);
      return Marker(
        markerId: MarkerId(user.uuid!), // Usamos user.uuid como MarkerId único
        position: LatLng(user.location!.latitude, user.location!.longitude),
        infoWindow: InfoWindow(
          title: user.displayName,
          snippet: user.bio ?? '',
        ),
        onTap: () {
          _drawRoute(user.location!.latitude, user.location!.longitude);
        },
      );
    }).toSet();

    setState(() {
      _markers = markers; // Actualizar el conjunto de marcadores
    });

    // Centrar el mapa en los marcadores
    if (_markers.isNotEmpty) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList(_markers.map((marker) => marker.position).toList()), 
          50,
        ),
      );
    }
  }

  Future<void> _drawRoute(double destinationLat, double destinationLng) async {
    if (_currentLocation == null) return;

    String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=$destinationLat,$destinationLng'
        '&key=YOUR_API_KEY'; // Reemplaza con tu clave de API

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    if (json['routes'].isNotEmpty) {
      var points = _decodePoly(json['routes'][0]['overview_polyline']['points']);
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    }
  }

  List<LatLng> _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 0x20);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    List<LatLng> positions = [];
    double lat = 0;
    double lng = 0;

    for (var i = 0; i < lList.length; i++) {
      if (i % 2 == 0) {
        lat += lList[i];
      } else {
        lng += lList[i];
        positions.add(LatLng(lat, lng));
      }
    }
    return positions;
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0!) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Usuarios'),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 15.0,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
    );
  }
}
