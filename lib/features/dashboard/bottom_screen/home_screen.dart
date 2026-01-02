import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();

  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Text(
              "Enter Values:",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 10),

            const Text(
              "Addition of two numbers",
              style: TextStyle(fontFamily: "OpenSans", fontSize: 18),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: num1Controller,
              decoration: const InputDecoration(
                labelText: "Number 1",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: num2Controller,
              decoration: const InputDecoration(
                labelText: "Number 2",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  double n1 = double.tryParse(num1Controller.text) ?? 0;
                  double n2 = double.tryParse(num2Controller.text) ?? 0;

                  double sum = n1 + n2;

                  setState(() {
                    result = "Sum = $sum";
                  });
                },
                child: const Text("Calculate"),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
