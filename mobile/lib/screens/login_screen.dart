import 'package:flutter/material.dart';
import 'package:mobile/utils/storage.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();

  void login() async{

    try{
      final res = await authService.login(
        usernameController.text,
        passwordController.text
      );

      await Storage.saveToken(res['token']);


      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_)=> const HomeScreen()),
      );


    }catch (e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"),),
      body: Padding(padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username"),),
          TextField(controller: passwordController,decoration: const InputDecoration(labelText: "Password"),),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: login, child: const Text("Login"))
        ],
      ),),
    );
  }
}
