import 'dart:convert';
import "package:http/http.dart" as http;

import '../utils/storage.dart';


class ApiService {

  final String baseUrl= "http://10.0.2.2:8080/api";

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
        print(res.body);
        return jsonDecode(res.body);

      }else
        {
          throw Exception("Failed to load macros");
        }
  }

}