import 'package:flutter/material.dart';
import 'package:simuladormuscular/models/GlobalPhysiology.dart';
import 'package:simuladormuscular/models/MuscleAgent.dart';
import 'package:simuladormuscular/models/Exercise.dart';
import 'package:simuladormuscular/services/TrainingPlanGenerator.dart';
import 'package:simuladormuscular/services/Simulator.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initialGlobalPhysiology = FisiologiaGlobal(
      pesoActualKg: 70.0,
      grasaActualPorcentaje: 20.0,
    );
    final initialMuscleAgents = MuscleZone.values.map((zone) => MuscleAgent(zone: zone)).toList();
    final initialEvents = TrainingPlanGenerator.generateWeeklyPlan(
      startDate: DateTime.now(),
      goal: "hypertrophy",
      preferredExercises: Exercise.allExercises,
      dailyMacronutrients: {
        'protein': 140.0, 'carbs': 280.0, 'fats': 70.0, 'totalKcal': 2200.0
      },
      globalPhysiology: initialGlobalPhysiology,
      muscleAgents: initialMuscleAgents,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Simulator(
            currentTime: DateTime.now(),
            globalPhysiology: initialGlobalPhysiology,
            muscleAgents: initialMuscleAgents,
            initialEvents: initialEvents,
            targetBodyFat: 10.0,
            targetHypertrophy: 80.0,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Simulador de Fitness Hibrido',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SimulationSetupScreen(),
      ),
    );
  }
}

class SimulationSetupScreen extends StatefulWidget {
  const SimulationSetupScreen({super.key});

  @override
  State<SimulationSetupScreen> createState() => _SimulationSetupScreenState();
}

class _SimulationSetupScreenState extends State<SimulationSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController(text: '70');
  final TextEditingController _bodyFatController = TextEditingController(text: '20');
  final TextEditingController _targetBodyFatController = TextEditingController(text: '10');
  final TextEditingController _targetHypertrophyController = TextEditingController(text: '80');
  final TextEditingController _heightController = TextEditingController(text: '175');
  final TextEditingController _ageController = TextEditingController(text: '30');

  String _gender = 'male';
  String _goal = 'hypertrophy';

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _targetBodyFatController.dispose();
    _targetHypertrophyController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _startSimulation() {
    if (_formKey.currentState!.validate()) {
      double currentWeight = double.parse(_weightController.text);
      double currentBodyFat = double.parse(_bodyFatController.text);
      double targetBodyFat = double.parse(_targetBodyFatController.text);
      double targetHypertrophy = double.parse(_targetHypertrophyController.text);
      double heightCm = double.parse(_heightController.text);
      int ageYears = int.parse(_ageController.text);

      final initialGlobalPhysiology = FisiologiaGlobal(
        pesoActualKg: currentWeight,
        grasaActualPorcentaje: currentBodyFat,
      );
      double bmr = initialGlobalPhysiology.calculateBMR(currentWeight, heightCm, ageYears, _gender);
      double activityFactor = 1.55;

      double lbm = initialGlobalPhysiology.lbm;
      double targetWeight = FisiologiaGlobal.calculateTargetWeight(lbm, targetBodyFat);

      Map<String, double> dailyMacronutrients = FisiologiaGlobal.calculateMacronutrients(
        lbm: lbm,
        targetWeight: targetWeight,
        tmb: bmr,
        activityFactor: activityFactor,
      );

      final initialMuscleAgents = MuscleZone.values.map((zone) => MuscleAgent(
        zone: zone,
        fiberTypeFastPercentage: Random().nextDouble() * 0.4 + 0.3,
      )).toList();

      final initialEvents = TrainingPlanGenerator.generateWeeklyPlan(
        startDate: DateTime.now(),
        goal: _goal,
        preferredExercises: Exercise.allExercises,
        dailyMacronutrients: dailyMacronutrients,
        globalPhysiology: initialGlobalPhysiology,
        muscleAgents: initialMuscleAgents,
      );

      final simulator = Provider.of<Simulator>(context, listen: false);
      simulator.resetSimulation(
        initialGlobalPhysiology,
        initialMuscleAgents,
        initialEvents,
        DateTime.now(),
      );
      simulator.targetBodyFat = targetBodyFat;
      simulator.targetHypertrophy = targetHypertrophy;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SimulationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion de Simulacion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Datos Personales', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso Actual (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Por favor, introduce un peso valido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyFatController,
                decoration: const InputDecoration(
                  labelText: 'Porcentaje de Grasa Actual (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) < 5 || double.parse(value) > 50) {
                    return 'Por favor, introduce un porcentaje de grasa valido (5-50%).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Por favor, introduce una altura valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Edad (anos)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Por favor, introduce una edad valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(
                  labelText: 'Genero',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Masculino')),
                  DropdownMenuItem(value: 'female', child: Text('Femenino')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text('Objetivos de Simulacion', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              TextFormField(
                controller: _targetBodyFatController,
                decoration: const InputDecoration(
                  labelText: 'Porcentaje de Grasa Objetivo (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.track_changes),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) < 5 || double.parse(value) > 30) {
                    return 'Por favor, introduce un porcentaje de grasa objetivo valido (5-30%).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _targetHypertrophyController,
                decoration: const InputDecoration(
                  labelText: 'Hipertrofia Muscular Objetivo (0-100%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.trending_up),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) < 0 || double.parse(value) > 100) {
                    return 'Por favor, introduce un valor entre 0 y 100.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _goal,
                decoration: const InputDecoration(
                  labelText: 'Objetivo de Entrenamiento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sports_gymnastics),
                ),
                items: const [
                  DropdownMenuItem(value: 'hypertrophy', child: Text('Hipertrofia (Volumen)')),
                  DropdownMenuItem(value: 'hiit', child: Text('HIIT (Definicion)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _goal = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _startSimulation,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Simulacion'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = duration.inDays > 0 ? "${duration.inDays} dias, " : "";
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days$hours:$minutes:$seconds";
  }

  String _formatMuscleZoneName(String name) {
    String formatted = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim();
    return formatted.split(' ').map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulacion en Curso'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<Simulator>(
        builder: (context, simulator, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiempo Simulado: ${_formatDuration(simulator.simulationDuration)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (simulator.simulationFinished)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Objetivos Alcanzados en ${_formatDuration(simulator.simulationDuration)}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                Text('Fisiologia Global', style: Theme.of(context).textTheme.titleMedium),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peso Actual: ${simulator.globalPhysiology.pesoActualKg.toStringAsFixed(2)} kg'),
                        Text('Grasa Corporal: ${simulator.globalPhysiology.grasaActualPorcentaje.toStringAsFixed(2)} % (Objetivo: ${simulator.targetBodyFat.toStringAsFixed(1)}%)'),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: simulator.globalPhysiology.grasaActualPorcentaje.clamp(0.0, 50.0) / 50.0,
                            color: Colors.red.shade700,
                            backgroundColor: Colors.red.shade100,
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Balance Energetico: ${simulator.globalPhysiology.balanceEnergetico.toStringAsFixed(0)} kcal'),
                        Text('Testosterona: ${simulator.globalPhysiology.nivelTestosterona.toStringAsFixed(2)}'),
                        Text('Cortisol: ${simulator.globalPhysiology.nivelCortisol.toStringAsFixed(2)}'),
                        Text('Fatiga Sistemica: ${simulator.globalPhysiology.fatigaSistemica.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Crecimiento Muscular (Hipertrofia)', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: ListView.builder(
                    itemCount: simulator.muscleAgents.length,
                    itemBuilder: (context, index) {
                      final agent = simulator.muscleAgents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatMuscleZoneName(agent.zone.name)}: ${agent.hypertrophyLevel.toStringAsFixed(2)} % (Objetivo: ${simulator.targetHypertrophy.toStringAsFixed(1)}%)',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: agent.hypertrophyLevel / 100.0,
                                  color: Colors.blue.shade700,
                                  backgroundColor: Colors.blue.shade100,
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Fatiga Local: ${agent.localFatigue.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: simulator.isRunning ? simulator.pauseSimulation : simulator.startSimulation,
                      icon: Icon(simulator.isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(simulator.isRunning ? 'Pausar' : 'Iniciar Simulacion'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: simulator.isRunning ? Colors.orange.shade700 : Colors.green.shade700,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                          Navigator.pop(context);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reiniciar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
