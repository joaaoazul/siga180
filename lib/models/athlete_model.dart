import 'package:freezed_annotation/freezed_annotation.dart';

part 'athlete.freezed.dart';
part 'athlete.g.dart';

@freezed
class Athlete with _$Athlete {
  const factory Athlete({
    required String id,
    required String name,
    required String email,
    String? phone,
    DateTime? birthDate,
    required Gender gender,
    String? photoUrl,
    double? weight,
    double? height,
    String? occupation,
    
    // Contacto de emergência
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
    
    // Objetivos e informações de treino
    required TrainingGoal goal,
    required FitnessLevel fitnessLevel,
    String? medicalConditions,
    String? injuries,
    String? medications,
    String? allergies,
    
    // Métricas
    double? bodyFatPercentage,
    double? muscleMass,
    Map<String, double>? measurements, // chest, waist, hips, etc.
    
    // Status e datas
    required AthleteStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? lastCheckIn,
    
    // Planos associados
    String? currentTrainingPlanId,
    String? currentNutritionPlanId,
    
    // Compliance e progresso
    double? trainingCompliance,
    double? nutritionCompliance,
    double? weeklyProgress,
    
    // Notas
    String? notes,
  }) = _Athlete;

  factory Athlete.fromJson(Map<String, dynamic> json) => _$AthleteFromJson(json);
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

enum TrainingGoal {
  @JsonValue('muscle_gain')
  muscleGain,
  @JsonValue('fat_loss')
  fatLoss,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('performance')
  performance,
  @JsonValue('endurance')
  endurance,
  @JsonValue('strength')
  strength,
  @JsonValue('recomposition')
  recomposition,
}

enum FitnessLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
  @JsonValue('athlete')
  athlete,
}

enum AthleteStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('pending')
  pending,
  @JsonValue('suspended')
  suspended,
}

// Extension methods para facilitar o uso
extension AthleteExtensions on Athlete {
  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return '??';
    if (parts.length == 1) return parts[0].substring(0, 2).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
  
  double? get bmi {
    if (weight == null || height == null || height == 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }
  
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return 'Desconhecido';
    if (bmiValue < 18.5) return 'Baixo peso';
    if (bmiValue < 25) return 'Peso normal';
    if (bmiValue < 30) return 'Sobrepeso';
    if (bmiValue < 35) return 'Obesidade Grau I';
    if (bmiValue < 40) return 'Obesidade Grau II';
    return 'Obesidade Grau III';
  }
  
  bool get hasActivePlan => currentTrainingPlanId != null || currentNutritionPlanId != null;
  
  bool get isHighCompliance => 
      (trainingCompliance ?? 0) >= 80 && (nutritionCompliance ?? 0) >= 80;
}