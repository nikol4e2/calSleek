import 'package:flutter/material.dart';
import 'package:mobile/AppColors.dart';

import '../services/dailymacros_service.dart';
import '../utils/storage.dart';
import 'add_food_sheet.dart';


class DailyMacrosScreen extends StatefulWidget {
  const DailyMacrosScreen({super.key, required this.goal});
  final Map<String, dynamic> goal;

  @override
  State<DailyMacrosScreen> createState() => _DailyMacrosScreenState();
}

class _DailyMacrosScreenState extends State<DailyMacrosScreen> {

  final service = DailymacrosService();



  Map<String, dynamic>? data;

  bool loading=true;

  @override
  void initState() {

    super.initState();
    load();
  }

  void load() async{
    final userId = await Storage.getUserId();
    final res = await service.getToday(userId!);

    setState(() {
      data=res;
      loading=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    if(loading)
      {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      }
    
    final macros = data!;
    return  Scaffold(
      backgroundColor: AppColors.background ,
        appBar: AppBar(
        title: const Text("Daily Macros"),
        backgroundColor: Colors.black,
    ),
        body: Padding(
          padding: const EdgeInsets.all(16),
    child: Column(
    children: [
      summaryCard(macros),
      const SizedBox(height: 20,),
      Expanded(child: foodSections(macros))
    ],
    ),
    ),

    );
  }
  
  Widget summaryCard(Map macros){


    int calories = macros['totalCalories'] ?? 0;
    int protein = macros['totalProteins'] ?? 0;
    int carbs = macros['totalCarbs'] ?? 0;
    int fats = macros['totalFats'] ?? 0;

    int goalCalories = widget.goal['calories'] ?? 0;
    int goalProtein = widget.goal['proteins'] ?? 0;
    int goalCarbs = widget.goal['carbs'] ?? 0;
    int goalFats = widget.goal['fats'] ?? 0;


    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Daily Progress",
              style: TextStyle(color: Colors.white, fontSize: 18)),

          const SizedBox(height: 12),

          macroBar("Calories", calories, goalCalories),
          macroBar("Protein", protein, goalProtein),
          macroBar("Carbs", carbs, goalCarbs),
          macroBar("Fats", fats, goalFats),
        ],
      ),
    );
  }

  Widget macroBar(String label, int value, int goal) {

    double progress = goal == 0 ? 0 : value / goal;
    if (progress > 1) progress = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: $value / $goal",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }


  Widget foodSections(Map macros) {
    List foods = macros['foodEntries'] ?? [];

    Map<String, List> grouped = {
      "BREAKFAST": [],
      "LUNCH": [],
      "DINNER": [],
      "SNACKS": [],
    };

    for (var f in foods){
      String cat = f['category'] ?? "SNACKS";
      grouped.putIfAbsent(cat, ()=>[]);
      grouped[cat]!.add(f);
    }

    return ListView(
      children: [
        section("Breakfast", grouped["BREAKFAST"]!, macros['id']),
        section("Lunch", grouped["LUNCH"]!, macros['id']),
        section("Dinner", grouped["DINNER"]!, macros['id']),
        section("Snacks", grouped["SNACKS"]!, macros['id']),
      ],
    );
  }

  Widget section(String title, List foods, int macrosId){

    int totalCalories= foods.fold(0 ,
          (int sum, f) => sum + (f['totalCalories'] ?? 0) as int
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18),),
        const SizedBox(height: 10,),

        ...foods.map((f) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${f['food']['name']} - ${f['grams']}g - ${f['totalCalories']} kcal",
            style: const TextStyle(color: Colors.white),
          ),
        )),

        const SizedBox(height: 10,),
        ElevatedButton(onPressed: ()=>addFoodDialog(macrosId), child: const Text("Add food"))

      ],
    );
  }

  void addFoodDialog(int macrosId){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddFoodSheet(
          macrosId: macrosId,
          onAdded: load,
        ));
  }


}

