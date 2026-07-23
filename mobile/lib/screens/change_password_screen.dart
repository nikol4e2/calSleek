
import 'package:flutter/material.dart';
import '../AppColors.dart';
import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}


class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final authService = AuthService();

  bool loading = false;


  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryRed,
        content: Text(msg),
      ),
    );
  }


  bool validate(){

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final repeat = repeatPasswordController.text.trim();


    if(oldPassword.isEmpty ||
        newPassword.isEmpty ||
        repeat.isEmpty){

      showError("All fields are required");
      return false;
    }


    if(newPassword.length < 6){

      showError("Password must have at least 6 characters");
      return false;
    }


    if(newPassword != repeat){

      showError("Passwords do not match");
      return false;
    }


    return true;
  }



  Future<void> changePassword() async{

    if(!validate()) return;


    setState(() {
      loading = true;
    });


    try{

      await authService.changePassword(
        oldPasswordController.text.trim(),
        newPasswordController.text.trim(),
      );


      if(!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully"),
        ),
      );


      Navigator.pop(context);


    }catch(e){

      showError(e.toString());

    }finally{

      if(mounted){
        setState(() {
          loading=false;
        });
      }

    }

  }



  @override
  void dispose(){

    oldPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,


      appBar: AppBar(
        title: const Text("Change Password"),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20),


        child: Column(
          children: [


            inputField(
              "Current password",
              oldPasswordController,
            ),


            inputField(
              "New password",
              newPasswordController,
            ),


            inputField(
              "Repeat new password",
              repeatPasswordController,
            ),


            const SizedBox(height:30),



            SizedBox(
              width: double.infinity,
              height:50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),


                onPressed: loading ? null : changePassword,


                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "SAVE PASSWORD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            )

          ],
        ),

      ),
    );
  }



  Widget inputField(
      String hint,
      TextEditingController controller,
      ){

    return Padding(
      padding: const EdgeInsets.only(bottom:15),

      child: TextField(

        controller: controller,

        obscureText: true,

        style: const TextStyle(
          color: Colors.white,
        ),


        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),


          filled:true,

          fillColor: Colors.white10,


          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

        ),

      ),
    );

  }

}