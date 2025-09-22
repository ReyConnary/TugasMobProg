import 'package:flutter/material.dart';

class MedicalPage extends StatelessWidget {
  const MedicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEFEF),
      appBar: AppBar(
        title: const Text("Medical Tips"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Intro
            const Text(
              "Welcome to Your Daily Medical Tips",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Medicine is the science and practice of maintaining health, "
              "preventing illness, and treating disease. Here you can find "
              "useful tips for a healthier lifestyle, common prevention methods, "
              "and guidance to improve your daily well-being.",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Benefits
            const Text(
              "Benefits of Following Medical Advice:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: "Improves overall health and immunity"),
            const BulletPoint(text: "Helps prevent chronic diseases"),
            const BulletPoint(text: "Guides proper nutrition and exercise"),
            const BulletPoint(text: "Boosts mental health and energy"),
            const BulletPoint(text: "Supports better sleep and recovery"),
            const SizedBox(height: 20),

            // Tips section
            const Text(
              "Daily Health Tips:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MedicalTips(
              title: "Stay Hydrated",
              description: "Drink at least 8 glasses of water daily to maintain hydration and support body functions.",
              icon: Icons.local_drink,
            ),
            MedicalTips(
              title: "Regular Check-ups",
              description: "Schedule routine medical check-ups to detect potential health issues early.",
              icon: Icons.medical_information,
            ),
            MedicalTips(
              title: "Balanced Diet",
              description: "Eat a mix of vegetables, fruits, protein, and whole grains for proper nutrition.",
              icon: Icons.restaurant,
            ),
            MedicalTips(
              title: "Exercise",
              description: "Engage in at least 30 minutes of physical activity daily to stay fit and strong.",
              icon: Icons.fitness_center,
            ),
            MedicalTips(
              title: "Good Sleep",
              description: "Aim for 7–8 hours of quality sleep every night to allow your body to recharge.",
              icon: Icons.bedtime,
            ),
            const SizedBox(height: 20),

            // Doctors list (placeholder for future feature)
            const Text(
              "Recommended Specialists:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DoctorTile(
              name: "Dr. Sarah Johnson",
              specialty: "General Physician",
            ),
            DoctorTile(
              name: "Dr. Ahmed Khan",
              specialty: "Cardiologist",
            ),
            DoctorTile(
              name: "Dr. Maria Lopez",
              specialty: "Nutritionist",
            ),
            DoctorTile(
              name: "Dr. Kenji Yamamoto",
              specialty: "Orthopedic Specialist",
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tip: Prevention is better than cure. Follow simple medical guidelines daily, "
                "and consult a healthcare professional if you experience unusual symptoms. "
                "Your health is your greatest investment.",
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

class MedicalTips extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const MedicalTips({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  final String name;
  final String specialty;

  const DoctorTile({super.key, required this.name, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(specialty),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
