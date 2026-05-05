import 'package:flutter/material.dart';
import 'package:mobile/models/goal.dart';
import 'package:mobile/screens/main_screen.dart';

import '../AppColors.dart';

class GoalOnboardingScreen extends StatefulWidget {
  const GoalOnboardingScreen({super.key});

  @override
  State<GoalOnboardingScreen> createState() => _GoalOnboardingScreenState();
}

class _GoalOnboardingScreenState extends State<GoalOnboardingScreen> {

  final GoalData  data = GoalData();
  int step=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(padding: const EdgeInsetsGeometry.all(20),
      child: Column(
        children: [

          LinearProgressIndicator(
            value:(step+1)/5,
            color: AppColors.primaryRed,
            backgroundColor: Colors.white12,

          ),
          const SizedBox(height: 30,),

          Expanded(child: getStep()),
        ],
      )
      )
    );
  }

  Widget getStep(){
    switch(step){

      case 0: return genderStep();
      case 1: return weightStep();
      case 2: return heightStep();
      case 3: return activityStep();
      case 4: return goalTypeStep();

      default: return Container();
    }
  }

  Widget genderStep(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Select your gender", style: TextStyle(color: Colors.white,fontSize: 22),),

        const SizedBox(height: 20,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            choiceButton("Male"),
            const SizedBox(width: 10,),
            choiceButton("Female")
          ],
        ),
        const SizedBox(height: 30,),

        nextButton(),
      ],
    );
  }
  Widget weightStep(){
    final controller = TextEditingController(
      text: data.weight== 0 ? "" : data.weight.toString(),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Enter your weight (kg)",
          style: TextStyle(color: Colors.white,fontSize: 22),
        ),

        const SizedBox(height: 20,),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (v) => data.weight = double.tryParse(v) ?? 1,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g 80",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            )
          ),
        ),
        const SizedBox(height: 30,),

        nextButton()
      ],

    );
  }

  Widget heightStep(){
    final controller = TextEditingController(
      text: data.height == 0 ? "" : data.height.toString(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Enter your height (cm)", style: TextStyle(color: Colors.white,fontSize: 22),),

        const SizedBox(height: 20,),


        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (v)=>data.height = int.tryParse(v) ?? 1,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g 180",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )
          ),
        ),
        const SizedBox(height: 30,),

        nextButton()
      ],
    );
  }

  Widget activityStep(){
    final options = [
      "NOT_VERY_ACTIVE",
      "LIGHTLY_ACTIVE",
      "ACTIVE",
      "VERY_ACTIVE"
    ];
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        const Text(
          "Enter your activity level",
          style: TextStyle(color: Colors.white,fontSize: 22),
        ),

        const SizedBox(height: 20,),

        ...options.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                data.activityLevel = e;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: data.activityLevel == e
                    ? AppColors.primaryRed
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                e,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )),
        const SizedBox(height: 20,),
        nextButton(),

      ],
    );
  }

  Widget goalTypeStep(){
    final options=[
      "LOSE_500GR_PER_WEEK",
      "LOSE_1KGR_PER_WEEK",
      "MAINTAIN",
      "GAIN_500GR_PER_WEEK",
      "GAIN_1KGR_PER_WEEK"
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          "Your goal",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),

        const SizedBox(height: 20),

        ...options.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                data.goalType = e;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: data.goalType == e
                    ? AppColors.primaryRed
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                e,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )),

        const SizedBox(height: 20),

        nextButton(),
      ],
    );
  }

  Widget choiceButton(String value)
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          data.gender=value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: data.gender==value ? AppColors.primaryRed : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(value,style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget nextButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
      ),
      onPressed: (){
        if(step<4){
          setState(() {
            step++;
          });
        }else {
          submitGoal();
        }
      }
      ,child: Text(step==4 ? "Finish" : "Next", style: TextStyle(color: Colors.white),),
    );
  }



  void submitGoal() async{
    try{
      final body={
        "gender": data.gender,
        "weight": data.weight,
        "height": data.height,
        "age": data.age,
        "activityLevel": data.activityLevel,
        "goalType": data.goalType,
      };

      //TODO API CALL
      //await goalService.createGoal(body);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    }catch (e)
    {
      print(e);
    }
  }
}
