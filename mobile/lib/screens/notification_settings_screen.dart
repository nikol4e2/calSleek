import 'package:flutter/material.dart';
import '../AppColors.dart';
import '../services/notification_service.dart';
import '../utils/NotificationStorage.dart';



class NotificationSettingsScreen extends StatefulWidget {

  const NotificationSettingsScreen({super.key});


  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();

}



class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen>{


  bool enabled=true;


  @override
  void initState(){

    super.initState();

    load();

  }



  void load() async {

    final value =
    await NotificationStorage.isEnabled();


    setState(() {

      enabled=value;

    });

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: AppColors.background,


      appBar: AppBar(
        title: const Text(
          "Notifications",
        ),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),


        child: Container(

          decoration: BoxDecoration(

            color: Colors.white10,

            borderRadius:
            BorderRadius.circular(16),

          ),


          child: SwitchListTile(

            title: const Text(
              "Daily Reminder",
              style: TextStyle(
                color: Colors.white,
              ),
            ),


            subtitle: const Text(
              "Get reminded to track your calories",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),


            value: enabled,


            activeColor:
            AppColors.primaryRed,


            onChanged: (value) async {


              setState(() {

                enabled=value;

              });


              await NotificationStorage
                  .setEnabled(value);



              if(value){

                await NotificationService
                    .scheduleDailyReminder();

              }
              else{

                await NotificationService
                    .cancelAll();

              }


            },

          ),

        ),

      ),

    );


  }


}