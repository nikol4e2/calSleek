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

  DateTime selectedDate=DateTime.now();



  Map<String, dynamic>? data;

  bool loading=true;

  @override
  void initState() {

    super.initState();
    load();
  }

  void load() async {
    final userId = await Storage.getUserId();

    final res = await service.getByDate(
      userId!,
      selectedDate,
    );

    setState(() {
      data = res;
      loading = false;
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
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    loading = true;
                  });
                  load();
                }
              },
            )
          ],
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

  Widget section(String title, List foods, int macrosId) {
    int totalCalories = foods.fold(
      0,
          (int sum, f) => sum + ((f['totalCalories'] ?? 0) as num).toInt(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$totalCalories kcal",
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ITEMS
          if (foods.isEmpty)
            const Text(
              "No foods added",
              style: TextStyle(color: Colors.white38),
            )
          else
            ...foods.map((f) {
              final food = f['food'];
              final name = food != null ? food['name'] : "Unknown";

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "$name",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "${f['grams']}g",
                      style: const TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${f['totalCalories']} kcal",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 10),

          // ADD BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => addFoodDialog(macrosId),
              icon: const Icon(Icons.add),
              label: const Text("Add food"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
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

