import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/services/exercise_service.dart';

class AddExerciseSheet extends StatefulWidget {
  final int macrosId;
  final VoidCallback onAdded;

  const AddExerciseSheet({
    super.key,
    required this.macrosId,
    required this.onAdded,
  });

  @override
  State<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<AddExerciseSheet> {
  final ExerciseService service = ExerciseService();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  List exercises = [];
  bool loading = true;

  int? selectedExerciseId;
  String? selectedExerciseName;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  void loadExercises() async {
    try {
      setState(() => loading = true);

      final res = await service.getAllExercises();

      debugPrint("TYPE: ${res.runtimeType}");
      debugPrint("DATA: $res");

      setState(() {
        exercises = res;
        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR: $e");
      setState(() {
        loading = false;
        exercises = [];
      });
    }
  }

  void search(String text) async {
    if (text.isEmpty) {
      loadExercises();
      return;
    }

    final res = await service.searchExercises(text);

    setState(() {
      exercises = res;
    });
  }

  void add() async {
    final minutes = int.tryParse(durationController.text) ?? 0;

    if (selectedExerciseId == null) {
      showError("Please select an exercise");
      return;
    }

    if (minutes == null) {
      showError("Enter valid minutes");
      return;
    }

    if (minutes <= 0) {
      showError("Minutes must be greater than 0");
      return;
    }

    if (minutes > 600) {
      showError("Maximum duration is 600 minutes");
      return;
    }

    await service.addExercise(widget.macrosId, {
      "exerciseId": selectedExerciseId,
      "durationInMinutes": minutes
    });

    widget.onAdded();
    Navigator.pop(context);
  }

  void showError(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const Text(
              "Add Exercise",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: searchController,
              onChanged: search,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search exercise...",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (_, i) {
                  final e = exercises[i];
                  final isSelected = selectedExerciseId == e['id'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedExerciseId = e['id'];
                        selectedExerciseName = e['name'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.redAccent
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${e['caloriesBurnedPerMinute']} kcal/min",
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

            if (selectedExerciseId != null) ...[
              const SizedBox(height: 10),

              Text(
                "Selected: $selectedExerciseName",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Minutes",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: add,
                  child: const Text("Add Exercise"),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}