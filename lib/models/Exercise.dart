enum MuscleZone {
  piernasGluteos,
  espalda,
  pecho,
  hombros,
  brazos,
  abdomenCore,
}

enum ExerciseType {
  fuerzaHipertrofia,
  cardiovascular,
  hiit,
}

class Exercise {
  final String name;
  final ExerciseType type;
  final List<MuscleZone> primaryMuscles;
  final List<MuscleZone> secondaryMuscles;

  Exercise({
    required this.name,
    required this.type,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
  });

  static final List<Exercise> allExercises = [
    // PIERNAS & GLUTEOS
    Exercise(name: "Prensa de piernas", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Extension de piernas (maquina)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Curl de piernas acostado/sentado", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Maquina de abductores/aductores", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Hack Squat (maquina)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Maquina de pantorrillas (de pie/sentado)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Bulgarian Split Squat", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.piernasGluteos]),

    // ESPALDA
    Exercise(name: "Remo con polea baja (maquina)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.espalda], secondaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Jalon al pecho (polea alta)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.espalda], secondaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Maquina de remo sentado", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.espalda], secondaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Pull-over en maquina", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.espalda], secondaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Hiperextension lumbar", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.espalda]),

    // PECHO
    Exercise(name: "Press de pecho con maquina (horizontal/inclinado)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.pecho], secondaryMuscles: [MuscleZone.hombros, MuscleZone.brazos]),
    Exercise(name: "Pec-deck (maquina de mariposa)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.pecho, MuscleZone.hombros]),
    Exercise(name: "Press de pecho con poleas (cruce de cables)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.pecho], secondaryMuscles: [MuscleZone.hombros]),
    Exercise(name: "Maquina de flexiones asistidas", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.pecho, MuscleZone.hombros, MuscleZone.brazos]),

    // HOMBROS
    Exercise(name: "Press militar en maquina (sentado)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.hombros], secondaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Elevaciones laterales en maquina", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.hombros]),
    Exercise(name: "Face-pull en polea", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.hombros, MuscleZone.espalda]),
    Exercise(name: "Maquina de encogimientos", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.hombros]),

    // BRAZOS
    Exercise(name: "Curl de biceps en maquina (Scott o predicador)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Extension de triceps en polea alta", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Maquina de triceps (patada inversa)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.brazos]),
    Exercise(name: "Curl de biceps con agarre martillo (en polea)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.brazos]),

    // ABDOMEN & CORE
    Exercise(name: "Maquina de abdominales (crunch sentado)", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.abdomenCore]),
    Exercise(name: "Rotacion de torso con polea", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.abdomenCore]),
    Exercise(name: "Elevacion de piernas colgado", type: ExerciseType.fuerzaHipertrofia, primaryMuscles: [MuscleZone.abdomenCore]),

    // CARDIOVASCULARES
    Exercise(name: "Cinta de correr", type: ExerciseType.cardiovascular, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Eliptica", type: ExerciseType.cardiovascular, primaryMuscles: [MuscleZone.piernasGluteos, MuscleZone.brazos, MuscleZone.espalda]),
    Exercise(name: "Bicicleta estatica/spinning", type: ExerciseType.cardiovascular, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Escaladora (StairMaster)", type: ExerciseType.cardiovascular, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Remo (maquina de rowing)", type: ExerciseType.cardiovascular, primaryMuscles: [MuscleZone.espalda, MuscleZone.piernasGluteos, MuscleZone.brazos]),

    // CARDIO HIIT
    Exercise(name: "Burpees", type: ExerciseType.hiit, primaryMuscles: [MuscleZone.piernasGluteos, MuscleZone.pecho, MuscleZone.hombros, MuscleZone.abdomenCore]),
    Exercise(name: "Saltos al cajon (box jumps)", type: ExerciseType.hiit, primaryMuscles: [MuscleZone.piernasGluteos]),
    Exercise(name: "Battle ropes (cuerdas de guerra)", type: ExerciseType.hiit, primaryMuscles: [MuscleZone.brazos, MuscleZone.hombros, MuscleZone.abdomenCore]),
    Exercise(name: "Jumping jacks con pesas", type: ExerciseType.hiit, primaryMuscles: [MuscleZone.piernasGluteos, MuscleZone.hombros]),
  ];
}
