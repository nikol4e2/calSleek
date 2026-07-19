import 'package:flutter/material.dart';
import 'package:mobile/screens/add_own_food_screen.dart';
import 'package:mobile/screens/goals_screen.dart';
import 'package:mobile/screens/my_foods_screen.dart';
import 'package:mobile/screens/progress_screen.dart';
import 'package:mobile/screens/settings_screen.dart';
import '../AppColors.dart';
import '../utils/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String username = "";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final name = await Storage.getUserName();
    final id = await Storage.getUserId();

    setState(() {
      username = name ?? "User";
      userId = id ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryRed,
              child: Text(
                username.isNotEmpty
                    ? username[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),



            const SizedBox(height: 35),

            profileTile(
              Icons.monitor_weight,
              "Weight Progress",
                  () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> const ProgressScreen()));
              },
            ),

            profileTile(
              Icons.flag,
              "Goals",
                  () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> GoalsScreen()));
              },
            ),

            profileTile(
              Icons.restaurant,
              "My Foods",
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyFoodsScreen(),
                        )
                    );
              },
            ),

            profileTile(
              Icons.settings,
              "Settings",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    "CalSleek",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Track calories. Track progress.",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTile(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: AppColors.primaryRed,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
        ),
      ),
    );
  }
}