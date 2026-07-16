import 'package:flutter/material.dart';
import '../AppColors.dart';
import '../utils/storage.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void logout(BuildContext context) async{
    await Storage.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Settings"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [


            settingsTile(
              Icons.lock,
              "Change Password",
                  () {
                // TODO
              },
            ),


            settingsTile(
              Icons.notifications,
              "Notifications",
                  () {
                // TODO
              },
            ),


            settingsTile(
              Icons.info_outline,
              "About CalSleek",
                  () {
                showAboutDialog(
                  context: context,
                  applicationName: "CalSleek",
                  applicationVersion: "1.0.0",
                  applicationLegalese:
                  "Track calories. Track progress.",
                );
              },
            ),



            const Spacer(),



            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),


                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),


                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),


                onPressed: (){
                  logout(context);
                },

              ),
            ),


            const SizedBox(height:20),



            const Text(
              "CalSleek v1.0.0",
              style: TextStyle(
                color: Colors.white38,
              ),
            ),

          ],

        ),

      ),

    );

  }



  Widget settingsTile(
      IconData icon,
      String title,
      VoidCallback onTap,
      ){

    return Container(

      margin: const EdgeInsets.only(bottom:12),


      decoration: BoxDecoration(

        color: Colors.white10,

        borderRadius: BorderRadius.circular(16),

      ),


      child: ListTile(

        onTap:onTap,


        leading:Icon(
          icon,
          color:AppColors.primaryRed,
        ),


        title:Text(
          title,
          style:const TextStyle(
            color:Colors.white,
          ),
        ),


        trailing:const Icon(
          Icons.chevron_right,
          color:Colors.white54,
        ),

      ),

    );


  }
}
