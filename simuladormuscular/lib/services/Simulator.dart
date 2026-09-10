import 'package:simuladormuscular/models/GlobalPhysiology.dart';
import 'package:simuladormuscular/models/SimulationEvent.dart';
import 'package:simuladormuscular/models/MuscleAgent.dart';
import 'package:simuladormuscular/models/WorkoutRoutine.dart';
import 'package:simuladormuscular/models/Exercise.dart';
import 'package:flutter/material.dart';

class Simulator extends ChangeNotifier {
  DateTime currentTime;
  FisiologiaGlobal globalPhysiology;
  List<MuscleAgent> muscleAgents;
  List<SimulationEvent> eventQueue;
  bool _isRunning = false;
  bool _simulationFinished = false;
  Duration _simulationDuration = Duration.zero;
  double targetBodyFat;
  double targetHypertrophy;
  Map<MuscleZone, bool> muscleHypertrophyGoalsAchieved = {};

  final List<String> _performedWorkoutsLog = [];
  final ValueChanged<Map<String, dynamic>>? onSimulationFinished;

  Simulator({
    required this.currentTime,
    required this.globalPhysiology,
    required this.muscleAgents,
    List<SimulationEvent>? initialEvents,
    required this.targetBodyFat,
    required this.targetHypertrophy,
    this.onSimulationFinished,
  }) : eventQueue = initialEvents ?? [] {
    if (muscleAgents.isEmpty) {
      muscleAgents = [
        MuscleAgent(zone: MuscleZone.piernasGluteos),
        MuscleAgent(zone: MuscleZone.espalda),
        MuscleAgent(zone: MuscleZone.pecho),
        MuscleAgent(zone: MuscleZone.hombros),
        MuscleAgent(zone: MuscleZone.brazos),
        MuscleAgent(zone: MuscleZone.abdomenCore),
      ];
    }

    for (var agent in muscleAgents) {
      muscleHypertrophyGoalsAchieved[agent.zone] = false;
    }

    _scheduleDefaultWorkoutRoutine();
    eventQueue.sort((a, b) => a.time.compareTo(b.time));
  }

  bool get isRunning => _isRunning;
  bool get simulationFinished => _simulationFinished;
  Duration get simulationDuration => _simulationDuration;

  void _scheduleDefaultWorkoutRoutine() {
    final WorkoutRoutine defaultRoutine = WorkoutRoutine.allRoutines[0];

    DateTime workoutTime = DateTime(currentTime.year, currentTime.month, currentTime.day, 8, 0, 0);

    if (workoutTime.isBefore(currentTime)) {
      workoutTime = workoutTime.add(const Duration(days: 1));
    }

    eventQueue.add(
      SimulationEvent.workout(
        time: workoutTime,
        routine: defaultRoutine,
        muscleAgents: muscleAgents,
        globalPhysiology: globalPhysiology,
        description: "Entrenamiento de rutina diaria: ${defaultRoutine.name}",
      ),
    );
    eventQueue.sort((a, b) => a.time.compareTo(b.time));
  }

  void startSimulation() {
    if (_isRunning) return;
    _isRunning = true;
    _simulationFinished = false;
    _runSimulationLoop();
    notifyListeners();
  }

  void pauseSimulation() {
    _isRunning = false;
    notifyListeners();
  }

  void resetSimulation(FisiologiaGlobal initialGlobal, List<MuscleAgent> initialAgents, List<SimulationEvent> initialEvents, DateTime startTime) {
    _isRunning = false;
    _simulationFinished = false;
    _simulationDuration = Duration.zero;
    currentTime = startTime;
    globalPhysiology = initialGlobal;
    muscleAgents = initialAgents.map((agent) => MuscleAgent(
      zone: agent.zone,
      fiberTypeFastPercentage: agent.fiberTypeFastPercentage,
      localFatigue: 0.0,
      hypertrophyLevel: 0.0,
      stimulusHistory: [],
      hormonalSensitivity: agent.hormonalSensitivity,
    )).toList();
    eventQueue = List.from(initialEvents);

    _performedWorkoutsLog.clear();

    _scheduleDefaultWorkoutRoutine();
    eventQueue.sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

  void _resetSimulationForNextGoal() {
    _isRunning = false;
    _simulationFinished = false;
    _simulationDuration = Duration.zero;
    currentTime = DateTime.now();

    muscleAgents = muscleAgents.map((agent) {
      return MuscleAgent(
        zone: agent.zone,
        fiberTypeFastPercentage: agent.fiberTypeFastPercentage,
        localFatigue: 0.0,
        hypertrophyLevel: muscleHypertrophyGoalsAchieved[agent.zone]! ? agent.hypertrophyLevel : 0.0,
        stimulusHistory: [],
        hormonalSensitivity: agent.hormonalSensitivity,
      );
    }).toList();

    eventQueue.clear();
    _scheduleDefaultWorkoutRoutine();
    eventQueue.sort((a, b) => a.time.compareTo(b.time));

    print("Simulacion reiniciada para el siguiente objetivo muscular.");
    notifyListeners();
    startSimulation();
  }

  Future<void> _runSimulationLoop() async {
    const Duration stepSize = Duration(hours: 1);

    while (_isRunning && !_simulationFinished) {
      DateTime nextStepTime = currentTime.add(stepSize);

      bool bodyFatReached = (globalPhysiology.grasaActualPorcentaje <= targetBodyFat);
      bool allMusclesReachedHypertrophy = muscleAgents.every((agent) => muscleHypertrophyGoalsAchieved[agent.zone] == true);

      if (bodyFatReached || allMusclesReachedHypertrophy) {
        _simulationFinished = true;
        _isRunning = false;
        print("Simulacion terminada!");
        if (bodyFatReached) {
          print("Objetivo de grasa corporal alcanzado en ${simulationDuration.inDays} dias!");
        }
        if (allMusclesReachedHypertrophy) {
          print("Todos los objetivos de hipertrofia muscular alcanzados!");
        }
        notifyListeners();
        _callSimulationFinishedCallback();
        break;
      }

      while (eventQueue.isNotEmpty && (eventQueue.first.time.isBefore(nextStepTime) || eventQueue.first.time.isAtSameMomentAs(nextStepTime))) {
        SimulationEvent nextEvent = eventQueue.removeAt(0);
        if (nextEvent.time.isAfter(currentTime)) {
          currentTime = nextEvent.time;
        }

        nextEvent.action(globalPhysiology, muscleAgents);

        globalPhysiology.balanceEnergetico += nextEvent.kcalConsumed;
        globalPhysiology.balanceEnergetico -= nextEvent.kcalExpended;

        print("Evento ejecutado: ${nextEvent.description} en $currentTime");
        if (nextEvent.description.contains("Entrenamiento")) {
          _performedWorkoutsLog.add("Dia ${simulationDuration.inDays + 1}: ${nextEvent.description}");
        }
      }

      for (var agent in muscleAgents) {
        if (agent.hypertrophyLevel >= targetHypertrophy && muscleHypertrophyGoalsAchieved[agent.zone] == false) {
          muscleHypertrophyGoalsAchieved[agent.zone] = true;
          print("Hipertrofia alcanzada para ${agent.zone.toString().split('.').last} en ${simulationDuration.inDays} dias!");

          bool allGoalsMetAfterAchieved = muscleAgents.every((ag) => muscleHypertrophyGoalsAchieved[ag.zone] == true);
          if (allGoalsMetAfterAchieved && !bodyFatReached) {
            _simulationFinished = true;
            _isRunning = false;
            print("Todos los objetivos de hipertrofia muscular alcanzados!");
            notifyListeners();
            _callSimulationFinishedCallback();
            return;
          } else if (!allGoalsMetAfterAchieved) {
            _resetSimulationForNextGoal();
            notifyListeners();
            return;
          }
        }
      }

      double deltaTimeInDays = stepSize.inSeconds / (24 * 3600);

      double dailyBMR = globalPhysiology.calculateBMR(globalPhysiology.pesoActualKg, 170, 30, 'male');
      double dailyActivityExpenditure = dailyBMR * 0.3;

      double kcalConsumedThisStep = (globalPhysiology.balanceEnergetico > 0 ? dailyBMR * 1.2 : dailyBMR * 0.8) / (24 / stepSize.inHours);
      double kcalExpendedThisStep = (dailyBMR + dailyActivityExpenditure) / (24 / stepSize.inHours);

      globalPhysiology.update(deltaTimeInDays, kcalConsumedThisStep, kcalExpendedThisStep, 0.8);
      for (var agent in muscleAgents) {
        agent.update(deltaTimeInDays, globalPhysiology);
      }

      currentTime = nextStepTime;
      _simulationDuration = _simulationDuration + stepSize;

      if (currentTime.hour == 8 && currentTime.minute == 0 && currentTime.second == 0) {
        final WorkoutRoutine defaultRoutine = WorkoutRoutine.allRoutines[0];
        List<WorkoutExercise> filteredExercises = defaultRoutine.exercises.where((workoutExercise) {
          return workoutExercise.exercise.primaryMuscles.any((muscleZone) {
            return !muscleHypertrophyGoalsAchieved[muscleZone]!;
          });
        }).toList();

        WorkoutRoutine dynamicRoutine = WorkoutRoutine(
          name: defaultRoutine.name,
          exercises: filteredExercises,
        );

        if (dynamicRoutine.exercises.isNotEmpty) {
          eventQueue.add(
            SimulationEvent.workout(
              time: currentTime.add(const Duration(days: 1)),
              routine: dynamicRoutine,
              muscleAgents: muscleAgents,
              globalPhysiology: globalPhysiology,
              description: "Entrenamiento de rutina diaria: ${defaultRoutine.name} (musculos restantes)",
            ),
          );
          eventQueue.sort((a, b) => a.time.compareTo(b.time));
        }
      }

      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _callSimulationFinishedCallback() {
    if (onSimulationFinished != null) {
      List<Map<String, dynamic>> muscleResultsData = muscleAgents.map((agent) {
        return {
          'zone': agent.zone.toString().split('.').last.replaceAllMapped(
                RegExp(r'([A-Z])'),
                (match) => ' ${match.group(0)!.toLowerCase()}',
              ).trim(),
          'hypertrophy': agent.hypertrophyLevel,
          'achieved': muscleHypertrophyGoalsAchieved[agent.zone] ?? false,
          'targetHypertrophy': targetHypertrophy,
        };
      }).toList();

      onSimulationFinished!({
        'totalDays': simulationDuration.inDays,
        'finalBodyFatPercentage': globalPhysiology.grasaActualPorcentaje,
        'targetBodyFatPercentage': targetBodyFat,
        'muscleResults': muscleResultsData,
        'performedWorkoutsLog': _performedWorkoutsLog,
      });
    } else {
      print("Advertencia: No se ha proporcionado un callback para onSimulationFinished.");
    }
  }
}
