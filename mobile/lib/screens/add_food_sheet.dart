import 'package:flutter/material.dart';
import 'package:mobile/services/dailymacros_service.dart';
import 'package:mobile/services/food_service.dart';

import '../models/Food.dart';

class AddFoodSheet extends StatefulWidget {
  final int macrosId;
  final VoidCallback onAdded;


  const AddFoodSheet({super.key, required this.macrosId, required this.onAdded});

  @override
  State<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {

  final searchController = TextEditingController();
  final gramsController = TextEditingController();

  List foods=[];
  Food? selectedFood;
  bool loading= true;


  final FoodService foodService= FoodService();
  final DailymacrosService macrosService = DailymacrosService();

  @override
  void initState() {

    super.initState();
    loadFoods();
  }
  //TODO Change later for optimization, change with recent foods
  void loadFoods() async {
    try {
      final res = await foodService.getAll();

      setState(() {
        foods = res.map((e) => Food.fromJson(e)).toList();
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint("Error loading foods: $e");
    }
  }


  void search(String text) async{
    if(text.isEmpty){
      loadFoods();//TODO replace with recents
      return;
    }
    final res = await foodService.searchFoods(text);

    setState(() {
      foods = res.map((e) => Food.fromJson(e)).toList();
    });
  }

  void addFood() async {
    final grams = int.tryParse(gramsController.text) ?? 0;

    if (selectedFood == null || grams <= 0) return;

    await macrosService.addFood(widget.macrosId, {
      "food": selectedFood!.name,
      "grams": grams,
      "category": "BREAKFAST"
    });

    widget.onAdded();
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: loading
        ?const Center(child: CircularProgressIndicator(),)
            :Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Food",style: TextStyle(color: Colors.white, fontSize: 18) ,),
            const SizedBox(height: 10,),
      
      
            //SEARCH
            TextField(
              controller: searchController,
              onChanged: search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search food...",
                hintStyle: TextStyle(color: Colors.white54)
              ),
            ),
      
            const SizedBox(height: 10,),
      
            //FOODS
            SizedBox(
              height: 220,
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (_, i) {
                  final f = foods[i];
                  final selected = selectedFood == f;
      
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedFood = f);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.redAccent
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${f.calories} kcal | P:${f.protein} C:${f.carbs} F:${f.fat}",
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // SELECTED FOOD
            if (selectedFood != null) ...[
              Text(
                "Selected: ${selectedFood!.name}",
                style: const TextStyle(color: Colors.white),
              ),
      
              const SizedBox(height: 10),
      
              TextField(
                controller: gramsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Grams",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
      
              const SizedBox(height: 10),
      
              ElevatedButton(
                onPressed: addFood,
                child: const Text("Add"),
              )
            ]
      
      
          ],
        )
      );}
    );
  }
}
