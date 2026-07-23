import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/services/food_service.dart';
import 'package:mobile/utils/storage.dart';

import '../AppColors.dart';
import '../models/Food.dart';
import '../utils/user_food_cache.dart';

class AddOwnFoodScreen extends StatefulWidget {
  const AddOwnFoodScreen({super.key});

  @override
  State<AddOwnFoodScreen> createState() => _AddOwnFoodScreenState();
}

class _AddOwnFoodScreenState extends State<AddOwnFoodScreen> {

  final FoodService service=FoodService();

  final nameController=TextEditingController();
  final brandController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();

  bool loading=false;

  Future<void> saveFood() async{
    final name  = nameController.text.trim();
    final brand = brandController.text.trim();

    final calories=  int.tryParse(caloriesController.text);
    final protein=  int.tryParse(proteinController.text);
    final carbs=  int.tryParse(carbsController.text);
    final fats=  int.tryParse(fatsController.text);


    if (name.isEmpty) {
      showError("Food name is required");
      return;
    }

    if (name.length < 2) {
      showError("Food name is too short");
      return;
    }

    if (name.length > 60) {
      showError("Food name is too long");
      return;
    }

    if (brand.length > 40) {
      showError("Brand name is too long");
      return;
    }

    if (calories == null ||
        protein == null ||
        carbs == null ||
        fats == null) {
      showError("Please fill all nutrition fields");
      return;
    }
    if (calories <= 0 || calories > 9000) {
      showError("Calories must be between 1 and 9000");
      return;
    }

    if (protein < 0 || protein > 1000) {
      showError("Protein must be between 0 and 1000 g");
      return;
    }

    if (carbs < 0 || carbs > 1000) {
      showError("Carbs must be between 0 and 1000 g");
      return;
    }

    if (fats < 0 || fats > 1000) {
      showError("Fat must be between 0 and 1000 g");
      return;
    }

    final calculatedCalories= protein*4+carbs*4+fats*9;


    if ((calculatedCalories - calories).abs() > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Macros equal $calculatedCalories kcal, but you entered $calories kcal",
          ),
        ),
      );
      return;
    }

    setState(() {
      loading=true;
    });

    try {
      final userId = await Storage.getUserId();

      final res=await service.createFood({
        "name": name,
        "brand": brand,
        "calories": calories,
        "protein": protein,
        "carbs": carbs,
        "fat": fats,
        "userId": userId,
      });

      final newFood=Food.fromJson(res);
      UserFoodCache.foods.add(newFood);
      if (!mounted) return;

      Navigator.pop(context, true);

    }catch (e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }finally {
      if(mounted){

        setState(() {
          loading=false;
        });
      }
    }
    
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  Widget inputField(String label, TextEditingController controller, {bool isNumber=false}){

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 16),
      child: TextField(
        controller:  controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        inputFormatters: isNumber
            ? [
          FilteringTextInputFormatter.digitsOnly,
        ]
            : [],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white10,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16)
          )
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Add Food"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        
        child: Column(
          children: [
            inputField("Food name", nameController,),
            
            inputField("Brand", brandController),
            
            inputField("Calories", caloriesController, isNumber: true),
            
            inputField("Protein (g)", proteinController, isNumber: true),
            inputField("Carbs (g)", carbsController, isNumber: true),
            inputField("Fats (g)", fatsController, isNumber: true),
            
            const SizedBox(height: 20,),
            
            SizedBox(
              width: double.infinity,
              
              child: ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.all(16)
                ),
                
                onPressed: loading ? null : saveFood,
                
                child: loading ? const CircularProgressIndicator() :const Text("Save Food",style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    super.dispose();
  }
}
