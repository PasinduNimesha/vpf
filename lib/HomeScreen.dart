import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vulnerability Overview',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const VulnerabilityOverviewPage(),
    );
  }
}

class VulnerabilityOverviewPage extends StatelessWidget {
  const VulnerabilityOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vulnerability Overview'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Input card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'CVE Identifier',
                        hintText: 'e.g., CVE-2023-12345',
                        prefixIcon: Icon(Icons.search, color: Colors.indigo),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Asset Type',
                        prefixIcon: Icon(Icons.storage, color: Colors.indigo),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'db', child: Text('Database with sensitive info')),
                        DropdownMenuItem(value: 'server', child: Text('Internal server')),
                        DropdownMenuItem(value: 'ecommerce', child: Text('E-commerce website')),
                        DropdownMenuItem(value: 'blog', child: Text('Public blog')),
                      ],
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Adjust Scoring Weights',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('CVSS', style: TextStyle(fontWeight: FontWeight.w500)),
                              Slider(
                                value: 0.6,
                                min: 0,
                                max: 1,
                                divisions: 10,
                                onChanged: (_) {},
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('EPSS', style: TextStyle(fontWeight: FontWeight.w500)),
                              Slider(
                                value: 0.4,
                                min: 0,
                                max: 1,
                                divisions: 10,
                                onChanged: (_) {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics, size: 24),
                        label: const Text('Analyze Vulnerability'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Example results card (placeholder)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security, color: Colors.red, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Assessment Results',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    const ListTile(
                      leading: Icon(Icons.speed, color: Colors.indigo),
                      title: Text('CVSS Score'),
                      trailing: Text('8.5'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.trending_up, color: Colors.purple),
                      title: Text('EPSS Score'),
                      trailing: Text('0.72'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.score, color: Colors.teal),
                      title: Text('Priority Score'),
                      trailing: Text('1.45'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.layers, color: Colors.orange),
                      title: Text('Severity'),
                      trailing: Chip(
                        label: Text('Critical'),
                        backgroundColor: Color(0xFFFFEBEE),
                        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Chip(
                        avatar: Icon(Icons.priority_high, color: Colors.red),
                        label: Text('Critical – Fix ASAP'),
                        backgroundColor: Color(0xFFFFCDD2),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
