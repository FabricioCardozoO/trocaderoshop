import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/notifier/auth_notifier.dart';
import 'package:trocaderoshop/notifier/food_notifier.dart';
import 'package:trocaderoshop/screens/navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier); // Llama a tu método para obtener todos los alimentos
  }

  final List<Map<String, String>> categories = [
    {'icon': 'images/icons/Descuentos.png', 'name': 'Descuentos'},
    {'icon': 'images/icons/agro.png', 'name': 'Agro'},
    {'icon': 'images/icons/AlquileryDonaciondejuguetes.png', 'name': 'Juguetes'},
    {'icon': 'images/icons/animales.png', 'name': 'Animales'},
    {'icon': 'images/icons/antiguedades.png', 'name': 'Antiguedades'},
    {'icon': 'images/icons/arte.png', 'name': 'Arte'},
    {'icon': 'images/icons/bebes.png', 'name': 'Bebes'},
    {'icon': 'images/icons/bebidas.png', 'name': 'Bebidas'},
    {'icon': 'images/icons/belleza.png', 'name': 'Belleza'},
    {'icon': 'images/icons/consolas.png', 'name': 'Consolas'},
    {'icon': 'images/icons/deportes.png', 'name': 'Deportes'},
    {'icon': 'images/icons/diversion.png', 'name': 'Diversion'},
    {'icon': 'images/icons/educativo.png', 'name': 'Educativo'},
    {'icon': 'images/icons/HotelesAlojamientos.png', 'name': 'Alojamientos'},
    {'icon': 'images/icons/instrumentos.png', 'name': 'Instrumentos'},
    {'icon': 'images/icons/juguetes.png', 'name': 'Juguetes'},
    {'icon': 'images/icons/libros.png', 'name': 'Libros'},
    {'icon': 'images/icons/regalos.png', 'name': 'Regalos'},
    {'icon': 'images/icons/Restaurante.png', 'name': 'Restaurante'},
    {'icon': 'images/icons/ropa.png', 'name': 'Ropa'},
    {'icon': 'images/icons/salud.png', 'name': 'Salud'},
    {'icon': 'images/icons/tecnologia.png', 'name': 'Tecnología'},
    {'icon': 'images/icons/servicios_tecnicos.png', 'name': 'Servicios técnicos'},
    {'icon': 'images/icons/servicios_tecnicos.png', 'name': 'Todos'}, // Agregando la opción 'Todos'
  ];

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: authNotifier.user != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return NavigationBarPage(selectedIndex: 0);
                              },
                            ),
                          );
                        },
                        child: GradientText(
                          "Trocadero",
                          colors: [
                            Color.fromRGBO(123, 30, 162, 1),
                            Color.fromRGBO(123, 30, 162, 1),
                          ],
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'MuseoModerno',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'Trocadero',
                            applicationVersion: 'por Camilo Cano\n\nV1.0',
                          );
                        },
                        child: Icon(Icons.info_outline),
                      ),
                    ],
                  )
                : Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          
          foodNotifier.foodList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: foodNotifier.foodList.length,
                    itemBuilder: (context, index) {
                      var foodItem = foodNotifier.foodList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Row(
                            children: <Widget>[
                              // Imagen
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: foodItem.img != null
                                        ? NetworkImage(foodItem.img!)
                                        : AssetImage('images/uploadFoodImageOnPost.png') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: foodItem.img == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color.fromRGBO(255, 63, 111, 1),
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 10),
                              // Información
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        foodItem.name!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Categoría: ${foodItem.category}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Precio: \$${foodItem.price?.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Cantidad: ${foodItem.quantity}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text('No hay alimentos en esta categoría.'),
                ),
        ],
      ),
    );
  }
}
