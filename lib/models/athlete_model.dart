class Athlete {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final DateTime? birthDate;
  final String gender;
  final String? photoUrl;
  final double? weight;
  final double? height;
  final String? occupation;
  
  // Contacto de emergência
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelationship;
  
  // Objetivos e informações de treino
  final String goal;
  final String fitnessLevel;
  final String? medicalConditions;
  final String? injuries;
  final String? medications;
  final String? allergies;
  
  // Métricas
  final double? bodyFatPercentage;
  final double? muscleMass;
  final Map<String, double>? measurements;
  
  // Status e datas
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastCheckIn;
  
  // Planos associados
  final String? currentTrainingPlanId;
  final String? currentNutritionPlanId;
  
  // Compliance e progresso
  final double? trainingCompliance;
  final double? nutritionCompliance;
  final double? weeklyProgress;
  
  // Notas
  final String? notes;
  
  // Trainer ID
  final String trainerId;

  Athlete({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.birthDate,
    required this.gender,
    this.photoUrl,
    this.weight,
    this.height,
    this.occupation,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelationship,
    required this.goal,
    required this.fitnessLevel,
    this.medicalConditions,
    this.injuries,
    this.medications,
    this.allergies,
    this.bodyFatPercentage,
    this.muscleMass,
    this.measurements,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.lastCheckIn,
    this.currentTrainingPlanId,
    this.currentNutritionPlanId,
    this.trainingCompliance,
    this.nutritionCompliance,
    this.weeklyProgress,
    this.notes,
    required this.trainerId,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      gender: json['gender'] ?? 'other',
      photoUrl: json['photo_url'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      occupation: json['occupation'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      emergencyContactRelationship: json['emergency_contact_relationship'] as String?,
      goal: json['goal'] ?? 'general',
      fitnessLevel: json['fitness_level'] ?? 'beginner',
      medicalConditions: json['medical_conditions'] as String?,
      injuries: json['injuries'] as String?,
      medications: json['medications'] as String?,
      allergies: json['allergies'] as String?,
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
      measurements: json['measurements'] != null
          ? Map<String, double>.from(json['measurements'])
          : null,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      lastCheckIn: json['last_check_in'] != null 
          ? DateTime.parse(json['last_check_in']) 
          : null,
      currentTrainingPlanId: json['current_training_plan_id'] as String?,
      currentNutritionPlanId: json['current_nutrition_plan_id'] as String?,
      trainingCompliance: (json['training_compliance'] as num?)?.toDouble(),
      nutritionCompliance: (json['nutrition_compliance'] as num?)?.toDouble(),
      weeklyProgress: (json['weekly_progress'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      trainerId: json['trainer_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'photo_url': photoUrl,
      'weight': weight,
      'height': height,
      'occupation': occupation,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'emergency_contact_relationship': emergencyContactRelationship,
      'goal': goal,
      'fitness_level': fitnessLevel,
      'medical_conditions': medicalConditions,
      'injuries': injuries,
      'medications': medications,
      'allergies': allergies,
      'body_fat_percentage': bodyFatPercentage,
      'muscle_mass': muscleMass,
      'measurements': measurements,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_check_in': lastCheckIn?.toIso8601String(),
      'current_training_plan_id': currentTrainingPlanId,
      'current_nutrition_plan_id': currentNutritionPlanId,
      'training_compliance': trainingCompliance,
      'nutrition_compliance': nutritionCompliance,
      'weekly_progress': weeklyProgress,
      'notes': notes,
      'trainer_id': trainerId,
    };
  }

  // Helper methods
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
}