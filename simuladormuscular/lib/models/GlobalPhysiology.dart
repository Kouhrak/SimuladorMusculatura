class FisiologiaGlobal {
  double tasaSintesisProteicaGlobal;
  double nivelTestosterona;
  double nivelCortisol;
  double nivelIGF1;
  double balanceEnergetico;
  double fatigaSistemica;
  double pesoActualKg;
  double grasaActualPorcentaje;
  double _kcalExpended;

  double get kcalExpended => _kcalExpended;

  late double lbm;

  FisiologiaGlobal({
    this.tasaSintesisProteicaGlobal = 0.0,
    this.nivelTestosterona = 0.5,
    this.nivelCortisol = 0.5,
    this.nivelIGF1 = 0.5,
    this.balanceEnergetico = 0.0,
    this.fatigaSistemica = 0.0,
    required this.pesoActualKg,
    required this.grasaActualPorcentaje,
    double initialKcalExpended = 0.0,
  }) : _kcalExpended = initialKcalExpended {
    _calculateLBM();
  }

  void _calculateLBM() {
    lbm = pesoActualKg * (1 - grasaActualPorcentaje / 100);
  }

  static double calculateLBM(double currentWeightKg, double currentBodyFatPercentage) {
    return currentWeightKg * (1 - currentBodyFatPercentage / 100);
  }

  static double calculateTargetWeight(double lbm, double desiredBodyFatPercentage) {
    return lbm / (1 - desiredBodyFatPercentage / 100);
  }

  double calculateBMR(double weightKg, double heightCm, int ageYears, String gender) {
    if (gender.toLowerCase() == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) - 161;
    }
  }

  static Map<String, double> calculateMacronutrients({
    required double lbm,
    required double targetWeight,
    required double tmb,
    required double activityFactor,
  }) {
    double proteinGrams = 2.2 * lbm;
    double fatsGrams = 1.0 * targetWeight;

    double proteinKcal = proteinGrams * 4;
    double fatsKcal = fatsGrams * 9;

    double totalKcalTarget = tmb * activityFactor;
    double carbsKcal = totalKcalTarget - (proteinKcal + fatsKcal);
    double carbsGrams = carbsKcal / 4;

    return {
      'protein': proteinGrams,
      'fats': fatsGrams,
      'carbs': carbsGrams,
      'totalKcal': totalKcalTarget,
    };
  }

  void update(double deltaTimeInDays, double kcalConsumed, double kcalExpended, double sleepQuality) {
    balanceEnergetico = 0;
    balanceEnergetico += (kcalConsumed - kcalExpended);

    nivelTestosterona += (sleepQuality * 0.001 - fatigaSistemica * 0.0005) * deltaTimeInDays;
    nivelTestosterona = nivelTestosterona.clamp(0.1, 1.0);

    nivelCortisol += (fatigaSistemica * 0.001 - sleepQuality * 0.0005) * deltaTimeInDays;
    nivelCortisol = nivelCortisol.clamp(0.1, 1.0);

    nivelIGF1 += (tasaSintesisProteicaGlobal * 0.001 - fatigaSistemica * 0.0005) * deltaTimeInDays;
    nivelIGF1 = nivelIGF1.clamp(0.1, 1.0);

    fatigaSistemica += (kcalExpended * 0.00001 - sleepQuality * 0.0001) * deltaTimeInDays;
    fatigaSistemica = fatigaSistemica.clamp(0.0, 1.0);

    tasaSintesisProteicaGlobal = (nivelTestosterona + nivelIGF1) / 2 - nivelCortisol;
    tasaSintesisProteicaGlobal = tasaSintesisProteicaGlobal.clamp(0.0, 1.0);

    double kgChange = balanceEnergetico / 7700;
    pesoActualKg += kgChange;

    if (kgChange > 0) {
      if (tasaSintesisProteicaGlobal > 0.5) {
        grasaActualPorcentaje -= (kgChange / pesoActualKg) * 100 * 0.2;
      } else {
        grasaActualPorcentaje += (kgChange / pesoActualKg) * 100 * 0.8;
      }
    } else if (kgChange < 0) {
      if (tasaSintesisProteicaGlobal < 0.3) {
        grasaActualPorcentaje += (kgChange / pesoActualKg) * 100 * 0.2;
      } else {
        grasaActualPorcentaje += (kgChange / pesoActualKg) * 100 * 0.8;
      }
    }
    grasaActualPorcentaje = grasaActualPorcentaje.clamp(5.0, 50.0);
    _calculateLBM();
  }

  void addKcalExpended(double amount) {
    if (amount > 0) {
      _kcalExpended += amount;
      print("Added $amount kcal to total expended. New total: $_kcalExpended");
    }
  }

  double calculateBodyFatPercentage(double weightKg) {
    return 20.0;
  }
}
