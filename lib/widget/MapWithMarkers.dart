import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mapa de Bogotá'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(4.7109, -74.0721), // Bogotá, Colombia
            zoom: 12,
          ),
          markers: {
            Marker(
              markerId: MarkerId('bogota'),
              position: LatLng(4.7109, -74.0721),
              infoWindow: InfoWindow(title: 'Bogotá'),
            ),
          },
        ),
      ),
    );
  }
}
