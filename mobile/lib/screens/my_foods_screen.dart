import 'package:flutter/material.dart';
import 'package:mobile/screens/add_own_food_screen.dart';
import '../AppColors.dart';
import '../services/food_service.dart';
import '../utils/storage.dart';



class MyFoodsScreen extends StatefulWidget {
  const MyFoodsScreen({super.key});

  @override
  State<MyFoodsScreen> createState() => _MyFoodsScreenState();
}

class _MyFoodsScreenState extends State<MyFoodsScreen> {


  final FoodService service=FoodService();

  List foods = [];

  bool loading=true;


  @override
  void initState() {

    super.initState();
    loadFoods();
  }


  void loadFoods() async{

    final userId= await Storage.getUserId();
    final res = await service.getUserFoods(userId!);
    
    setState(() {
      foods=res;
      loading=false;
      print(res);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: AppColors.background,
      
      appBar: AppBar(
        title: const Text("My Foods"),
        
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            
            onPressed: () async{
              await Navigator.push(context, 
              MaterialPageRoute(builder: (_)=> const AddOwnFoodScreen()));
              
              loadFoods();
            },
            
            
          )
        ],
      ),
      body: loading ? const Center(child: CircularProgressIndicator(),)
      :foods.isEmpty ? const Center(
        child: Text("You haven't created any foods yet",style: TextStyle(color: Colors.white54),),
    ): ListView.builder(
      padding: const EdgeInsets.all(16),
    
      itemCount: foods.length,
      itemBuilder: (_,index)
      {
      final food= foods[index];
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration:BoxDecoration(color: Colors.white10,borderRadius: BorderRadius.circular(16)) ,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(food['name'], style: const TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
      
        const SizedBox(height: 8,),

         Text(

            "${food['calories']} kcal",

            style: const TextStyle(

            color: Colors.white70,

            ),

        ),
        const SizedBox(height: 8,),
      Container(

      padding: const EdgeInsets.symmetric(
      horizontal:10,
      vertical:5,
      ),

      decoration: BoxDecoration(

      color: food['verified']

      ? Colors.green.withOpacity(0.2)

          : Colors.orange.withOpacity(0.2),

      borderRadius: BorderRadius.circular(20),

      ),
      child: Text(

      food['verified']
      ? "Approved"
          : "Pending approval",


      style: TextStyle(

      color: food['verified']
      ? Colors.greenAccent
          : Colors.orangeAccent,

      ),

      ),

      ),
      ],
      ),
      );
      },
    
    )
    );
  }
}
