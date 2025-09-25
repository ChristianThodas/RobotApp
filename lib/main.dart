import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASV Robot App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Make the image size responsive so it looks good on phone/tablet
    final imgHeight = width < 380 ? 200.0 : (width < 600 ? 260.0 : 320.0);

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 25, backgroundColor: Colors.grey),
                  SizedBox(height: 10),
                  Text("Lu Li", style: TextStyle(color: Colors.white)),
                  Text("lilu@asv.ai", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('Robot No. 1')),
            ListTile(title: Text('New Robot')),
            ListTile(title: Text('Robots')),
            ListTile(title: Text('Settings')),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('ASV ROBOT'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top: Snow Area (centered)
              _metricBig(value: "152,946", unit: "m²", label: "Snow Area"),
              const SizedBox(height: 16),

              // Middle row: Mileage + Work Time (side by side, centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _metricSmall(value: "12.723", unit: "km", label: "Mileage"),
                  const SizedBox(width: 28),
                  _metricSmall(value: "12.9", unit: "hrs", label: "Work Time"),
                ],
              ),

              const SizedBox(height: 28),

              // Bottom: Big centered image
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Image.asset(
                    'assets/asv robot.png', // rename to asv_robot.png if you prefer
                    height: imgHeight,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: imgHeight,
                      width: imgHeight,
                      color: Colors.grey.shade800,
                      alignment: Alignment.center,
                      child: const Text(
                        "Image not found\nassets/asv robot.png",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big metric for the top (Snow Area)
Widget _metricBig({required String value, required String unit, required String label}) {
  return Column(
    children: [
      Text(
        "$value $unit",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white70),
      ),
    ],
  );
}

/// Smaller metrics for the middle row (side by side)
Widget _metricSmall({required String value, required String unit, required String label}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "$value $unit",
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ],
  );
}

