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

  Map<String, dynamic>? goal;

  bool loading = true;

  final caloriesController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinsController = TextEditingController();
  final fatsController = TextEditingController();

  int? goalId;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final userId = await Storage.getUserId();
    final res = await service.getGoalByUserId(userId!);

    setState(() {
      goal = res;
      goalId = res['id'];

      caloriesController.text = res["calories"].toString();

      carbsController.text = res["carbs"].toString();

      proteinsController.text = res["proteins"].toString();

      fatsController.text = res["fats"].toString();

      loading = false;
    });
  }

  bool validateCalories() {
    final calories = int.tryParse(caloriesController.text) ?? 0;
    final carbs = int.tryParse(carbsController.text) ?? 0;

    final protein = int.tryParse(proteinsController.text) ?? 0;

    final fats = int.tryParse(fatsController.text) ?? 0;

    final calculated = carbs * 4 + protein * 4 + fats * 9;

    return (calculated - calories).abs() <= 50;
  }

  void save() async {
    if (!validateCalories()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Calories do not match macros")),
      );

      return;
    }
    final body = {
      "activityLevel": goal!["activityLevel"],

      "weight": goal!["weight"],

      "height": goal!["height"],

      "age": goal!["age"],

      "isMale": goal!["isMale"],

      "goalType": goal!["goalType"],

      "calories": int.parse(caloriesController.text),

      "carbs": int.parse(carbsController.text),

      "proteins": int.parse(proteinsController.text),

      "fats": int.parse(fatsController.text),
    };

    try {
      await service.updateGoal(goalId!, body);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Goal updated")));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("My Goal")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            input("Calories", caloriesController),

            input("Carbs (g)", carbsController),
            input("Protein (g)", proteinsController),
            input("Fats (g)", fatsController),
            
            const SizedBox(height: 30),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
              ),
              onPressed: save,
              
              child: const Text("Save changes",style: TextStyle(color:Colors.white),),
            )
          ],
        ),
      ),
    );
  }
  
  Widget input (String label, TextEditingController controller)
  {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
      
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        )),
      ),
    
    );
  }
}
