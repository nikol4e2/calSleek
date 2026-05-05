import "dart:convert";
import 'package:http/http.dart' as http;


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


}