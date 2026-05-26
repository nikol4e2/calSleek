import 'package:flutter/material.dart';
import 'package:mobile/AppColors.dart';

import '../services/dailymacros_service.dart';
import '../utils/storage.dart';


class DailyMacrosScreen extends StatefulWidget {
  const DailyMacrosScreen({super.key});

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
    return Column();
  }
}
