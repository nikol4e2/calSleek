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

  bool isLoading = false;

  void login() async{
    setState(() {
      isLoading=true;
    });
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
    }finally {
      setState(() {
        isLoading=false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(height: 30,),
            RichText(text: const TextSpan(style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),children:
            [

              TextSpan(text: "cal", style: TextStyle(color: Color(0xFFFF2D55))),
              TextSpan(text: "Sleek", style: TextStyle(color: Colors.white))
            ]
            ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const SizedBox(height: 80),




                  const SizedBox(height: 30,),


                  const Text("Welcome back", style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),

                  const SizedBox(height: 8,),

                  const Text("Track your calories with elegance", style: TextStyle(color: Color(0xFFA3A3A3)),textAlign: TextAlign.center,),


                  const SizedBox(height: 30,),

                  //Username INPUT FIELD
                  _inputField("Username", usernameController),

                  _inputField("Password", passwordController, obscure: true),

                  Align(alignment: Alignment.centerRight,
                  child: Text("Forgot password?",style: TextStyle(color: Color(0xFFFF2D55), fontSize: 13),),),
                  
                  
                  const SizedBox(height: 30,),
                  
                  //LOGIN BUTTON
                  
                  isLoading ? const Center(child: CircularProgressIndicator(),)
                      : GestureDetector(
                    onTap: login,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors:[ Color(0xFFFF2D55),Color(0xFFFF5A5F)]),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: const Center(
                        child: Text("Log in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      ),
                    ),
                  ),


                  const SizedBox(height: 20,),
                  
                  Center(
                    child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(color: Color(0xFFFF2D55)
                              ),
                            )
                          ]
                        )
                    ),
                  )



                ],
              ),
            ),


          ],

        ),



      ))
    );
  }


  Widget _inputField(String hint, TextEditingController controller, {bool obscure =false}){
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20)

        ),
      ),
    );
  }
}
