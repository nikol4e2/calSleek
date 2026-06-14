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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Text(
            "Calories: ${macros['totalCalories']}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Protein: ${macros['totalProteins']}g",
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "Carbs: ${macros['totalCarbs']}g",
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "Fats: ${macros['totalFats']}g",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      )
    );
  }


  Widget foodSections(Map macros) {
    List foods = macros['foodEntries'] ?? [];

    return ListView(
      children: [
        section("All Foods", foods, macros['id']),
      ],
    );
  }

  Widget section(String title, List foods, int macrosId){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18),),
        const SizedBox(height: 10,),

        ...foods.map((f)=>
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text( "${f['food']} - ${f['grams']}g",
            style: const TextStyle(color: Colors.white),),
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

