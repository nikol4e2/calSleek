import 'dart:convert';
import "package:http/http.dart" as http;

import '../utils/storage.dart';


class ApiService {
  //TODO add url
  final String baseUrl= "";

  Future<Map<String,dynamic>> getDailyMacros(int userId) async {
    final token = await Storage.getToken();
    final today = DateTime.now().toIso8601String().split("T")[0];

    final res = await http.get(
      Uri.parse("$baseUrl/daily-macros/$userId?date=$today"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if(res.statusCode==200)
      {
        return jsonDecode(res.body);
      }else
        {
          throw Exception("Failed to load macros");
        }
  }

}