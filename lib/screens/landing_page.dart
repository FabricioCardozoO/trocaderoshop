import 'package:flutter/material.dart';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/screens/login_signup_page.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:trocaderoshop/screens/navigation_bar.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(123, 30, 162, 1),
              Color.fromRGBO(175, 0, 204, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Trocadero',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'MuseoModerno',
              ),
            ),
            Text(
              'Pensar. Hacer clic. Elegir',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 17,
                color: Color.fromRGBO(252, 188, 126, 1),
              ),
            ),
            SizedBox(
              height: 140,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return (authNotifier.user == null)
                        ? LoginPage()
                        : NavigationBarPage(selectedIndex: 0);
                  },
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Explora",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(123, 30, 162, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
