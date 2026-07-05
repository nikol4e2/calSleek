import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class ExerciseService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<List> getAllExercises() async {
    final token = await Storage.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/exercise")
      , headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Failed to load exercises");
  }

  Future<List> searchExercises(String q) async {
    final res = await http.get(
      Uri.parse("$baseUrl/exercise?search=$q"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return [];
  }

  Future<void> addExercise(int macrosId, Map<String, dynamic> body) async {
    final token = await Storage.getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/daily-macros/$macrosId/exercises"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to add exercise");
    }
  }

  Future<void> updateExercise(
      int macrosId,
      int logId,
      int minutes,
      ) async {
    final token = await Storage.getToken();

    final res = await http.patch(
      Uri.parse("$baseUrl/daily-macros/$macrosId/exercises/$logId?duration=$minutes"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to update exercise");

    }
  }

  Future<void> deleteExercise(int macrosId, int logId) async {
    final token = await Storage.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/daily-macros/$macrosId/exercises/$logId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to delete exercise");
    }
  }
}