import 'package:flutter/material.dart';

class ResumenScreen extends StatelessWidget {
  final int totalDays;
  final double finalBodyFatPercentage;
  final double targetBodyFatPercentage;
  final List<Map<String, dynamic>> muscleResults;
  final List<String> performedWorkoutsLog;

  const ResumenScreen({
    Key? key,
    required this.totalDays,
    required this.finalBodyFatPercentage,
    required this.targetBodyFatPercentage,
    required this.muscleResults,
    required this.performedWorkoutsLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de la Simulacion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simulacion Finalizada!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Duracion total: $totalDays dias',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Grasa Corporal Final: ${finalBodyFatPercentage.toStringAsFixed(2)}% (Objetivo: ${targetBodyFatPercentage.toStringAsFixed(2)}%)',
              style: TextStyle(
                fontSize: 18,
                color: finalBodyFatPercentage <= targetBodyFatPercentage ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultados de Hipertrofia Muscular:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...muscleResults.map((result) {
              final String zone = result['zone'];
              final double hypertrophy = result['hypertrophy'];
              final bool achieved = result['achieved'];
              final double target = result['targetHypertrophy'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '- $zone: Nivel ${hypertrophy.toStringAsFixed(2)} (Objetivo: ${target.toStringAsFixed(2)}) - ${achieved ? 'ALCANZADO' : 'PENDIENTE'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: achieved ? Colors.green : Colors.orange,
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Historial de Entrenamientos Realizados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (performedWorkoutsLog.isEmpty)
              const Text('No se registraron entrenamientos.')
            else
              ...performedWorkoutsLog.map((logEntry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text('- $logEntry'),
                  )).toList(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Volver al Inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
