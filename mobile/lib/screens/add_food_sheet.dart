import 'package:flutter/material.dart';
import 'package:mobile/services/dailymacros_service.dart';
import 'package:mobile/services/food_service.dart';
import 'package:mobile/utils/RecentFoodCache.dart';
import 'package:mobile/utils/user_food_cache.dart';

import '../models/Food.dart';

class AddFoodSheet extends StatefulWidget {
  final int macrosId;
  final String category;
  final VoidCallback onAdded;


  const AddFoodSheet({
    super.key,
    required this.macrosId,
    required this.category,
    required this.onAdded
  });

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

  bool onlyMyFoods=false;





  @override
  void initState() {

    super.initState();
    loadFoods();
  }

  void loadFoods() {
    print("USER FOODS: ${UserFoodCache.foods.length}");
    print("RECENT FOODS: ${Recentfoodcache.foods.length}");

    final List<Food> combined = [];

    combined.addAll(Recentfoodcache.foods);

    for (final food in UserFoodCache.foods) {

      if (!combined.any((f) => f.id == food.id)) {
        combined.add(food);
      }

    }

    setState(() {
      foods = combined;
      loading = false;
    });
  }


  void search(String text) async{
    if(text.isEmpty){
      loadFoods();
      return;
    }
    //MY FOODS ONLY
    if (onlyMyFoods) {

      final result = UserFoodCache.foods.where((food) {

        return food.name
            .toLowerCase()
            .contains(text.toLowerCase());

      }).toList();


      setState(() {
        foods = result;
      });

      return;
    }

    //SEARCH ALL VERIFIED FOODS
    final res = await foodService.searchFoods(text);

    final apiFoods= res.map((e)=>Food.fromJson(e)).toList();

    // SEARCH USER FOODS
    final userFoods = UserFoodCache.foods.where((food) {

      return food.name
          .toLowerCase()
          .contains(text.toLowerCase());

    }).toList();

    final Map<int,Food> merged={};

    for(final food in apiFoods){
      merged[food.id] = food;
    }


    for(final food in userFoods){
      merged[food.id] = food;
    }


    setState(() {
      foods = merged.values.toList();
    });
   
  }

  void addFood() async {
    final grams = int.tryParse(gramsController.text) ?? 0;

    if (selectedFood == null || grams <= 0) return;

    await macrosService.addFood(widget.macrosId, {
      "foodId": selectedFood!.id,
      "grams": grams,
      "category": widget.category
    });

    widget.onAdded();


    Recentfoodcache.foods.removeWhere(
          (f) => f.id == selectedFood!.id,
    );

    Recentfoodcache.foods.insert(0, selectedFood!);

    if (Recentfoodcache.foods.length > 20) {
      Recentfoodcache.foods.removeLast();
    }

    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      child: DraggableScrollableSheet(
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
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Add Food",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,

                title: const Text(
                  "My Foods Only",
                  style: TextStyle(color: Colors.white),
                ),

                value: onlyMyFoods,

                activeColor: Colors.redAccent,

                onChanged: (value){

                  setState(() {
                    onlyMyFoods = value ?? false;
                  });


                  search(searchController.text);

                },
              ),

              const SizedBox(height: 10,),

              //FOODS
              SizedBox(
                height: 220,
                child: ListView.builder(
                  controller: scrollController,
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
      ),
    );
  }
}
