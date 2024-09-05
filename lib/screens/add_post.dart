import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:trocaderoshop/api/food_api.dart';
import 'package:trocaderoshop/widget/custom_raised_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trocaderoshop/model/food.dart';


class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  Food food = Food();
  late String _selectedCategory;
  List<String> _categories = [
  'Descuentos',
  'Restaurantes',
  'Hoteles y Alojamientos (Casa – Apartamento)',
  'Alquiler y Donación de juguetes',
  'Diversión, recreación y turismo',
  'Regalos',
  'Servicios educativos',
  'Agro',
  'Alimentos y Bebidas',
  'Animales y Mascotas',
  'Antigüedades y Colecciones',
  'Arte y Papelería',
  'Bebés',
  'Belleza y Cuidado Personal',
  'Consolas y Videojuegos',
  'Deportes y Fitness',
  'Instrumentos Musicales',
  'Juegos y Juguetes',
  'Libros, Revistas y Comics',
  'Ropa y Accesorios',
  'Salud y Equipamiento Médico',
  'Tecnología',
  'Servicio Técnico y/o Especializado'
];
  List<String> selectedServicios = [];
  String foodServices = '';

  final ImagePicker _picker = ImagePicker();
  late File? _imageFile;

  Future<void> _pickImage() async {
    try {
      // Mostrar un diálogo para seleccionar la fuente de la imagen
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Image Source'),
            actions: <Widget>[
              TextButton(
                child: Text('Camera'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              TextButton(
                child: Text('Gallery'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          );
        },
      );

      if (source == null) {
        // Usuario canceló la selección
        print("CANCELOOOOOO");
        return;
      }

      print("SOURCEEEEEEEEEEEE");
      print(source.toString());

      // Usar getImage() para obtener un PickedFile
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  _save() async {
    uploadFoodAndImages(food, _imageFile!, context);
  }

  void updateFoodServices() {
    food.services = selectedServicios.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nuevo Producto',
                  style: TextStyle(
                    color: Color.fromRGBO(123, 30, 162, 1),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _imageFile != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 20,
                                    child: Image.file(
                                      _imageFile!,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      child: Icon(Icons.refresh),
                                      onPressed: _clear,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  'images/uploadFoodImageOnPost.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),




                Container(
                  child: TextField(
                    onChanged: (String value) {
                      food.name = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Titulo',
                      
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (String value) {
                      food.caption = value;
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
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      food.price = double.tryParse(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Precio',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ), 
                Container(
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                    onChanged: (value) {
                      food.quantity = int.tryParse(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),  
                DropdownButton<String>(
                  hint: Text('Selecciona una categoría'),
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      // Aquí es donde asignas la categoría seleccionada a la propiedad food.category
                      food.category = newValue;
                    });
                  },
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7, // Ajusta el ancho según sea necesario
                        child: Text(
                          category,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                if (_selectedCategory == 'Descuentos') ...[
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        food.discount = double.tryParse(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Descuento',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ), 
                ] else if (_selectedCategory == 'Restaurantes') ...[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Tipo'),
                    items: ['Hotel', 'Casa', 'Apartamento', 'Habitación'].map((tipo) {
                      return DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (value) {
                      food.propertyType = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Habitaciones'),
                    items: [1, 2, 3, 4, 5, 6, 7, 8, 10, 11].map((num) {
                      return DropdownMenuItem(
                        value: num,
                        child: Text(num == 11 ? '+10' : num.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      food.rooms = value ;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  InputDecorator(
                    decoration: InputDecoration(labelText: 'Servicios'),
                    child: Wrap(
                      spacing: 8.0,
                      children: ['Wifi', 'Jacuzzi', 'Piscina', 'Garaje', 'Cocina', 'TV', 'Otros'].map((servicio) {
                        return FilterChip(
                          label: Text(servicio),
                          selected: selectedServicios.contains(servicio),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedServicios.add(servicio);
                              } else {
                                selectedServicios.remove(servicio);
                              }
                            });
                            updateFoodServices();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Fecha de ingreso'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        food.checkInTime = picked;
                      }
                    },
                    controller: TextEditingController(
                      text: food.checkInTime == null ? '' : DateFormat('yyyy-MM-dd').format(food.checkInTime!),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Fecha de salida'),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        food.checkOutTime = picked;
                      }
                    },
                    controller: TextEditingController(
                      text: food.checkOutTime == null ? '' : DateFormat('yyyy-MM-dd').format(food.checkOutTime!),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
                Center(
                  child: GestureDetector(
                    
                    onTap: () {
                      _save();
                    },
                    child: CustomRaisedButton(
                      buttonText: 'Guardar',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
