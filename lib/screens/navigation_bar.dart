import 'package:flutter/material.dart';
import 'package:trocaderoshop/screens/add_post.dart';
import 'package:trocaderoshop/screens/home_page.dart';
import 'package:trocaderoshop/screens/profile_page.dart';
import 'package:trocaderoshop/screens/map_view.dart';

class NavigationBarPage extends StatefulWidget {
  int selectedIndex;
  NavigationBarPage({required this.selectedIndex});
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  final List<Widget> _children = [
    HomePage(),
    ImageCapture(),
    ProfilePage(),
    MapView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trocadero'),
        backgroundColor: Color.fromRGBO(123, 30, 162, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                setState(() {
                  widget.selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Añadir producto'),
              onTap: () {
                setState(() {
                  widget.selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () {
                setState(() {
                  widget.selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Mapa'),
              onTap: () {
                setState(() {
                  widget.selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _children[widget.selectedIndex],
    );
  }
}
