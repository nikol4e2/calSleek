
import 'package:flutter/material.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/goal_service.dart';
import 'package:mobile/services/measurement_service.dart';
import 'package:mobile/utils/storage.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.goal, required this.onNavigate});

  final Map<String, dynamic> goal;
  final Function(int index) onNavigate;


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final api=ApiService();
  final goalApi=GoalService();
  final measurementService = MeasurementService();
  final authService= AuthService();
  Map<String, dynamic>? data;

  Map<String,dynamic>? userData;

  late int userId;
  String? userName;
  Map<String, dynamic>? latestWeight;


  @override
  void initState() {

    super.initState();
    init();
  }

  void init() async {
    userId = await Storage.getUserId() ?? 0;
    final name= await Storage.getUserName();
    setState(() {
      userName=name;
    });
    load();
    loadLatestWeight();
    loadUser();
  }


  void loadUser() async{

    try{
      final res=await authService.getMe();

      setState(() {
        userData=res;
      });

    }
    catch(e)
    {
      debugPrint(e.toString());
    }
  }
  void loadLatestWeight() async {
    try {
      final res = await measurementService.getLatest(userId);

      setState(() {
        latestWeight = res;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  void load() async{
    try{


      final res = await goalApi.getGoalByUserId(userId);
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
          IconButton(
            onPressed: () {
              load();
            },
            icon: const Icon(Icons.refresh),
          ),

          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1C1C1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                const SizedBox(height: 1),
            
                 Text(
                  userName != null ? "Hey $userName " : "Hey",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 2),
            
                const Text(
                  "Here’s your daily overview",
                  style: TextStyle(color: Colors.white54),
                ),
            
                const SizedBox(height: 30),
            
                /// MAIN STATUS CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            
                      const Text(
                        "TODAY'S GOAL",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
            
                      const SizedBox(height: 10),
            
                      Row(
                        children: [
                          SizedBox(width: 6),
            
                          Text(
                            "${data!['calories']} kcal",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
            
                            ),
            
                          ),
                        ],
                      ),
            
            
            
            
            
                    ],
                  ),
                ),
                const SizedBox(height: 20),
            
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
            
                          const Text(
                            "CURRENT WEIGHT",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
            
                          const SizedBox(height: 8),
            
                          Text(
                            latestWeight == null
                                ? "-- kg"
                                : "${latestWeight!['value']} kg",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
            
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.monitor_weight_outlined,
                          color: Colors.redAccent,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
            
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
            
                          const Text(
                            "CURRENT STREAK",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize:12,
                              letterSpacing:1.2,
                            ),
                          ),
            
                          const SizedBox(height:8),
            
                          Text(
                            userData == null
                                ? "-- days"
                                : "${userData!['currentStreak']} days",
                            style: const TextStyle(
                              color:Colors.white,
                              fontSize:30,
                              fontWeight:FontWeight.bold,
                            ),
                          ),
            
                          const SizedBox(height:4),
            
                          Text(
                            userData == null
                                ? ""
                                : "Best: ${userData!['bestStreak']} days",
                            style: const TextStyle(
                              color:Colors.white54,
                            ),
                          ),
            
                        ],
                      ),
            
            
                      Container(
                        padding:const EdgeInsets.all(11),
                        decoration:BoxDecoration(
                          shape:BoxShape.circle,
                          color:Colors.redAccent.withOpacity(0.2),
                        ),
            
                        child: const Icon(
                          Icons.local_fire_department,
                          color:Colors.redAccent,
                          size:32,
                        ),
            
                      )
            
                    ],
                  ),
                ),
            
            
                const Text(
                  "Next step",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
            
                const SizedBox(height: 12),
            
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Log your next meal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onNavigate(1);
            
                        },
                        child: const Text("OPEN"),
                      )
                    ],
                  ),
                ),
            
                const SizedBox(height: 20),
            
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "Consistency beats perfection. Even small tracking today matters.",
                    style: TextStyle(color: Colors.white70, fontSize: 15, ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 2),
            
                const Center(
                  child: Text(
                    "Stay disciplined.",
                    style: TextStyle(color: Colors.white38, fontSize: 15),
                  ),
                ),
            
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      );

  }
}
