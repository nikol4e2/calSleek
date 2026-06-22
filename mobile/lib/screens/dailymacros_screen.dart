import 'package:flutter/material.dart';
import 'package:mobile/AppColors.dart';

import '../services/dailymacros_service.dart';
import '../utils/storage.dart';
import 'add_food_sheet.dart';
import 'addexercise_sheet.dart';


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
  
  


  void editFoodDialog(int macrosId, Map<String, dynamic> foodEntry) {
    final controller = TextEditingController(
      text: foodEntry['grams'].toString(),
    );

    final food = foodEntry['food'];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            int grams = int.tryParse(controller.text) ?? 0;

            double multiplier = grams / 100;

            int calories =
            ((food['calories'] as num) * multiplier).round();

            int carbs =
            ((food['carbs'] as num) * multiplier).round();

            int protein =
            ((food['protein'] as num) * multiplier).round();

            int fats =
            ((food['fats'] as num) * multiplier).round();

            return Dialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        food['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (_) {
                            setDialogState(() {});
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            suffixText: "g",
                            suffixStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          quickGramButton(
                            50,
                            controller,
                            setDialogState,
                          ),
                          quickGramButton(
                            100,
                            controller,
                            setDialogState,
                          ),
                          quickGramButton(
                            150,
                            controller,
                            setDialogState,
                          ),
                          quickGramButton(
                            200,
                            controller,
                            setDialogState,
                          ),
                          quickGramButton(
                            250,
                            controller,
                            setDialogState,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: macroCard(
                              "Calories",
                              "$calories",
                            ),
                          ),
                          Expanded(
                            child: macroCard(
                              "Protein",
                              "${protein}g",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: macroCard(
                              "Carbs",
                              "${carbs}g",
                            ),
                          ),
                          Expanded(
                            child: macroCard(
                              "Fats",
                              "${fats}g",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (grams <= 0) return;

                                await service.updateFoodEntry(
                                  macrosId,
                                  foodEntry['id'],
                                  grams,
                                );

                                load();

                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text("Save", style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget exerciseSection(Map macros) {
    List logs = macros['exercises'] ?? [];
    int totalBurned = logs.fold<int>(
      0,
          (int sum, e) => sum + ((e['totalBurnedCalories'] ?? 0) as num).toInt(),
    );

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Exercises",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                "-$totalBurned kcal",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (logs.isEmpty)
            const Text(
              "No exercises added",
              style: TextStyle(color: Colors.white38),
            )
          else
            ...logs.map((e) {
              final ex = e['exercise'];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ex['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${e['durationInMinutes']} min",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => AddExerciseSheet(
                    macrosId: macros['id'],
                    onAdded: load,
                  ),
                );
              },
              icon: const Icon(Icons.fitness_center),
              label: const Text("Add exercise"),
            ),
          )
        ],
      ),
    );
  }

  Widget macroCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  Widget quickGramButton(
      int grams,
      TextEditingController controller,
      StateSetter setDialogState,
      ) {
    return ActionChip(
      backgroundColor: Colors.white10,
      label: Text(
        "${grams}g",
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () {
        controller.text = grams.toString();
        setDialogState(() {});
      },
    );
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
      calendarStrip(),
      const SizedBox(height: 12,),
      summaryCard(macros),
      const SizedBox(height: 20,),
      Expanded(child: foodSections(macros)),
      Column(children:[ exerciseSection(macros)])

    ],
    ),
    ),

    );
  }
  
  Widget calendarStrip(){
    final today=DateTime.now();
    
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context,index){
          final date = today.subtract(Duration(days: 4 - index));

          final isSelected =
              date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

          return GestureDetector(
            onTap: (){
              setState(() {
                selectedDate=date;
                loading=true;
              });
              load();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.redAccent : Colors.white10,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.redAccent : Colors.white12,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.day}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _weekday(date.weekday),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekday(int day) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[day - 1];
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

    int totalCarbs = foods.fold(
      0,
          (int sum, f) => sum + ((f['totalCarbs'] ?? 0) as num).toInt(),
    );

    int totalProtein = foods.fold(
      0,
          (int sum, f) => sum + ((f['totalProtein'] ?? 0) as num).toInt(),
    );

    int totalFats = foods.fold(
      0,
          (int sum, f) => sum + ((f['totalFats'] ?? 0) as num).toInt(),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "$totalCalories kcal",
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    "C:$totalCarbs  P:$totalProtein  F:$totalFats",
                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
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

              return Dismissible(
                key: Key(f['id'].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),

                ),
                  child: const Icon(Icons.delete,color: Colors.white,),

                ),

                onDismissed: (_) async {
                  try {
                    await service.deleteFoodEntry(
                      macrosId,
                      f['id'],
                    );

                    load();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Food removed"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                      ),
                    );
                  }
                },
                child: GestureDetector(
                  onTap: ()=>editFoodDialog(macrosId, f),
                  child: Container(
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
                  ),
                ),
              );
            },),

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

