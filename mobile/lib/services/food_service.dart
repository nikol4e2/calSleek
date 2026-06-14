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



}