
import 'package:flutter/material.dart';
import 'package:mobile/utils/storage.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final api=ApiService();
  Map<String, dynamic>? data;

  final int userId=1; //hardcoded


  @override
  void initState() {

    super.initState();
    load();
  }


  void load() async{
    try{
      final res = await api.getDailyMacros(userId);
      setState(() {
        data=res;
      });
    }catch(e){
      print(e);
    }
  }


  void logout() async{
    await Storage.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: data == null
      ? const Center(child: CircularProgressIndicator(),)
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Daily Goal",style: TextStyle(fontSize: 20),),
            const SizedBox(height: 10,),


            Text(
              "${data!['user']['goal']['calories']} kcal",
              style: const TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
