import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:trocaderoshop/screens/landing_page.dart';
import 'package:trocaderoshop/model/user.dart';
import 'package:provider/provider.dart';

enum AuthMode { SignUp, Login }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  User _user = User();
  bool isSignedIn = false;

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    super.initState();
  }

  void _submitForm() {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    _formkey.currentState!.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier, context);
    } else {
      signUp(_user, authNotifier, context);
    }
  }

  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 120,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "Email is required";
                print('Email is required');
              }
              return null;
            },
            onSaved: (String? value) {
              _user.email = value;
            },
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Correo',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.email,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), //EMAIL TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            obscureText: true,
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "Password is required";
                print("Password is required");
              }
              return null;
            },
            onSaved: (String? value) {
              _user.password = value;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Contraseña',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), //PASSWORD TEXT FIELD
        SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Iniciar Sesión",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), //LOGIN BUTTON
        SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿No eres usuario registrado?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _authMode = AuthMode.SignUp;
                });
              },
              child: Container(
                child: Text(
                  'Registrate aquí',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUPForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "User name is required";
                print("User name is required");
              }
              return null;
            },
            onSaved: (String? value) {
              _user.displayName = value;
            },
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Nombre de usuario',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.account_circle,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "Email is required";
                print("Email is required");
              }
              return null;
            },
            onSaved: (String? value) {
              _user.email = value;
            },
            keyboardType: TextInputType.emailAddress,
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Correo',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.email,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), //EMAIL TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            obscureText: true,
            controller: _passwordController,
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "Password is required";
                print("Password is required");
              }
              return null;
            },
            onSaved: (String? value) {
              _user.password = value;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Contraseña',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), //PASSWORD TEXT FIELD
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              if (value!.isEmpty) {
//                return "Confirm password is required";
                print("Confirm password is required");
              }
              if (_passwordController.text != value) {
//                return "Write Correct Password";
                print("Write Correct Password");
              }
              return null;
            },
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Color.fromRGBO(123, 30, 162, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Confirmar contraseña',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ), // RE-PASSWORD TEXT FIELD
        SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Registrarse",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(123, 30, 162, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ), //LOGIN BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿Ya eres usuario registrado?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _authMode = AuthMode.Login;
                });
              },
              child: Container(
                child: Text(
                  'Inicia Sesión',
                  style: TextStyle(
                      color: Color.fromRGBO(123, 30, 162, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LandingPage(),
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'Trocadero',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'MuseoModerno',
                      ),
                    ),
                  ),
                ),
                _authMode == AuthMode.Login
                    ? _buildLoginForm()
                    : _buildSignUPForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
