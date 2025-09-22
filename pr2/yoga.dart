import 'package:flutter/material.dart';

class YogaPage extends StatelessWidget {
  const YogaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEFEF),
      appBar: AppBar(title: const Text("Yoga"), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Welcome to Your Daily Yoga Practice",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Yoga is a holistic practice that combines movement, breathing, and mindfulness. "
              "It helps improve flexibility, build strength, reduce stress, and enhance overall well-being. "
              "Whether you're a beginner or an advanced practitioner, this guide will help you start your journey.",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),

            const Text(
              "Benefits of Yoga:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: "Improves flexibility and posture"),
            const BulletPoint(text: "Builds muscle strength and balance"),
            const BulletPoint(text: "Reduces stress and promotes relaxation"),
            const BulletPoint(text: "Boosts energy and mental clarity"),
            const BulletPoint(text: "Supports better sleep"),
            const SizedBox(height: 20),

            const Text(
              "Popular Yoga Poses:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            YogaPoseTile(
              pose: "Mountain Pose (Tadasana)",
              description:
                  "A grounding pose that improves posture and stability.",
            ),
            YogaPoseTile(
              pose: "Downward Dog (Adho Mukha Svanasana)",
              description:
                  "Strengthens the arms and legs while stretching the spine.",
            ),
            YogaPoseTile(
              pose: "Child's Pose (Balasana)",
              description:
                  "A restful pose that calms the mind and relieves tension.",
            ),
            YogaPoseTile(
              pose: "Warrior II (Virabhadrasana II)",
              description:
                  "Builds stamina and strengthens legs, hips, and shoulders.",
            ),
            YogaPoseTile(
              pose: "Tree Pose (Vrikshasana)",
              description:
                  "Enhances balance and concentration while strengthening the legs.",
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tip: Start small with just 10 minutes of yoga daily. "
                "Consistency matters more than intensity. Breathe deeply, "
                "listen to your body, and enjoy the process of becoming more mindful and balanced.",
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

class YogaPoseTile extends StatelessWidget {
  final String pose;
  final String description;
  const YogaPoseTile({
    super.key,
    required this.pose,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(pose, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
