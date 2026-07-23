import 'package:flutter/material.dart';
import 'package:mobile/models/goal.dart';
import 'package:mobile/screens/main_screen.dart';
import 'package:mobile/services/goal_service.dart';

import '../AppColors.dart';
import '../utils/storage.dart';

class GoalOnboardingScreen extends StatefulWidget {
  const GoalOnboardingScreen({super.key});

  @override
  State<GoalOnboardingScreen> createState() =>
      _GoalOnboardingScreenState();
}

class _GoalOnboardingScreenState
    extends State<GoalOnboardingScreen> {

  final GoalData data = GoalData();
  final GoalService goalService = GoalService();

  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            LinearProgressIndicator(
              value: (step + 1) / 6,
              color: AppColors.primaryRed,
              backgroundColor: Colors.white12,
            ),
            const SizedBox(height: 30),
            Expanded(child: getStep()),
          ],
        ),
      ),
    );
  }

  Widget getStep() {
    switch (step) {
      case 0:
        return genderStep();
      case 1:
        return weightStep();
      case 2:
        return heightStep();
      case 3:
        return ageStep();
      case 4:
        return activityStep();
      case 5:
        return goalTypeStep();
      default:
        return Container();
    }
  }

  Widget genderStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Select your gender",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            choiceButton("Male"),
            const SizedBox(width: 10),
            choiceButton("Female"),
          ],
        ),
        const SizedBox(height: 30),
        nextButton(),
      ],
    );
  }

  Widget weightStep() {
    final controller = TextEditingController(
      text: data.weight == 0 ? "" : data.weight.toString(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Enter your weight (kg)",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (v) => data.weight = double.tryParse(v) ?? 0,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g 80",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        nextButton(),
      ],
    );
  }

  Widget heightStep() {
    final controller = TextEditingController(
      text: data.height == 0 ? "" : data.height.toString(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Enter your height (cm)",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (v) => data.height = int.tryParse(v) ?? 0,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g 180",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        nextButton(),
      ],
    );
  }

  Widget ageStep() {
    final controller = TextEditingController(
      text: data.age == 0 ? "" : data.age.toString(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Enter your age",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (v) => data.age = int.tryParse(v) ?? 0,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "e.g 22",
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        nextButton(),
      ],
    );
  }
  Widget activityStep() {
    final options = [
      {
        "value": "NOT_VERY_ACTIVE",
        "label": "Little or no exercise"
      },
      {
        "value": "LIGHTLY_ACTIVE",
        "label": "Light exercise (1-3 days/week)"
      },
      {
        "value": "ACTIVE",
        "label": "Moderate exercise (3-5 days/week)"
      },
      {
        "value": "VERY_ACTIVE",
        "label": "High activity (6-7 days/week)"
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Activity level",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),

        const SizedBox(height: 20),

        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                data.activityLevel = option["value"]!;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: data.activityLevel == option["value"]
                    ? AppColors.primaryRed
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                option["label"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )),

        const SizedBox(height: 20),

        nextButton(),
      ],
    );
  }

  Widget goalTypeStep() {
    final options = [
      {
        "value": "LOSE_500GR_PER_WEEK",
        "label": "Lose 0.5 kg per week"
      },
      {
        "value": "LOSE_1KGR_PER_WEEK",
        "label": "Lose 1 kg per week"
      },
      {
        "value": "MAINTAIN",
        "label": "Maintain weight"
      },
      {
        "value": "GAIN_500GR_PER_WEEK",
        "label": "Gain 0.5 kg per week"
      },
      {
        "value": "GAIN_1KGR_PER_WEEK",
        "label": "Gain 1 kg per week"
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Your goal",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom:10),
          child: GestureDetector(
            onTap: (){
              setState(() {
                data.goalType = option["value"]!;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: data.goalType == option["value"]
                    ? AppColors.primaryRed
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                option["label"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )),
        const SizedBox(height: 20),
        nextButton(),
      ],
    );
  }

  Widget choiceButton(String value) {
    return GestureDetector(
      onTap: () => setState(() => data.gender = value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: data.gender == value
              ? AppColors.primaryRed
              : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(value, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
      ),
      onPressed: () {
        if(!validateCurrentStep()){
          showValidationError();
          return;
        }
        if (step < 5) {
          setState(() => step++);
        } else {
          submitGoal();
        }
      },
      child: Text(
        step == 5 ? "Finish" : "Next",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void submitGoal() async {

    try {
      final userId = await Storage.getUserId();

      final body = {
        "weight": data.weight,
        "height": data.height,
        "age": data.age,
        "isMale": data.gender == "Male",
        "activityLevel": data.activityLevel,
        "goalType": data.goalType,
        "userId": userId,
      };

      final goal=await goalService.createGoal(body);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  MainScreen(userId: userId!,)),
      );
    } catch (e) {
      print(e);
    }
  }

  bool validateCurrentStep(){

    switch(step)
        {
      case 0: return data.gender.isNotEmpty;

      case 1: return data.weight >=30 && data.weight <= 300;

      case 2: return data.height >=100 && data.height <=250;

      case 3: return data.age >12 && data.age<=110;

      case 4: return data.activityLevel.isNotEmpty;

      case 5: return data.goalType.isNotEmpty;

      default:
        return true;
    }
  }

  void showValidationError(){

    String message="";

    switch(step) {
      case 0:
        message = "Please select your gender";
        break;

      case 1:
        message = "Weight must be between 30 and 300 kg";
        break;

      case 2:
        message = "Height must be between 100 and 250cm";
        break;

      case 3:
        message = "Age must be between 12 and 110";
        break;

      case 4:
        message = "Please select activity level";
        break;

      case 5:
        message = "Please select your goal";
        break;

    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}