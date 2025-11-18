import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:camera/camera.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

late List<CameraDescription> _cameras;

void main() {
  runApp(const MyApp());
}

// ---------------- MAIN APP ----------------
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

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 2;
  bool isExpanded = false;
  bool iconsVisible = false;

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

  if (fixedPosition) {
    return SizedBox(
      width: 72,
      height: 48,
      child: Stack(
        children: [
          if (isSelected)
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
          Positioned(
            left: 16,
            top: topOffset ?? 0,
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
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Image.asset(navIconAssets[index], height: 28, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          if (isSelected)
            Align(
              alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.25, 0),
              child: Container(width: 40, height: 40, 
              margin: EdgeInsets.only(left: isExpanded ? 15 : 0),
              color: const Color(0xFF2D2D2D)),
            ),
          if (isSelected)
            Align(
              alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.75, 0),
              child: Container(width: 2, height: 20, 
              margin: EdgeInsets.only(left: isExpanded ? 14 : 0),
              color: Colors.blue),
            ),
          Align(
            alignment: isExpanded ? Alignment.centerLeft : const Alignment(-0.3, 0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isExpanded ? 16 : 0),
              child: Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(navIconAssets[index], height: 28, fit: BoxFit.contain),
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

  Widget _buildSidebar() {
    double index0TopOffset = 8.0;

    return Container(
      width: isExpanded ? 200 : 72,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          if (iconsVisible)
            _buildNavItem(0, fixedPosition: false, topOffset: index0TopOffset),
          if (iconsVisible) const SizedBox(height: 8),
          if (iconsVisible) ...[
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/image 2.png'),backgroundColor: Colors.grey),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Lu Li", style: TextStyle(color: Colors.white)),
                        Text("lilu@asv.ai", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.search, color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else
              _buildNavItem(1, showLabel: isExpanded),
            _buildNavItem(2, showLabel: isExpanded),
            const SizedBox(height: 8),
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
            if (isExpanded)
              Container(
                width: 200,
                color: const Color(0xFF2D2D2D),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        page = const Dashboard();
        break;
      default:
        page = const Placeholder();
    }

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              iconsVisible = !iconsVisible;
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
                    onTap: () {
                      setState(() {
                        selectedIndex = 6;
                      });
                    },
                    child: Image.asset('assets/icons/SidebarAbout.png',
                        height: 28, width: 28),
                  ),
                ),
              ]
            : null,
      ),
     body: Stack(
  children: [
    Positioned.fill(
      child: page, // HomePage or other pages
    ),
    Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: _buildSidebar(), // Sidebar overlays the content
    ),
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
    final imgHeight =
        width < 380 ? 200.0 : (width < 600 ? 260.0 : 320.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 0, right: 20, top: 24, bottom: 24),
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

// ---------------- ROBOT CONTROL ----------------
class RobotControl extends StatefulWidget {
  const RobotControl({super.key});

  @override
  State<RobotControl> createState() => _RobotControlState();
}

class _RobotControlState extends State<RobotControl> {
  final MapController _mapController = MapController();

  double _zoom = 13.0;
  final LatLng _center = LatLng(51.5, -0.09);

   bool _isExpanded = false;

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
            Positioned(
  top: 60.0, // keeps space for the title
  left: 0,   // fill from very left
  right: 0,  // fill to very right
  bottom: 10, // bottom padding as before
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
                imageProvider: const AssetImage('assets/MainContent.png'),
              ),
            ],
          ),
        ],
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

             // map and camera toggle
            Positioned(
              top: statusBarHeight + 36,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
        color: Colors.white,
        width: 1.5,
      ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/MapSelected.png',
                      height: 32,
                    ),
                    const SizedBox(width: 16),
                   InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CamControl()),
            );
          },
          child: Image.asset(
            'assets/icons/CameraUnselect.png',
            height: 32,
          ),
        ),
      ],
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
            // Bottom sidebar (from Dashboard)
            _buildBottomSidebar(),
          ],
        ),
      ),
    );
  }

  // Bottom sidebar shared with Dashboard
  Widget _buildBottomSidebar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 260.0 : 72.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Expanded area
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: _isExpanded ? 188 : 0,
              child: Container(
                color: const Color(0xFF1E1E1E),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: _isExpanded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Motion_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Voice_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Route_Edit.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Images_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Settings_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            // Compact sidebar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isExpanded ? 188 : 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => debugPrint('Motion Control pressed'),
                        child: Image.asset(
                          'assets/icons/Motion Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () => debugPrint('Voice Control pressed'),
                        child: Image.asset(
                          'assets/icons/Voice Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () =>
                            setState(() => _isExpanded = !_isExpanded),
                        child: Image.asset(
                          _isExpanded
                              ? 'assets/icons/PlusControl.png'
                              : 'assets/icons/status=Default.png',
                          height: 48,
                        ),
                      ),
                    ],
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

// ---------------- CAMERA CONTROL ----------------
class CamControl extends StatefulWidget {
  const CamControl({super.key});

  @override
  State<CamControl> createState() => _CamControlState();
}

class _CamControlState extends State<CamControl> {
  bool _isExpanded = false;
  List<CameraDescription> _cameras = [];
  CameraController? cameraController;
  double _cameraZoom = 1.0; // initial camera zoom level

  @override
  void initState() {
    super.initState();
    _setupCameraControls();
  }

  void _zoomIn() {
    setState(() {
      _cameraZoom += 0.1;
      if (_cameraZoom > 5.0) _cameraZoom = 5.0; // max zoom
    });
  }

  void _zoomOut() {
    setState(() {
      _cameraZoom -= 0.1;
      if (_cameraZoom < 1.0) _cameraZoom = 1.0; // min zoom
    });
  }

  void _resetZoom() {
    setState(() {
      _cameraZoom = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topOffset = statusBarHeight + 30;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            Positioned(
  top: topOffset + 40,
  bottom: 100.0,
  left: 16.0,
  right: 16.0,
  child: Container(
    color: Colors.black,
    child: cameraController == null || !cameraController!.value.isInitialized
        ? const Center(child: CircularProgressIndicator())
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FittedBox(
              fit: BoxFit.cover, 
              alignment: Alignment.center,
              child: SizedBox(
                width: cameraController!.value.previewSize!.width,
                height: cameraController!.value.previewSize!.height,
                child: Transform.scale(
                  scale: _cameraZoom, 
                  child: CameraPreview(cameraController!),
                ),
              ),
            ),
          ),
  ),
),
    
  

            // Title
            Positioned(
              top: topOffset,
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
              top: topOffset - 6,
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

            // Camera / Map toggle (map button navigates to RobotControl)
            Positioned(
              top: topOffset + 36,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, 3); 
                      },
                      child: Image.asset(
                        'assets/icons/MapNotSelected.png',
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/icons/CamSelected.png',
                      height: 32,
                    ),
                  ],
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

            // Zoom controls
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

            // Bottom sidebar (expanded)
            _buildBottomSidebar(),
          ],
        ),
      ),
    );
  }

  // Bottom sidebar shared with Dashboard
  Widget _buildBottomSidebar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 260.0 : 72.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Expanded area
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: _isExpanded ? 188 : 0,
              child: Container(
                color: const Color(0xFF1E1E1E),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: _isExpanded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Motion_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Voice_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Route_Edit.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Images_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Settings_Control.png',
                                    height: 48,
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            // Compact sidebar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isExpanded ? 188 : 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => debugPrint('Motion Control pressed'),
                        child: Image.asset(
                          'assets/icons/Motion Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () => debugPrint('Voice Control pressed'),
                        child: Image.asset(
                          'assets/icons/Voice Control.png',
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () =>
                            setState(() => _isExpanded = !_isExpanded),
                        child: Image.asset(
                          _isExpanded
                              ? 'assets/icons/PlusControl.png'
                              : 'assets/icons/status=Default.png',
                          height: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraControls() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      cameraController = CameraController(
        _cameras.last,
        ResolutionPreset.high,
      );
      await cameraController!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}



// ---------------- DASHBOARD ----------------
class Dashboard extends StatefulWidget { 
  const Dashboard({super.key}); 

  @override 
  State<Dashboard> createState() => _DashboardState(); 
} 

class _DashboardState extends State<Dashboard> { 
  bool _isExpanded = false; 

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
              onTap: () => Navigator.pop(context), 
              child: Image.asset('assets/icons/back.png', height: 28), 
            ), 
          ), 
          // Title 
          Positioned( 
            top: statusBarHeight + 20, 
            left: 0, 
            right: 0, 
            child: Stack( 
              alignment: Alignment.center, 
              children: [ 
                // Centered robot + #001 
                Row( 
                  mainAxisSize: MainAxisSize.min, 
                  children: [ 
                    Image.asset('assets/icons/robotgray.png', height: 28), 
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
                // Settings icon 
                Positioned( 
                  right: 16, 
                  child: InkWell( 
                    onTap: () => debugPrint('Settings pressed'), 
                    child: Image.asset( 
                      'assets/icons/setting.png', 
                      height: 28, 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ), 
          // Centered column with boxes 
          Center( 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                _buildFirstBox(), 
                const SizedBox(height: 20), 
                _buildSecondBox(), 
                const SizedBox(height: 20), 
                _buildThirdBox(), 
              ], 
            ), 
          ), 
          // Bottom sidebar 
          _buildBottomSidebar(), 
        ], 
      ), 
    ); 
  } 

  // Box 1: System Status 
  Widget _buildFirstBox() { 
    return Container( 
      width: 300, 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration( 
        color: Colors.black, 
        border: Border.all(color: const Color(0xFF898989), width: 3), 
        borderRadius: BorderRadius.circular(8), 
      ), 
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [ 
          _digitColumn(1.08, 'VOLTAGE'), 
          _digitColumn(80, 'RSSi'), 
        ], 
      ), 
    ); 
  } 

  // Box 2: IMU Sensor 
  Widget _buildSecondBox() { 
    return Container( 
      width: 300, 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration( 
        color: Colors.black, 
        border: Border.all(color: const Color(0xFF898989), width: 3), 
        borderRadius: BorderRadius.circular(8), 
      ), 
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.spaceAround, // more spacing 
        children: [ 
          _digitColumn(-5.08, 'ROLL'), 
          _digitColumn(3.39, 'PITCH'), 
          _digitColumn(4.34, 'YAW'), 
        ], 
      ), 
    ); 
  } 

  // Box 3: Gimbal Control Info 
  Widget _buildThirdBox() { 
    return Container( 
      width: 300, 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration( 
        color: Colors.black, 
        border: Border.all(color: const Color(0xFF898989), width: 3), 
        borderRadius: BorderRadius.circular(8), 
      ), 
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [ 
          _digitColumn(23, 'PAN'), 
          _digitColumn(88, 'TILT'), 
          _digitColumn(2, 'SPD_R'), 
        ], 
      ), 
    ); 
  } 

  // Helper method for digits + labels 
  Widget _digitColumn(double value, String label) { 
    return Column( 
      mainAxisSize: MainAxisSize.min, 
      children: [ 
        AnimatedDigitWidget( 
          value: value, 
          fractionDigits: value % 1 == 0 ? 0 : 2, // only show decimals if not integer 
          textStyle: const TextStyle( 
            fontFamily: 'Inter', 
            fontSize: 36, 
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
          ), 
        ), 
        const SizedBox(height: 4), 
        Text( 
          label, 
          style: const TextStyle( 
            fontFamily: 'Inter', 
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFFE3E3E3), 
          ), 
        ), 
      ], 
    ); 
  } 

  // Bottom sidebar 
  Widget _buildBottomSidebar() { 
    return Positioned( 
      left: 0, 
      right: 0, 
      bottom: 0, 
      child: AnimatedContainer( 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut, 
        height: _isExpanded ? 260.0 : 72.0, 
        child: Stack( 
          alignment: Alignment.bottomCenter, 
          children: [ 
            // Expanded area 
            AnimatedPositioned( 
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeInOut, 
              bottom: 0, 
              left: 0, 
              right: 0, 
              height: _isExpanded ? 188 : 0, 
              child: Container( 
                color: const Color(0xFF1E1E1E), 
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), 
                child: _isExpanded ? Column( 
                  mainAxisAlignment: MainAxisAlignment.start, 
                  children: [ 
                    const SizedBox(height: 12), 
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [ 
                        Expanded( 
                          child: Center( 
                            child: Image.asset( 
                              'assets/icons/Motion_Control.png', 
                              height: 48, 
                            ), 
                          ), 
                        ), 
                        Expanded( 
                          child: Center( 
                            child: Image.asset( 'assets/icons/Voice_Control.png', height: 48,), 
                          ), 
                        ), 
                        Expanded( 
                          child: Center( 
                            child: Image.asset( 'assets/icons/Route_Edit.png', height: 48,), 
                          ), 
                        ), 
                      ], 
                    ), 
                    const SizedBox(height: 20), 
                    Row( 
                      children: [ 
                        Expanded( 
                          child: Center( 
                            child: Image.asset('assets/icons/Images_Control.png', height: 48,), 
                          ), 
                        ), 
                        Expanded( 
                          child: Center( 
                            child: Image.asset('assets/icons/Settings_Control.png', height: 48,), 
                          ), 
                        ), 
                        const Expanded(child: SizedBox()), 
                      ], 
                    ), 
                  ], 
                ) : null, 
              ), 
            ), 
            // Compact sidebar 
            AnimatedPositioned( 
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeInOut, 
              bottom: _isExpanded ? 188 : 0, 
              left: 0, 
              right: 0, 
              child: Center( 
                child: Container( 
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                  decoration: BoxDecoration( 
                    color: const Color(0xFF1E1E1E), 
                    borderRadius: BorderRadius.circular(0), 
                  ), 
                  child: Row( 
                    mainAxisSize: MainAxisSize.min, 
                    children: [ 
                      InkWell( 
                        onTap: () => debugPrint('Motion Control pressed'), 
                        child: Image.asset( 'assets/icons/Motion Control.png', height: 48,), 
                      ), 
                      const SizedBox(width: 24), 
                      InkWell( 
                        onTap: () => debugPrint('Voice Control pressed'), 
                        child: Image.asset( 'assets/icons/Voice Control.png', height: 48,), 
                      ), 
                      const SizedBox(width: 24), 
                      InkWell( 
                        onTap: () => setState(() => _isExpanded = !_isExpanded), 
                        child: Image.asset( _isExpanded ? 'assets/icons/PlusControl.png' : 'assets/icons/status=Default.png', height: 48,), 
                      ), 
                    ], 
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

// ----------chatbox ------------------------
// class Chat extends StatefulWidget {
//   const Chat({super.key});

// @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final TextEditingController _chatController = TextEditingController();
//   List<Map<String, String>> messages = <Map<String, String>>[
//     <String, String>{'sender': 'bot', 'text': 'Hello! How can I assist you today?'},
//   ];

// Future<void> query(String prompt) async {

//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Back button
//           Positioned(
//             top: statusBarHeight + 20,
//             left: 16,
//             child: InkWell(
//               onTap: () => Navigator.pop(context),
//               child: Image.asset('assets/icons/back.png', height: 28),
//             ),
//           ),

//           // Title bar
//           Positioned(
//             top: statusBarHeight + 20,
//             left: 0,
//             right: 0,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset('assets/icons/robotgray.png', height: 28),
//                     const SizedBox(width: 8),
//                     const Text(
//                       '# 001',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 18,
//                         color: Color(0xFF898989),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   right: 16,
//                   child: InkWell(
//                     onTap: () => debugPrint('Settings pressed'),
//                     child: Image.asset('assets/icons/setting.png', height: 28),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Chat UI area
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(value: 16.0),
//               child: Column(
//                 children: <Widget[
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: messages.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (index == 0) return SizedBox.shrink();
//                         final Map<String, String> message = messages[index];
//                         return Align( 
//                           message['sender'] == 'user'
//                             ? Alignment.centerLeft
//                             : Alignment.centerRight,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             padding: const EdgeInsets.all(value: 8),
//                             decoration: BoxDecoration(
//                               color: message['sender'] == 'user'
//                                   ? Colors.white
//                                   : Colors.black,
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Text(data:message['text'] ?? ''),
//                             ),
//                           );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
