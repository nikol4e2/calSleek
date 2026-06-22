import 'package:flutter/material.dart';
import 'package:mobile/services/exercise_service.dart';


class AddExerciseSheet extends StatefulWidget {

  final int macrosId;
  final VoidCallback onAdded;




  const AddExerciseSheet({super.key, required this.macrosId,  required this.onAdded,});

  @override
  State<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<AddExerciseSheet> {
  final durationController = TextEditingController();

  int? selectedExercise;

  final ExerciseService service= ExerciseService();

  void add() async{
    final minutes = int.tryParse(durationController.text) ?? 0;

    if(selectedExercise == null || minutes < 0 ) return;

    await service.addExercise(widget.macrosId, {
      "exerciseId": selectedExercise,
      "durationInMinutes": minutes
    });

    widget.onAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
        const Text("Add Exercise"),

          TextField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Minutes"),
          ),

      const SizedBox(height: 10),

          ElevatedButton(
              onPressed: add,
              child: const Text("Add"),
          )
        ]
      ),
    );
  }
}
