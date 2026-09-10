import 'package:simuladormuscular/models/Exercise.dart';
import 'package:simuladormuscular/models/GlobalPhysiology.dart';

class MuscleAgent {
  final MuscleZone zone;
  double fiberTypeFastPercentage;
  double localFatigue;
  double hypertrophyLevel;
  List<Map<String, dynamic>> stimulusHistory;
  double hormonalSensitivity;

  MuscleAgent({
    required this.zone,
    this.fiberTypeFastPercentage = 0.5,
    this.localFatigue = 0.0,
    this.hypertrophyLevel = 0.0,
    this.stimulusHistory = const [],
    this.hormonalSensitivity = 1.0,
  });

  void applyStimulus(double intensity, double volume, ExerciseType type) {
    localFatigue += (intensity * volume * 0.005);
    if (localFatigue > 1.0) localFatigue = 1.0;

    double hypertrophyStim = (intensity * volume * 0.5);
    if (type == ExerciseType.fuerzaHipertrofia) {
      hypertrophyLevel += hypertrophyStim * fiberTypeFastPercentage;
    } else {
      hypertrophyLevel += hypertrophyStim * (1 - fiberTypeFastPercentage);
    }
    hypertrophyLevel = hypertrophyLevel.clamp(0.0, 100.0);

    stimulusHistory.add({'date': DateTime.now(), 'intensity': intensity, 'volume': volume, 'type': type.name});
  }

  void update(double deltaTime, FisiologiaGlobal globalPhysiology) {
    localFatigue -= (0.1 * deltaTime);
    if (localFatigue < 0.0) localFatigue = 0.0;

    double anabolicFactor = (globalPhysiology.nivelTestosterona + globalPhysiology.nivelIGF1) / 2 - globalPhysiology.nivelCortisol;
    anabolicFactor = anabolicFactor.clamp(0.0, 1.0);

    if (anabolicFactor > 0.1 && localFatigue < 0.7) {
      hypertrophyLevel += (hypertrophyLevel * hormonalSensitivity * anabolicFactor * deltaTime * 0.005);
    }
    hypertrophyLevel = hypertrophyLevel.clamp(0.0, 100.0);
  }
}
