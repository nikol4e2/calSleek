import "dart:convert";
import 'package:http/http.dart' as http;

import '../utils/storage.dart';


class AuthService{



  final String baseUrl="http://10.0.2.2:8080/api/auth";

  Future<Map<String,dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    ).timeout(const Duration(seconds: 10));


    if(res.statusCode==200){
      return jsonDecode(res.body);
    }else{

      throw Exception("Login failed");
      }
  }

  Future<Map<String,dynamic>> register( String username,
      String firstName,
      String lastName,
      String email,
      String password,
      String repeatPassword) async
  {
    final res=await http.post(Uri.parse("$baseUrl/register"),headers: {"Content-Type": "application/json"}
    , body: jsonEncode({  "username": username,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "repeatPassword": repeatPassword})).timeout(const Duration(seconds: 10));

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      final body = jsonDecode(res.body);
      throw Exception(body["message"] ?? "Register failed");
    }
    
  }
  Future<void> changePassword(
      String oldPassword,
      String newPassword
      ) async {

    final response = await http.put(
      Uri.parse("$baseUrl/change-password"),
      headers: {
        "Content-Type":"application/json",
        "Authorization":"Bearer ${await Storage.getToken()}"
      },

      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword
      }),
    );


    if(response.statusCode != 200){
      throw Exception(
          jsonDecode(response.body)["error"]
      );
    }

  }
  
  
  Future<Map<String,dynamic>> getMe() async{


    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: {
        "Authorization": "Bearer ${await Storage.getToken()}",
      },
    ).timeout(
      const Duration(seconds: 10),
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Failed to load user");
    }
  }


}