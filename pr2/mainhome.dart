import 'package:flutter/material.dart';
import 'dietplan.dart';
import 'exercises.dart';
import 'medicaltips.dart';
import 'yoga.dart';
import 'package:flutter_application_1/pr2/register_page.dart';

class HomePage extends StatelessWidget {
  final RegistrationData data;
  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEFEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Good Morning '${data.name}'",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
  child: GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    children: [
      FeatureCard(
        title: "Diet Plan",
        icon: Icons.fastfood,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DietPage()),
          );
        },
        shrink: true,
      ),
      FeatureCard(
        title: "Exercises",
        icon: Icons.fitness_center,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExercisePage()),
          );
        },
        shrink: true,
      ),
      FeatureCard(
        title: "Medical Tips",
        icon: Icons.local_hospital,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MedicalPage()),
          );
        },
        shrink: true,
      ),
      FeatureCard(
        title: "Yoga",
        icon: Icons.self_improvement,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const YogaPage()),
          );
        },
        shrink: true,
      ),
    ],
  ),
)

,
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Today",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Tomorrow",
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool shrink;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.shrink = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: shrink ? const EdgeInsets.all(12) : const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: shrink ? 36 : 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: shrink ? 14 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

