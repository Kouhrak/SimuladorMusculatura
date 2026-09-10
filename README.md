# SimuladorMusculatura

Simulador híbrido de fitness que modela la fisiología muscular y la composición corporal mediante agentes autónomos, balance energético y respuesta hormonal.

## About

SimuladorMusculatura es una aplicación Flutter que simula el proceso de hipertrofia muscular y pérdida de grasa corporal a lo largo del tiempo. Utiliza un enfoque de modelado basado en agentes donde cada zona muscular (piernas, espalda, pecho, hombros, brazos, abdomen) se comporta de forma independiente con sus propios niveles de fatiga, hipertrofia y sensibilidad hormonal.

El sistema considera factores fisiológicos reales como síntesis proteica, testosterona, cortisol, IGF-1, balance calórico y calidad del sueño para predecir resultados de entrenamiento a largo plazo.

## Quick Start

### Prerequisites

- Flutter SDK ^3.7.2
- Android Studio o VS Code con extensión de Flutter
- Dispositivo Android/emulador o iOS/simulador

### Installation

```bash
git clone https://github.com/Kouhrak/SimuladorMusculatura.git
cd SimuladorMusculatura/simuladormuscular
flutter pub get
```

### Run

```bash
flutter run
```

## Available Commands

| Command | Description |
|---------|-------------|
| `flutter run` | Ejecuta la app en modo desarrollo |
| `flutter build apk` | Genera el APK para Android |
| `flutter test` | Ejecuta los tests unitarios |
| `flutter analyze` | Analiza el código en busca de errores |

## Project Structure

```
simuladormuscular/
├── lib/
│   ├── main.dart                    # Entry point y pantallas principales (Setup + Simulación)
│   ├── resumen.dart                 # Pantalla de resumen post-simulación
│   ├── models/
│   │   ├── Exercise.dart            # Definición de ejercicios y zonas musculares
│   │   ├── FoodItem.dart            # Modelo de alimentos
│   │   ├── GlobalPhysiology.dart    # Fisiología global (peso, grasa, hormonas, BMR)
│   │   ├── MuscleAgent.dart         # Agente autónomo por zona muscular
│   │   ├── SimulationEvent.dart     # Eventos programados en la línea de tiempo
│   │   └── WorkoutRoutine.dart      # Rutinas de entrenamiento predefinidas
│   └── services/
│       ├── Simulator.dart           # Motor de simulación (bucle principal)
│       └── TrainingPlanGenerator.dart # Generador de planes de entrenamiento semanales
├── test/                            # Tests del proyecto
├── android/                         # Configuración Android
└── pubspec.yaml                     # Dependencias del proyecto
```

## Tech Stack

- **Framework**: Flutter ^3.7.2
- **State Management**: Provider ^6.1.5
- **Language**: Dart
- **Platform**: Android / iOS

## How It Works

### Agent-Based Muscle Modeling

Cada zona muscular es un `MuscleAgent` independiente con:
- **Fibra rápida/lenta** (% de fibra tipo II) — determina respuesta al estímulo
- **Nivel de hipertrofia** (0–100%) — crecimiento acumulado
- **Fatiga local** (0–1) — recuperación entre sesiones
- **Sensibilidad hormonal** — qué tan bien responde a testosterona/IGF-1

### Simulation Loop

El `Simulator` ejecuta pasos de 1 hora simulada:
1. Procesa eventos programados (comidas, entrenamientos, sueño)
2. Actualiza la fisiología global (balance calórico → cambio de peso/grasa)
3. Actualiza cada agente muscular (estímulo → hipertrofia, recuperación de fatiga)
4. Verifica si se alcanzaron los objetivos (grasa objetivo o hipertrofia objetivo)

### Hormonal Model

- **Testosterona**: mejora con sueño, se degrada con fatiga
- **Cortisol**: aumenta con fatiga, se reduce con sueño
- **IGF-1**: impulsado por síntesis proteica, reducido por fatiga
- **Síntesis proteica**: promedio anabólico neto (testosterona + IGF-1 - cortisol)

### Nutrition

Calcula macronutrientes diarios basados en:
- **Proteína**: 2.2 g/kg de masa magra (LBM)
- **Grasas**: 1.0 g/kg de peso objetivo
- **Carbohidratos**: restante para alcanzar TDEE (TMB × factor de actividad)

## Exercises

37 ejercicios predefinidos en 6 zonas musculares:

| Zona | Ejemplos |
|------|----------|
| Piernas & Glúteos | Prensa, Hack Squat, Bulgarian Split Squat |
| Espalda | Remo con polea, Jalón al pecho, Hiperextensión |
| Pecho | Press máquina, Pec-deck, Cruce de cables |
| Hombros | Press militar, Elevaciones laterales, Face-pull |
| Brazos | Curl máquina, Extensión triceps, Martillo |
| Abdomen & Core | Crunch sentado, Rotación de torso, Elevación piernas |

## Configuration

| Parámetro | Descripción | Valor por defecto |
|-----------|-------------|-------------------|
| `pesoActualKg` | Peso inicial del usuario | `70.0` |
| `grasaActualPorcentaje` | % de grasa corporal inicial | `20.0` |
| `targetBodyFat` | % de grasa objetivo | `10.0` |
| `targetHypertrophy` | % de hipertrofia objetivo por zona | `80.0` |
| `goal` | Tipo de entrenamiento | `hypertrophy` o `hiit` |

## Contributing

PRs bienvenidos. Abrir un issue primero para discutir cambios.

## License

No especificada — contactar al propietario del repositorio.
