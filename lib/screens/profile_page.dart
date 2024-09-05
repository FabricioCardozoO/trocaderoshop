import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:trocaderoshop/screens/detail_food_page.dart';
import 'package:trocaderoshop/screens/edit_profile_page.dart';
import 'package:trocaderoshop/widget/custom_raised_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> signOutUser() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      await signOut(authNotifier, context);
    }
  }

  Future<void> getUserDetails(AuthNotifier authNotifier) async {
    // Implementa la lógica para obtener detalles del usuario si es necesario
  }

  @override
  void initState() {
    super.initState();
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, right: 10),
                  child: GestureDetector(
                    onTap: signOutUser,
                    child: Icon(Icons.person_add),
                  ),
                ),
              ],
            ),
            authNotifier.userDetails?.profilePic != null
                ? CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(authNotifier.userDetails!.profilePic!),
                    backgroundColor: Colors.transparent,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    width: 100,
                    child: Icon(
                      Icons.person,
                      size: 70,
                    ),
                  ),
            SizedBox(height: 20),
            authNotifier.userDetails?.displayName != null
                ? Text(
                    authNotifier.userDetails!.displayName!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'MuseoModerno',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text("No tienes un nombre de usuario"),
            authNotifier.userDetails?.bio != null
                ? Text(
                    authNotifier.userDetails!.bio!,
                    style: TextStyle(fontSize: 15),
                  )
                : Text("Trocadero"),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return EditProfile();
                  }),
                );
              },
              child: CustomRaisedButton(buttonText: 'Editar perfil'),
            ),
            SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('foods')
                  .where('userUuidOfPost', isEqualTo: authNotifier.userDetails?.uuid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        var imgUrl = doc['img'];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Colors.grey,
                                child: imgUrl != null
                                    ? Image.network(
                                        imgUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.image,
                                        size: 50,
                                      ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return FoodDetailPage(
                                      imgUrl: imgUrl ?? '',
                                      imageName: doc['name'] ?? '',
                                      imageCaption: doc['caption'] ?? '',
                                      createdTimeOfPost: (doc['createdAt'] as Timestamp).toDate(), userName: '',
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset(
                      'images/undraw_cooking_lyxy.png',
                      fit: BoxFit.cover,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
