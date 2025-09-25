import 'package:dartz/dartz.dart';
import '../models/athlete.dart';

abstract class IAthleteRepository {
  // CRUD Operations
  Future<Either<String, List<Athlete>>> getAllAthletes();
  Future<Either<String, Athlete>> getAthleteById(String id);
  Future<Either<String, Athlete>> createAthlete(Athlete athlete);
  Future<Either<String, Athlete>> updateAthlete(Athlete athlete);
  Future<Either<String, bool>> deleteAthlete(String id);
  
  // Query Operations
  Future<Either<String, List<Athlete>>> getActiveAthletes();
  Future<Either<String, List<Athlete>>> getInactiveAthletes();
  Future<Either<String, List<Athlete>>> searchAthletes(String query);
  Future<Either<String, List<Athlete>>> getAthletesByGoal(TrainingGoal goal);
  Future<Either<String, List<Athlete>>> getAthletesByFitnessLevel(FitnessLevel level);
  
  // Batch Operations
  Future<Either<String, List<Athlete>>> createMultipleAthletes(List<Athlete> athletes);
  Future<Either<String, bool>> updateMultipleAthletes(List<Athlete> athletes);
  Future<Either<String, bool>> deleteMultipleAthletes(List<String> ids);
  
  // Statistics
  Future<Either<String, Map<String, dynamic>>> getAthleteStatistics();
  Future<Either<String, Map<String, int>>> getAthleteCountByStatus();
  Future<Either<String, Map<TrainingGoal, int>>> getAthleteCountByGoal();
  
  // Real-time updates (Stream)
  Stream<List<Athlete>> watchAllAthletes();
  Stream<Athlete?> watchAthlete(String id);
  Stream<List<Athlete>> watchActiveAthletes();
  
  // Import/Export
  Future<Either<String, String>> exportAthletesToJson();
  Future<Either<String, List<Athlete>>> importAthletesFromJson(String json);
  Future<Either<String, String>> exportAthleteToCsv(String athleteId);
  
  // Cache Management
  Future<Either<String, bool>> clearCache();
  Future<Either<String, bool>> syncWithRemote();
}