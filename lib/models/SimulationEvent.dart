import 'package:simuladormuscular/models/GlobalPhysiology.dart';
import 'package:simuladormuscular/models/Exercise.dart';
import 'package:simuladormuscular/models/MuscleAgent.dart';
import 'package:simuladormuscular/models/WorkoutRoutine.dart';

class SimulationEvent {
  final DateTime time;
  final Function(FisiologiaGlobal, List<MuscleAgent>) action;
  final String description;
  final double kcalConsumed;
  final double kcalExpended;

  SimulationEvent({
    required this.time,
    required this.action,
    required this.description,
    this.kcalConsumed = 0.0,
    this.kcalExpended = 0.0,
  });

  factory SimulationEvent.workout({
    required DateTime time,
    required WorkoutRoutine routine,
    required List<MuscleAgent> muscleAgents,
    required FisiologiaGlobal globalPhysiology,
    String description = "Entrenamiento de rutina",
  }) {
    return SimulationEvent(
      time: time,
      description: description,
      action: (globalPhys, agents) {
        double totalKcalExpended = 0.0;
        for (var workoutExercise in routine.exercises) {
          final exercise = workoutExercise.exercise;
          double baseIntensity = 0.0;
          double baseVolume = 0.0;

          if (exercise.type == ExerciseType.fuerzaHipertrofia) {
            baseIntensity = workoutExercise.intensityFactor * 0.7;
            baseVolume = workoutExercise.sets * workoutExercise.reps.toDouble() * 0.1;
          } else if (exercise.type == ExerciseType.cardiovascular || exercise.type == ExerciseType.hiit) {
            baseIntensity = workoutExercise.intensityFactor * 0.5;
            baseVolume = (workoutExercise.duration?.inMinutes ?? 0).toDouble() * 0.05;
          }

          for (var primaryZone in exercise.primaryMuscles) {
            final muscleAgent = agents.firstWhere((agent) => agent.zone == primaryZone);
            muscleAgent.applyStimulus(baseIntensity, baseVolume, exercise.type);
            totalKcalExpended += baseIntensity * baseVolume * 5.0;
          }

          for (var secondaryZone in exercise.secondaryMuscles) {
            final muscleAgent = agents.firstWhere((agent) => agent.zone == secondaryZone);
            muscleAgent.applyStimulus(baseIntensity * 0.5, baseVolume * 0.5, exercise.type);
            totalKcalExpended += baseIntensity * baseVolume * 2.5;
          }
        }
        globalPhys.addKcalExpended(totalKcalExpended);
        print("Workout '${routine.name}' completed. Total Kcal expended: $totalKcalExpended");
      },
      kcalExpended: 0.0,
    );
  }
}
