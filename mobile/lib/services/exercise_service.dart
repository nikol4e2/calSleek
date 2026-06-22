import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';


class ExerciseService {

  final String baseUrl= "http://10.0.2.2:8080/api/daily-macros";
  
  Future<void> addExercise(int macrosId, Map<String,dynamic> body) async{
    final token = await Storage.getToken();
    
    
    final res = await http.post(
      Uri.parse("$baseUrl/$macrosId/exercises"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if(res.statusCode!=204)
      {
        throw Exception("Failed to add exercise");
      }
  }

  Future<void> deleteExercise(int macrosId, int logId) async{
    final token= await Storage.getToken();

    final res= await http.delete(
      Uri.parse("$baseUrl/$macrosId/exercises/$logId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to delete exercise");
    }



  }
}