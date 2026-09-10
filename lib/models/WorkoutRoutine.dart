import 'package:simuladormuscular/models/Exercise.dart';

class WorkoutExercise {
  final Exercise exercise;
  final int sets;
  final int reps;
  final Duration? duration;
  final double intensityFactor;

  WorkoutExercise({
    required this.exercise,
    this.sets = 3,
    this.reps = 10,
    this.duration,
    this.intensityFactor = 1.0,
  });
}

class WorkoutRoutine {
  final String name;
  final List<WorkoutExercise> exercises;

  WorkoutRoutine({required this.name, required this.exercises});

  static final List<WorkoutRoutine> allRoutines = [
    WorkoutRoutine(
      name: "Rutina Principiante Cuerpo Completo",
      exercises: [
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Prensa de piernas"), sets: 3, reps: 12, intensityFactor: 0.7),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Curl de piernas acostado/sentado"), sets: 3, reps: 15, intensityFactor: 0.6),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Jalon al pecho (polea alta)"), sets: 3, reps: 10, intensityFactor: 0.8),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Press de pecho con maquina (horizontal/inclinado)"), sets: 3, reps: 12, intensityFactor: 0.75),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Press militar en maquina (sentado)"), sets: 3, reps: 10, intensityFactor: 0.7),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Curl de biceps en maquina (Scott o predicador)"), sets: 2, reps: 15, intensityFactor: 0.6),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Extension de triceps en polea alta"), sets: 2, reps: 15, intensityFactor: 0.6),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Maquina de abdominales (crunch sentado)"), sets: 3, reps: 20, intensityFactor: 0.5),
        WorkoutExercise(exercise: Exercise.allExercises.firstWhere((e) => e.name == "Cinta de correr"), duration: Duration(minutes: 20), intensityFactor: 0.6),
      ],
    ),
  ];
}
