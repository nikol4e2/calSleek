import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/utils/storage.dart';


class FoodService {
  final String baseUrl = "http://10.0.2.2:8080/api/food";



  
  //SEARCH
  Future<List<dynamic>> searchFoods(String query) async{

    final token = await Storage.getToken();
    final res= await http.get(
      Uri.parse("$baseUrl/search?searchText=$query"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if(res.statusCode==200)
      {
        return jsonDecode(res.body);
      }

    return [];
  }

  //CREATED BY USER
  Future<List<dynamic>> getUserFoods(int userId) async{
    final token = await Storage.getToken();
    final res= await http.get(
        Uri.parse("$baseUrl/created-by/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if(res.statusCode==200)
    {
      return jsonDecode(res.body);
    }
    return [];

  }


  //GET ALL
  Future<List<dynamic>> getAll() async {
    final token = await Storage.getToken();

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load foods");
    }
  }

  Future<Map<String,dynamic>> createFood(Map<String,dynamic> body) async{

    final token= await Storage.getToken();

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json",
      "Authorization": "Bearer $token",},

      body: jsonEncode(body)

    );
    if(res.statusCode == 201){

      return jsonDecode(res.body);

    }


        throw Exception("Failed to create food");

  }
  
  
  Future<void> deleteFood(int id) async{
    
    final token= await Storage.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (res.statusCode != 204) {
      throw Exception("Failed to delete food");
    }

  }





}