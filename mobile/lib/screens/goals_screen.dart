import 'package:flutter/material.dart';
import '../AppColors.dart';
import '../services/goal_service.dart';
import '../utils/storage.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {

  final GoalService service = GoalService();

  Map<String,dynamic>? goal;

  bool loading = true;

  String? activityLevel;
  String? goalType;


  final activityOptions = [
    "NOT_VERY_ACTIVE",
    "LIGHTLY_ACTIVE",
    "ACTIVE",
    "VERY_ACTIVE"
  ];


  final goalOptions = [
    "LOSE_500GR_PER_WEEK",
    "LOSE_1KGR_PER_WEEK",
    "MAINTAIN",
    "GAIN_500GR_PER_WEEK",
    "GAIN_1KGR_PER_WEEK"
  ];


  @override
  void initState() {
    super.initState();
    loadGoal();
  }


  void loadGoal() async {

    final userId = await Storage.getUserId();

    final res = await service.getGoalByUserId(userId!);


    setState(() {

      goal = res;

      activityLevel = res['activityLevel'];

      goalType = res['goalType'];

      loading = false;

    });

  }



  void updateGoal() async {

    try {

      await service.updateGoal(
        goal!['id'],
        {
          "activityLevel": activityLevel,
          "goalType": goalType,
        },
      );


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Goal updated"),
        ),
      );


      loadGoal();


    } catch(e){

      print(e);

    }

  }



  @override
  Widget build(BuildContext context) {


    if(loading){

      return const Center(
        child: CircularProgressIndicator(),
      );

    }


    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Goals"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            const Text(
              "Update your goal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height:25),



            dropdownCard(
              title: "Activity Level",
              value: activityLevel!,
              items: activityOptions,
              onChanged: (value){

                setState(() {
                  activityLevel=value;
                });

              },
            ),



            const SizedBox(height:20),



            dropdownCard(
              title: "Goal Type",
              value: goalType!,
              items: goalOptions,
              onChanged: (value){

                setState(() {
                  goalType=value;
                });

              },
            ),



            const SizedBox(height:30),



            const Text(
              "Current Plan",
              style: TextStyle(
                color: Colors.white,
                fontSize:22,
                fontWeight:FontWeight.bold,
              ),
            ),


            const SizedBox(height:15),



            infoCard(
                "Calories",
                "${goal!['calories']} kcal"
            ),


            infoCard(
                "Protein",
                "${goal!['proteins']} g"
            ),


            infoCard(
                "Carbs",
                "${goal!['carbs']} g"
            ),


            infoCard(
                "Fats",
                "${goal!['fats']} g"
            ),



            const Spacer(),



            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.all(16),
                ),

                onPressed: updateGoal,


                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:18,
                  ),
                ),

              ),
            )


          ],

        ),

      ),

    );

  }




  Widget dropdownCard({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }){


    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal:16,
        vertical:5,
      ),


      decoration: BoxDecoration(

        color: Colors.white10,

        borderRadius: BorderRadius.circular(16),

      ),


      child: DropdownButtonFormField<String>(

        value:value,


        dropdownColor: const Color(0xFF222222),


        decoration: InputDecoration(

          labelText:title,

          labelStyle:
          const TextStyle(
            color:Colors.white54,
          ),

          border:InputBorder.none,

        ),



        items: items.map((e){

          return DropdownMenuItem(

            value:e,

            child:Text(

              e.replaceAll("_"," "),

              style:const TextStyle(
                color:Colors.white,
              ),

            ),

          );

        }).toList(),


        onChanged:onChanged,

      ),

    );

  }




  Widget infoCard(String title,String value){


    return Container(

      margin:const EdgeInsets.only(bottom:10),


      padding:const EdgeInsets.all(16),


      decoration:BoxDecoration(

        color:Colors.white10,

        borderRadius:BorderRadius.circular(14),

      ),



      child:Row(

        mainAxisAlignment:MainAxisAlignment.spaceBetween,


        children:[

          Text(
            title,
            style:const TextStyle(
              color:Colors.white70,
            ),
          ),


          Text(
            value,
            style:const TextStyle(
              color:Colors.white,
              fontWeight:FontWeight.bold,
            ),
          ),

        ],

      ),

    );

  }


}