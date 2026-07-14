import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';


class MeasurementService {
  final String baseUrl = "http://10.0.2.2:8080/api/measurement";
  
  
  Future<Map<String,dynamic>?> getLatest(int userId) async{
    final token= await Storage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/user/$userId/latest"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if(res.statusCode== 200)
      {
        return jsonDecode(res.body);
      }


    return null;
  }


  Future<List> getAll(int userId) async{

    final token= await Storage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/user/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if(res.statusCode==200)
      {
        return jsonDecode(res.body);
      }

    throw Exception("Failed to load measurements");

  }


  Future<void> addMeasurement(int userId, double value) async{
    final token = await Storage.getToken();

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
        "value": value,
        "date": DateTime.now().toIso8601String(),
      }),
    );
    
    if(res.statusCode!=200)
      {
        throw Exception("Failed to add measurement");
      }

  }

  
  Future<void> deleteMeasurement(int id) async{
    final token = await Storage.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to delete measurement");
  }
}