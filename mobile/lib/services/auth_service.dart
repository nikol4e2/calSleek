import "dart:convert";
import 'package:http/http.dart' as http;


class AuthService{


  //TODO add URL
  final String baseUrl="";

  Future<Map<String,dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );


    if(res.statusCode==200){
      return jsonDecode(res.body);
    }else{
      throw Exception("Login failed");
      }
  }


}