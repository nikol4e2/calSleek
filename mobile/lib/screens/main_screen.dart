import 'package:flutter/material.dart';
import 'package:mobile/screens/dailymacros_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/services/goal_service.dart';

import '../utils/storage.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.userId});

  final int userId;





  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex=0;

  Map<String, dynamic>? goal;
  bool loading=false;

  final List<Widget> pages= [];


  void load() async {
    final res = await GoalService().getGoalByUserId(widget.userId);

    setState(() {
      goal = res;
      loading = false;
    });
  }

  @override
  void initState() {

    super.initState();
    loading=true;
    load();
  }


  @override
  Widget build(BuildContext context) {


    if(loading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );

    }
    final pages= [
      HomeScreen(goal: goal!, onNavigate: (index){
        setState(() {
          currentIndex=index;
        });
      }),
      DailyMacrosScreen(goal: goal!),
      const Placeholder(),
      const Placeholder(),
    ];
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          border: Border(
            top: BorderSide(color: Colors.white10),
          )
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF000000),
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Diary",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
      ),
        ])
      )


    );
  }
}
