import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/screens/goal_onboarding_screen.dart';

import '../AppColors.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  bool loading = false;

  void register() async{
    final username= usernameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName= lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final repeatPassword = repeatPasswordController.text.trim();

    if(username.isEmpty || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || repeatPassword.isEmpty)
      {
        return;
      }


    setState(() {
      loading=true;
    });

    try{
      //TODO API CALL

      final body = {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "repeatPassword": repeatPassword,
      };

      print(body);

      await Future.delayed(const Duration(seconds: 1));

      if(!mounted) return;

      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_)=> const GoalOnboardingScreen())
      );


    } catch (e)
    {
      print(e);
    }

    setState(() {
      loading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 60),
        child: Column(
          children: [
            const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),


            const SizedBox(height: 30,),

            _input(usernameController, "Username"),
            _input(firstNameController, "First Name"),
            _input(lastNameController, "Last Name"),
            _input(emailController, "Email"),

            _input(passwordController, "Password", isPass: true),
            _input(repeatPasswordController, "Repeat Password", isPass: true),

            const SizedBox(height: 25,),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed:
              loading ? null : register,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: loading ? const CircularProgressIndicator(color: Colors.white,) : const Text("REGISTER", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),)),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint, {bool isPass=false})
  {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextField(
          controller: c,
          obscureText: isPass,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText:  hint,
            hintStyle: const TextStyle(color: Colors.white54),

            filled: true,
            fillColor: Colors.white10,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed)
            )
          ),
        ),

    );
  }
}
