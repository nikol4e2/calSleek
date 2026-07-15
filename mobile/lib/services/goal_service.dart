import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/utils/storage.dart';

class GoalService {

  final String baseUrl="http://10.0.2.2:8080/api/goal";

  Future<void> createGoal(Map<String, dynamic> body) async{

    final token= await Storage.getToken();


    final res = await http.post(
      Uri.parse(baseUrl),
      headers:{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );


    if (res.statusCode != 201) {
      throw Exception("Failed to create goal");
    }

  }

  Future<Map<String, dynamic>> getGoalByUserId(int userId) async{
    final token = await Storage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/user/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );


      if (res.statusCode == 200)
      {
      return jsonDecode(res.body);
      }else
        throw Exception("Failed to load goal");


  }

  Future<Map<String,dynamic>> updateGoal(int id, Map<String,dynamic> body) async{
    final token= await Storage.getToken();
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );


    if(res.statusCode != 200){
      throw Exception("Failed to update goal");
    }

    return jsonDecode(res.body);
  }
}