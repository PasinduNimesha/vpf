import 'package:flutter/material.dart';
import 'package:vpf/src/CVEInputScreen.dart';
import 'package:vpf/src/ManualInputScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey[50]!,
              Colors.blueGrey[100]!,
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('Vulnerability Portal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.blueGrey,
                  )),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.blueGrey),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                      )),
                  const SizedBox(height: 8),
                  Text('Choose an option to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[700],
                      )),
                  const SizedBox(height: 32),
                  _buildMenuCard(
                    context,
                    title: 'CVE Input',
                    subtitle: 'Automatically fetch CVE data',
                    icon: Icons.auto_awesome,
                    color: const [Color(0xFF4A6CF7), Color(0xFF3A4FDC)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CVEInputScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuCard(
                    context,
                    title: 'Manual Input',
                    subtitle: 'Enter vulnerabilities yourself',
                    icon: Icons.edit_document,
                    color: const [Color(0xFF00C89C), Color(0xFF00A885)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManualInputScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuCard(
                    context,
                    title: 'Vulnerabilities Database',
                    subtitle: 'Browse stored vulnerabilities',
                    icon: Icons.computer,
                    color: const [Color(0xFFFF9A44), Color(0xFFFF7C17)],
                    onTap: () {
                      // Placeholder for another screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: color,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          )),
                      const SizedBox(height: 6),
                      Text(subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward,
                      size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}