class FoodItem {
  final String name;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final double kcalPer100g;

  FoodItem({
    required this.name,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    required this.kcalPer100g,
  });

  static final List<FoodItem> proteinSources = [
    FoodItem(name: "Pechuga de pollo", proteinPer100g: 31, carbsPer100g: 0, fatsPer100g: 3.6, kcalPer100g: 165),
    FoodItem(name: "Filete de res magra", proteinPer100g: 26, carbsPer100g: 0, fatsPer100g: 15, kcalPer100g: 250),
    FoodItem(name: "Salmon", proteinPer100g: 20, carbsPer100g: 0, fatsPer100g: 13, kcalPer100g: 208),
    FoodItem(name: "Huevos (enteros)", proteinPer100g: 13, carbsPer100g: 1.1, fatsPer100g: 11, kcalPer100g: 155),
    FoodItem(name: "Atun en agua", proteinPer100g: 25, carbsPer100g: 0, fatsPer100g: 0.8, kcalPer100g: 116),
    FoodItem(name: "Queso cottage", proteinPer100g: 11, carbsPer100g: 3.4, fatsPer100g: 4.3, kcalPer100g: 98),
    FoodItem(name: "Lentejas cocidas", proteinPer100g: 9, carbsPer100g: 20, fatsPer100g: 0.4, kcalPer100g: 116),
    FoodItem(name: "Proteina en polvo (whey)", proteinPer100g: 80, carbsPer100g: 5, fatsPer100g: 5, kcalPer100g: 380),
  ];

  static final List<FoodItem> carbSources = [
    FoodItem(name: "Arroz integral", proteinPer100g: 2.7, carbsPer100g: 23, fatsPer100g: 0.9, kcalPer100g: 111),
    FoodItem(name: "Avena", proteinPer100g: 13, carbsPer100g: 67, fatsPer100g: 7, kcalPer100g: 389),
    FoodItem(name: "Quinoa", proteinPer100g: 4.4, carbsPer100g: 21, fatsPer100g: 1.9, kcalPer100g: 120),
    FoodItem(name: "Batata", proteinPer100g: 1.6, carbsPer100g: 20, fatsPer100g: 0.1, kcalPer100g: 86),
    FoodItem(name: "Pan integral", proteinPer100g: 13, carbsPer100g: 45, fatsPer100g: 3.6, kcalPer100g: 260),
    FoodItem(name: "Platano", proteinPer100g: 1.1, carbsPer100g: 23, fatsPer100g: 0.3, kcalPer100g: 89),
  ];

  static final List<FoodItem> fatSources = [
    FoodItem(name: "Aguacate", proteinPer100g: 2, carbsPer100g: 9, fatsPer100g: 15, kcalPer100g: 160),
    FoodItem(name: "Almendras", proteinPer100g: 21, carbsPer100g: 22, fatsPer100g: 49, kcalPer100g: 579),
    FoodItem(name: "Aceite de oliva", proteinPer100g: 0, carbsPer100g: 0, fatsPer100g: 100, kcalPer100g: 884),
    FoodItem(name: "Mantequilla de mani", proteinPer100g: 25, carbsPer100g: 20, fatsPer100g: 50, kcalPer100g: 588),
    FoodItem(name: "Semillas de chia", proteinPer100g: 17, carbsPer100g: 42, fatsPer100g: 31, kcalPer100g: 486),
  ];
}
