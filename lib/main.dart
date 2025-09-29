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
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 2; // default to home page
  bool isExpanded = false;

  final List<IconData> navIcons = [
    Icons.space_dashboard_outlined,
    Icons.search,
    Icons.home,
    Icons.android_outlined,
    Icons.groups_outlined,
    Icons.settings_outlined,
    Icons.info_outline,
  ];

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const Placeholder();
        break;
      case 1:
        page = const Placeholder();
        break;
      case 2:
        page = const HomePage(); // home page
        break;
      case 3:
        page = const Placeholder();
        break;
      case 4:
        page = const Placeholder();
        break;
      case 5:
        page = const Placeholder();
        break;
      case 6:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('ASV ROBOT'),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => isExpanded = !isExpanded),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Right-side button action
              debugPrint("Info button clicked!");
            },
          ),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 72 : 0, // collapse to 0 width when not expanded
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 16),

                if (isExpanded) ...[
                  _buildNavItem(0),
                  _buildNavItem(1),
                  _buildNavItem(2),

                  // Divider between Home and Android
                  const Divider(color: Colors.white24, thickness: 1, indent: 8, endIndent: 8),

                  _buildNavItem(3),

                  const Spacer(),

                  // Divider above bottom group
                  const Divider(color: Colors.white24, thickness: 1, indent: 8, endIndent: 8),
                  _buildNavItem(4),
                  _buildNavItem(5),
                  _buildNavItem(6),
                ],
              ],
            ),
          ),
          Expanded(child: page),
        ],
      ),
    );
  }

  /// Helper for building nav icons
  Widget _buildNavItem(int index) {
    return IconButton(
      icon: Icon(
        navIcons[index],
        color: selectedIndex == index ? Colors.blue : Colors.white,
      ),
      onPressed: () => setState(() => selectedIndex = index),
    );
  }
}

// ---------------- HOME PAGE ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imgHeight = width < 380 ? 200.0 : (width < 600 ? 260.0 : 320.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _metricBig(value: "152,946", unit: "m²", label: "Snow Area"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _metricSmall(value: "12.723", unit: "km", label: "Mileage"),
                const SizedBox(width: 28),
                _metricSmall(value: "12.9", unit: "hrs", label: "Work Time"),
              ],
            ),
            const SizedBox(height: 28),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.asset(
                  'assets/asv robot.png',
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