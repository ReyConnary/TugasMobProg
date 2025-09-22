import 'package:flutter/material.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        title: const Text("Diet Plan"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Personalized Diet Plan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "A healthy diet provides the body with essential nutrition: fluid, macronutrients, micronutrients, and adequate calories. "
              "It reduces the risk of chronic diseases, helps maintain a healthy weight, and supports both physical and mental performance.",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benefits of a Healthy Diet:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: "Improves overall health and longevity"),
            const BulletPoint(text: "Helps manage weight effectively"),
            const BulletPoint(text: "Boosts energy and mood"),
            const BulletPoint(text: "Supports heart and brain function"),
            const BulletPoint(text: "Strengthens the immune system"),
            const SizedBox(height: 20),
            const Text(
              "Sample Diet Plan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const DietCard(
              meal: "Breakfast",
              description:
                  "Oatmeal with fresh berries, almonds, and green tea.",
            ),
            const DietCard(
              meal: "Lunch",
              description: "Grilled salmon, quinoa, and steamed vegetables.",
            ),
            const DietCard(
              meal: "Snack",
              description: "Greek yogurt with honey and walnuts.",
            ),
            const DietCard(
              meal: "Dinner",
              description:
                  "Chicken breast with brown rice and roasted vegetables.",
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tip: Stick to whole, unprocessed foods whenever possible. Drink plenty of water, "
                "eat colorful fruits and vegetables, and listen to your body’s hunger cues.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
            ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text("Back to Home"),
),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

class DietCard extends StatelessWidget {
  final String meal;
  final String description;
  const DietCard({super.key, required this.meal, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(meal, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
