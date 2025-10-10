import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:animated_digit/animated_digit.dart';


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
  int selectedIndex = 2;
  bool isExpanded = false; // Sidebar expanded/collapsed
  bool iconsVisible = false; // Icons visibility

  final List<String> navIconAssets = [
    'assets/icons/SidebarMenu.png',
    'assets/icons/search.png',
    'assets/icons/SidebarHome.png',
    'assets/icons/SidebarRobot.png',
    'assets/icons/SidebarRobots.png',
    'assets/icons/SidebarSettings.png',
    'assets/icons/SidebarAbout.png',
  ];

  final List<String> navLabels = [
    'Menu',
    'Search',
    'Home',
    'Robot No.1',
    'Robots',
    'Settings',
    'About',
  ];

  // ---------------- Nav Item ----------------
 Widget _buildNavItem(int index,
    {bool showLabel = true, bool fixedPosition = false, double? topOffset}) {
  final bool isSelected = selectedIndex == index;

  // Fixed-position item (index 0)
  if (fixedPosition) {
    return SizedBox(
      width: 72,
      height: 48,
      child: Stack(
        children: [
          if (isSelected)
            // selected background (keep original look)
            Positioned(
              left: 0,
              top: topOffset ?? 0,
              child: Container(width: 40, height: 40, color: const Color(0xFF2D2D2D)),
            ),
          if (isSelected)
            Positioned(
              left: 0,
              top: (topOffset ?? 0) + 10,
              child: Container(width: 2, height: 20, color: Colors.blue),
            ),

          // icon (vertically centered relative to the 48 height by using topOffset)
          Positioned(
            left: 16,
            top: topOffset ?? 0,
            child: InkWell(
              onTap: () {
  setState(() {
    if (index == 0) {
      isExpanded = !isExpanded; // only toggle sidebar
    } else {
      selectedIndex = index; // normal navigation
    }
  });
},
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Image.asset(navIconAssets[index], height: 24, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Regular nav items (1..6)
  return SizedBox(
    width: isExpanded ? 200 : 72,
    height: 48,
    child: InkWell(
      onTap: () {
  setState(() {
    if (index == 0) {
      isExpanded = !isExpanded;
    } else {
      selectedIndex = index;
    }
  });
},
      child: Stack(
        children: [
          // selected background rectangle
          if (isSelected)
            Align(
              alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.25, 0),
              child: Container(width: 40, height: 40, color: const Color(0xFF2D2D2D)),
            ),

          // selected left accent bar
          if (isSelected)
            Align(
              alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.75, 0),
              child: Container(width: 2, height: 20, color: Colors.blue),
            ),

          // Content: icon + optional label
          Align(
            alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.3, 0),
            child: Padding(
              // Match left padding used elsewhere when expanded (16)
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 16 : 0),
              child: Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // keep a fixed icon height to ensure vertical alignment
                  Image.asset(navIconAssets[index], height: 24, fit: BoxFit.contain),
                  if (showLabel && isExpanded) ...[
                    const SizedBox(width: 12),
                    Text(
                      navLabels[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // ---------------- Divider ----------------
  Widget _buildCenteredDivider(
      {double lineWidth = 40, double thickness = 1, double horizontalShift = -5}) {
    return Container(
      height: thickness,
      width: 72,
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(horizontalShift, 0),
        child: Container(height: thickness, width: lineWidth, color: const Color(0xFF585858)),
      ),
    );
  }

  // ---------------- Sidebar ----------------
  Widget _buildSidebar() {
  // Offset to align index 0 with other icons
  double index0TopOffset = 8.0;

  return Container(
    width: isExpanded ? 200 : 72,
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),

        // Index 0: appears only after top menu icon clicked
        if (iconsVisible)
          _buildNavItem(0, fixedPosition: true, topOffset: index0TopOffset),
        if (iconsVisible) const SizedBox(height: 8),

        if (iconsVisible) ...[
          if (isExpanded) ...[
            // User info above search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const CircleAvatar(radius: 25, backgroundColor: Colors.grey),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Lu Li", style: TextStyle(color: Colors.white)),
                      Text("lilu@asv.ai",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar replaces index 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 36, // smaller height
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon:
                        const Icon(Icons.search, color: Colors.black), // right side
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ] else
            _buildNavItem(1, showLabel: isExpanded),

          // Remaining top group: index 2–3
          _buildNavItem(2, showLabel: isExpanded),
          const SizedBox(height: 8),

          // Divider 1
          if (isExpanded) ...[
            Container(
              height: 1,
              width: 200,
              color: const Color(0xFF585858),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Workspace',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ] else
            _buildCenteredDivider(),
          const SizedBox(height: 8),

          _buildNavItem(3, showLabel: isExpanded),

          const Spacer(),

          // Divider 2 → "New Robot" box when expanded
          if (isExpanded)
            Container(
              width: 200,
              color: const Color(0xFF2D2D2D),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/icons/SidebarRobot.png', height: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'New Robot',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            _buildCenteredDivider(),
          const SizedBox(height: 8),

          _buildNavItem(4, showLabel: isExpanded),
          const SizedBox(height: 8),
          _buildNavItem(5, showLabel: isExpanded),
          const SizedBox(height: 8),
          _buildNavItem(6, showLabel: isExpanded),
          const SizedBox(height: 16),
        ],
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // Determine page to show
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const Placeholder();
        break;
      case 1:
        page = const Placeholder();
        break;
      case 2:
        page = const HomePage();
        break;
      case 3:
        page = const RobotControl();
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
        page = const Placeholder();
    }

      return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              iconsVisible = !iconsVisible; // toggle visibility of sidebar icons
            });
          },
        ),
        title: selectedIndex == 2
      ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/logo_white.png', height: 28),
            const SizedBox(width: 8),
            const Text(
              'ASV ROBOT',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        )
        : null,
        actions: selectedIndex == 2
      ? [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => debugPrint("Right image clicked!"),
              child: Image.asset('assets/icons/SidebarAbout.png', height: 28, width: 28),
            ),
          ),
        ]
        : null,
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: page),
        ],
      ),
    );
  }
}


// ---------------- HOME PAGE ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imgHeight = width < 380
        ? 200.0
        : (width < 600 ? 260.0 : 320.0);

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



// ---------------- Robot Control PAGE ----------------


class RobotControl extends StatefulWidget {
  const RobotControl({super.key});

  @override
  State<RobotControl> createState() => _RobotControlState();
}

class _RobotControlState extends State<RobotControl> {
  final MapController _mapController = MapController();

  double _zoom = 13.0;
  final LatLng _center = LatLng(51.5, -0.09);

  void _zoomIn() {
    setState(() => _zoom += 0.5);
    _mapController.move(_center, _zoom);
  }

  void _zoomOut() {
    setState(() {
      if (_zoom > 1) _zoom -= 0.5;
    });
    _mapController.move(_center, _zoom);
  }

  void _resetZoom() {
    setState(() => _zoom = 13.0);
    _mapController.move(_center, _zoom);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16, bottom:10),
               child: Container(
      color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: _zoom,
                  ),
                  children: [
                    OverlayImageLayer(
                      overlayImages: [
                        OverlayImage(
                          bounds: LatLngBounds(
                            LatLng(51.49, -0.10),
                            LatLng(51.51, -0.08),
                          ),
                          opacity: 1.0,
                          imageProvider:
                              const AssetImage('assets/MainContent.png'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ),

            // Title
            Positioned(
              top: statusBarHeight,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/robotgray.png',
                    height: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '# 001',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: Color(0xFF898989),
                    ),
                  ),
                ],
              ),
            ),

            // Dashboard
              Positioned(
              top: statusBarHeight - 6,
              right: 16,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Dashboard()),
                  );
                },
                child: Image.asset(
                  'assets/icons/Dashboard.png',
                  height: 28,
                ),
              ),
            ),

            // Bottom sidebar
            Positioned(
              bottom: 9,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Motion Control
                      InkWell(
                        onTap: () => debugPrint('Motion Control pressed'),
                        child: Image.asset(
                          'assets/icons/Motion Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Voice Control
                      InkWell(
                        onTap: () => debugPrint('Voice Control pressed'),
                        child: Image.asset(
                          'assets/icons/Voice Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Status Hover
                      InkWell(
                        onTap: () => debugPrint('Status Hover pressed'),
                        child: Image.asset(
                          'assets/icons/status=Default.png',
                          height: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //  Zoom controls
            Positioned(
              right: 20,
              bottom: 100, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 48,
                    onPressed: _zoomIn,
                    icon: Image.asset('assets/icons/out.png'),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    iconSize: 48,
                    onPressed: _zoomOut,
                    icon: Image.asset('assets/icons/in.png'),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    iconSize: 48,
                    onPressed: _resetZoom,
                    icon: Image.asset('assets/icons/power.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------DASHBOARD PAGE------//

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: statusBarHeight + 20,
            left: 16,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/icons/back.png',
                height: 28,
              ),
            ),
          ),

          // Title 
          Positioned(
            top: statusBarHeight + 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/robotgray.png',
                  height: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  '# 001',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: Color(0xFF898989),
                  ),
                ),
              ],
            ),
          ),

          // Centered dashboard text
          const Center(
            child: Text(
              'Dashboard Page',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}