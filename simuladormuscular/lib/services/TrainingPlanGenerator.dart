import 'package:simuladormuscular/models/GlobalPhysiology.dart';
import 'package:simuladormuscular/models/SimulationEvent.dart';
import 'package:simuladormuscular/models/MuscleAgent.dart';
import 'package:simuladormuscular/models/Exercise.dart';
import 'dart:math';

class TrainingPlanGenerator {
  static List<SimulationEvent> generateWeeklyPlan({
    required DateTime startDate,
    required String goal,
    required List<Exercise> preferredExercises,
    required Map<String, double> dailyMacronutrients,
    required FisiologiaGlobal globalPhysiology,
    required List<MuscleAgent> muscleAgents,
  }) {
    List<SimulationEvent> events = [];
    Random random = Random();

    double targetProtein = dailyMacronutrients['protein']!;
    double targetCarbs = dailyMacronutrients['carbs']!;
    double targetFats = dailyMacronutrients['fats']!;

    double mealProtein = targetProtein / 3;
    double mealCarbs = targetCarbs / 3;
    double mealFats = targetFats / 3;
    double snackProtein = targetProtein / 5;
    double snackCarbs = targetCarbs / 5;
    double snackFats = targetFats / 5;

    for (int day = 0; day < 7; day++) {
      DateTime currentDay = startDate.add(Duration(days: day));

      // DESAYUNO
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 8)),
        description: "Desayuno",
        kcalConsumed: (mealProtein * 4 + mealCarbs * 4 + mealFats * 9),
        action: (global, agents) {},
      ));

      // ALMUERZO
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 13)),
        description: "Almuerzo",
        kcalConsumed: (mealProtein * 4 + mealCarbs * 4 + mealFats * 9),
        action: (global, agents) {},
      ));

      // CENA
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 19)),
        description: "Cena",
        kcalConsumed: (mealProtein * 4 + mealCarbs * 4 + mealFats * 9),
        action: (global, agents) {},
      ));

      // SNACK 1
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 11)),
        description: "Snack 1",
        kcalConsumed: (snackProtein * 4 + snackCarbs * 4 + snackFats * 9),
        action: (global, agents) {},
      ));

      // SNACK 2
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 16)),
        description: "Snack 2",
        kcalConsumed: (snackProtein * 4 + snackCarbs * 4 + snackFats * 9),
        action: (global, agents) {},
      ));

      // ENTRENAMIENTO
      if (day % 2 == 0 && day < 6) {
        DateTime trainingTime = currentDay.add(const Duration(hours: 10));
        String trainingDescription = "Entrenamiento de ";
        List<MuscleZone> targetedZones = [];
        List<Exercise> currentWorkoutExercises = [];

        if (goal == "hypertrophy") {
          List<MuscleZone> availableZones = List.from(MuscleZone.values);
          availableZones.shuffle(random);
          targetedZones = availableZones.take(2).toList();

          for (var zone in targetedZones) {
            trainingDescription += "${zone.name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')}, ";
            List<Exercise> zoneExercises = preferredExercises
                .where((e) => e.primaryMuscles.contains(zone) && e.type == ExerciseType.fuerzaHipertrofia)
                .toList();
            zoneExercises.shuffle(random);
            currentWorkoutExercises.addAll(zoneExercises.take(min(zoneExercises.length, 3)));
          }
          trainingDescription = trainingDescription.substring(0, trainingDescription.length - 2);
        } else {
          trainingDescription = "Entrenamiento HIIT";
          currentWorkoutExercises = preferredExercises
              .where((e) => e.type == ExerciseType.hiit)
              .toList();
          currentWorkoutExercises.shuffle(random);
          currentWorkoutExercises = currentWorkoutExercises.take(min(currentWorkoutExercises.length, 5)).toList();
          targetedZones = [MuscleZone.piernasGluteos, MuscleZone.abdomenCore];
        }

        if (currentWorkoutExercises.isNotEmpty) {
          events.add(SimulationEvent(
            time: trainingTime,
            description: trainingDescription,
            kcalExpended: 300 + random.nextDouble() * 200,
            action: (global, agents) {
              for (var exercise in currentWorkoutExercises) {
                double intensity = 0.6 + random.nextDouble() * 0.3;
                double volume = 8.0 + random.nextDouble() * 5.0;

                for (var muscleZone in exercise.primaryMuscles) {
                  var agent = agents.firstWhere((a) => a.zone == muscleZone);
                  agent.applyStimulus(intensity, volume, exercise.type);
                }
                for (var muscleZone in exercise.secondaryMuscles) {
                  var agent = agents.firstWhere((a) => a.zone == muscleZone);
                  agent.applyStimulus(intensity * 0.5, volume * 0.5, exercise.type);
                }
              }
              global.fatigaSistemica += 0.15;
              global.nivelCortisol += 0.05;
            },
          ));
        }
      }

      // SUEÑO
      events.add(SimulationEvent(
        time: currentDay.add(const Duration(hours: 22)),
        description: "Descanso/Sueno",
        kcalExpended: globalPhysiology.calculateBMR(globalPhysiology.pesoActualKg, 170, 30, 'male') / 24 * 8,
        action: (global, agents) {
          double sleepQuality = 0.8 + random.nextDouble() * 0.2;
          global.update(0.33, 0, 0, sleepQuality);
          global.fatigaSistemica = (global.fatigaSistemica * 0.5).clamp(0.0, 1.0);
          global.nivelCortisol = (global.nivelCortisol * 0.8).clamp(0.1, 1.0);
        },
      ));
    }
    events.sort((a, b) => a.time.compareTo(b.time));
    return events;
  }
}
