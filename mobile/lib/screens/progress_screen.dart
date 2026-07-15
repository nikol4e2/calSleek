import 'package:flutter/material.dart';
import '../services/measurement_service.dart';
import '../utils/storage.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final MeasurementService service = MeasurementService();

  List measurements = [];

  bool loading = true;

  int? userId;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    userId = await Storage.getUserId();

    final res = await service.getAll(userId!);

    setState(() {
      measurements = res;
      loading = false;
    });
  }

  void addWeightDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),

          title: const Text(
            "Add weight",
            style: TextStyle(color: Colors.white),
          ),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                final weight = double.tryParse(controller.text);

                if (weight == null) return;

                await service.addMeasurement(userId!, weight);

                Navigator.pop(context);
                load();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    double currentWeight = measurements.isNotEmpty
        ? (measurements.last['value'] as num).toDouble()
        : 0;

    double startWeight = measurements.isNotEmpty
        ? (measurements.first['value'] as num).toDouble()
        : 0;

    double difference = currentWeight - startWeight;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(title: const Text("Progress")),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current weight",
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$currentWeight kg",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      difference <= 0
                          ? "${difference.abs()} kg lost"
                          : "+$difference kg gained",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Weight history",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: addWeightDialog,
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: measurements.length,
                  itemBuilder: (_, index) {
                    final m = measurements[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${m['value']} kg",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            m['date'].toString().substring(0, 10),
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
