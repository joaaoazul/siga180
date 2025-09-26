import '../../../models/athlete_model.dart';

// Classe para encapsular resultados com sucesso ou erro
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result.success(this.data) : error = null, isSuccess = true;
  Result.error(this.error) : data = null, isSuccess = false;
}

abstract class IAthleteRepository {
  // CRUD Operations
  Future<Result<List<Athlete>>> getAllAthletes();
  Future<Result<Athlete>> getAthleteById(String id);
  Future<Result<Athlete>> createAthlete(Athlete athlete);
  Future<Result<Athlete>> updateAthlete(Athlete athlete);
  Future<Result<bool>> deleteAthlete(String id);
  
  // Query Operations
  Future<Result<List<Athlete>>> getActiveAthletes();
  Future<Result<List<Athlete>>> getInactiveAthletes();
  Future<Result<List<Athlete>>> searchAthletes(String query);
  Future<Result<List<Athlete>>> getAthletesByGoal(String goal);
  Future<Result<List<Athlete>>> getAthletesByFitnessLevel(String level);
  
  // Batch Operations
  Future<Result<List<Athlete>>> createMultipleAthletes(List<Athlete> athletes);
  Future<Result<bool>> updateMultipleAthletes(List<Athlete> athletes);
  Future<Result<bool>> deleteMultipleAthletes(List<String> ids);
  
  // Statistics
  Future<Result<Map<String, dynamic>>> getAthleteStatistics();
  Future<Result<Map<String, int>>> getAthleteCountByStatus();
  Future<Result<Map<String, int>>> getAthleteCountByGoal();
  
  // Real-time updates (Stream)
  Stream<List<Athlete>> watchAllAthletes();
  Stream<Athlete?> watchAthlete(String id);
  Stream<List<Athlete>> watchActiveAthletes();
  
  // Import/Export
  Future<Result<String>> exportAthletesToJson();
  Future<Result<List<Athlete>>> importAthletesFromJson(String json);
  Future<Result<String>> exportAthleteToCsv(String athleteId);
  
  // Cache Management
  Future<Result<bool>> clearCache();
  Future<Result<bool>> syncWithRemote();
}
        