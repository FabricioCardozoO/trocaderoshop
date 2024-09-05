import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:trocaderoshop/model/food.dart';

class FoodNotifier with ChangeNotifier {
  List<Food> _allFoods = []; // Lista completa de alimentos
  List<Food> _filteredFoods = []; // Lista filtrada de alimentos

  // Getter para la lista filtrada de alimentos
  UnmodifiableListView<Food> get foodList {
    return UnmodifiableListView(_filteredFoods);
  }

  // Setter para la lista completa de alimentos
  set foodList(List<Food> foodList) {
    _allFoods = foodList;
    _filteredFoods = foodList; // Inicialmente, no hay filtro
    notifyListeners();
  }

  // Método para filtrar alimentos por categoría
  void filterByCategory(String category) {
    if (category == 'Todos') {
      _filteredFoods = _allFoods; // Mostrar todos los alimentos si se selecciona 'Todos'
    } else {
      _filteredFoods = _allFoods.where((food) => food.category == category).toList();
    }
    notifyListeners();
  }
}
