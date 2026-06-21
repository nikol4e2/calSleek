import "dart:convert";
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class DailymacrosService {
  final String baseUrl = "http://10.0.2.2:8080/api/daily-macros";
  
  Future<Map<String,dynamic>> getToday(int userId) async{
    final token = await Storage.getToken();
    
    final res = await http.get(
      Uri.parse("$baseUrl/today/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    
    if(res.statusCode==200)
      {
        return jsonDecode(res.body);
      }else{
      throw Exception("Failed to load daily macros");
    }
  }

  Future<Map<String, dynamic>> getByDate(int userId, DateTime date) async{
    final token= await Storage.getToken();
    final formattedDate = date.toIso8601String().split("T")[0]; // yyyy-MM-dd
    final res = await http.get(
      Uri.parse("$baseUrl/date/$userId?date=$formattedDate"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load daily macros by date");
    }

  }
  
  
  Future<void> addFood(int macrosId,Map<String,dynamic> body) async{
    final token = await Storage.getToken();
    
    final res= await http.post(
      Uri.parse("$baseUrl/$macrosId/food-entries"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if(res.statusCode != 200)
      {
        throw Exception("Failed to add food");
      }
  }
  Future<void> deleteFoodEntry(int macrosId, int foodEntryId) async {
    final token = await Storage.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/$macrosId/food-entries/$foodEntryId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to delete food entry");
    }
  }


  Future<void> updateFoodEntry(
      int macrosId,
      int foodEntryId,
      int grams,
      ) async {
    final token = await Storage.getToken();

    final res = await http.patch(
      Uri.parse(
        "$baseUrl/$macrosId/food-entries/$foodEntryId?grams=$grams",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to update food entry");
    }
  }

}