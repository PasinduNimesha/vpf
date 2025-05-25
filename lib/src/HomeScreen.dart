import 'package:flutter/material.dart';
import 'package:vpf/src/CVEInputScreen.dart';
import 'package:vpf/src/ManualInputScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CVEInputScreen()),
                );
              },
              child: const Text('CVE Input'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManualInputScreen()),
                );
              },
              child: const Text('Manual Input'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for another screen
              },
              child: const Text('View Vulerabilities Database'),
            ),
          ],
        ),
      ),
    );
  }
}