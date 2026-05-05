
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

  int? userId;



  @override
  void initState() {

    super.initState();
    init();
  }

  void init() async {
    userId = await Storage.getUserId();
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
      : Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors:
          [Color(0xFF0F0F0F), Color(0xFF1C1C1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Today's Goal", style: TextStyle(fontSize: 22,color: Colors.white70, fontWeight: FontWeight.w500),),

            const SizedBox(height: 25,),

            Container(
              height: 180,
              width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Colors.redAccent, Colors.deepOrange], begin: Alignment.topLeft, end: Alignment.bottomRight),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 5
                    )
                  ],
                ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("CALORIES", style: TextStyle(color: Colors.white70, fontSize: 20, letterSpacing: 1.2, fontWeight: FontWeight.bold),),
                    
                    const SizedBox(height: 8,),
                    
                    Text("${data!['user']['goal']['calories']}",style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),)
                    
                  ],
                ),
              ),
            )
          ],
        ),
        )
      );

  }
}
