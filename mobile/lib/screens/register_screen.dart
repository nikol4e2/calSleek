import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/screens/goal_onboarding_screen.dart';
import 'package:mobile/services/auth_service.dart';

import '../AppColors.dart';
import '../utils/storage.dart';



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
  final authService= AuthService();
  bool validate(){
    final username = usernameController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final repeat = repeatPasswordController.text.trim();
    if(username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        repeat.isEmpty){

      showError("All fields are required");
      return false;
    }

    //Username check
    if(username.length < 3 || username.length > 20){
      showError("Username must be between 3 and 20 characters");
      return false;
    }
    if(!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)){
      showError("Username can contain only letters, numbers and _");
      return false;
    }

    //Names check
    if(!RegExp(r'^[a-zA-Z]+$').hasMatch(firstName) ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(lastName)){

      showError("Names can contain only letters");
      return false;
    }

    //Email check
    if(!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(email)){

      showError("Invalid email");
      return false;
    }



    //Password check
    if(password.length < 8){
      showError("Password must contain at least 8 characters");
      return false;
    }





    if(!RegExp(r'[0-9]').hasMatch(password)){
      showError("Password needs one number");
      return false;
    }


    if(password != repeat){
      showError("Passwords do not match");
      return false;
    }

    return true;
  }


  void showError(String msg)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.primaryRed,content: Text(msg)));
  }

  void register() async {
    if (!validate()) return;

    setState(() => loading = true);

    try {
      final username = usernameController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final repeatPassword = repeatPasswordController.text.trim();

      final response = await authService.register(
        username,
        firstName,
        lastName,
        email,
        password,
        repeatPassword,
      );


      final loginResponse = await authService.login(username, password);
      await Storage.saveToken(loginResponse["token"]);
      await Storage.saveUserId(loginResponse["userId"]);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const GoalOnboardingScreen(),
        ),
      );

    } catch (e) {
      showError(e.toString());
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
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
