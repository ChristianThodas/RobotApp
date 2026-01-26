import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'video_player.dart';
import 'package:video_player/video_player.dart';
import 'camera_subpanel.dart';

enum SidebarScreen { motion, voice, route, images, settings }

// ---------------- Bottom Bar ----------------
class BottomBar extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final SidebarScreen? selectedScreen;
  final Function(SidebarScreen?) onSelectScreen;

  const BottomBar({
    super.key,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.selectedScreen,
    required this.onSelectScreen,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _showCameraSubPanel = false; // flag to show camera subpanel

  // ---------------- Camera SubPanel ----------------
  Widget _buildCameraSubPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _showCameraSubPanel = false; // back to normal expanded content
            });
          },
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text("Camera SubPanel", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: widget.isExpanded ? 260 : 72,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Expanded content area
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: widget.isExpanded ? 188 : 0,
              child: Container(
                color: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                child: _showCameraSubPanel
                    ? _buildCameraSubPanel()
                    : _buildExpandedContent(),
              ),
            ),

            // Compact bar (top three icons)
            Positioned(
              bottom: widget.isExpanded ? 188 : 0,
              left: 0,
              right: 0,
              child: _buildTopThreeIcons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThreeIcons() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => debugPrint('Motion Control pressed'),
              child: Image.asset('assets/icons/Motion Control.png', height: 48),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () => debugPrint('Voice Control pressed'),
              child: Image.asset('assets/icons/Voice Control.png', height: 48),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: widget.onToggleExpanded,
              child: Image.asset(
                widget.isExpanded
                    ? 'assets/icons/PlusControl.png'
                    : 'assets/icons/status=Default.png',
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    if (widget.selectedScreen == null) {
      // Home layout with five icons
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: _bottomIcon(
                    'assets/icons/Motion_Control.png',
                    SidebarScreen.motion,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _bottomIcon(
                    'assets/icons/Voice_Control.png',
                    SidebarScreen.voice,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _bottomIcon(
                    'assets/icons/Route_Edit.png',
                    SidebarScreen.route,
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
                  child: _bottomIcon(
                    'assets/icons/Images_Control.png',
                    SidebarScreen.images,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _bottomIcon(
                    'assets/icons/Settings_Control.png',
                    SidebarScreen.settings,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }

    switch (widget.selectedScreen!) {
      case SidebarScreen.motion:
        return const Center(
          child: Text(
            "Motion Control Screen",
            style: TextStyle(color: Colors.white),
          ),
        );
      case SidebarScreen.voice:
        return const Center(
          child: Text(
            "Voice Control Screen",
            style: TextStyle(color: Colors.white),
          ),
        );
      case SidebarScreen.route:
        return const Center(
          child: Text(
            "Route Edit Screen",
            style: TextStyle(color: Colors.white),
          ),
        );
      case SidebarScreen.images:
        return ImagesPanel(
          onSelect: (file) => debugPrint("Selected file: ${file?.path}"),
          onCameraTap: () {
            setState(() {
              _showCameraSubPanel = true; // show subpanel here
            });
          },
        );
      case SidebarScreen.settings:
        return const Center(
          child: Text("Settings Screen", style: TextStyle(color: Colors.white)),
        );
    }
  }

  Widget _bottomIcon(String asset, SidebarScreen screen) {
    return InkWell(
      onTap: () => widget.onSelectScreen(screen),
      child: Image.asset(asset, height: 48),
    );
  }
}

// ---------------- ImagesPanel ----------------
extension FileTypeCheck on File {
  bool get isImage {
    final lower = path.toLowerCase();
    return lower.endsWith(".jpg") ||
        lower.endsWith(".jpeg") ||
        lower.endsWith(".png");
  }

  bool get isVideo {
    final lower = path.toLowerCase();
    return lower.endsWith(".mp4") ||
        lower.endsWith(".mov") ||
        lower.endsWith(".avi") ||
        lower.endsWith(".mkv");
  }
}

class ImagesPanel extends StatefulWidget {
  final Function(File?) onSelect;
  final VoidCallback onCameraTap;
  const ImagesPanel({
    super.key,
    required this.onSelect,
    required this.onCameraTap,
  });

  @override
  State<ImagesPanel> createState() => _ImagesPanelState();
}

class _ImagesPanelState extends State<ImagesPanel> {
  List<File> mediaFiles = [];
  File? selected;
  DateTime? lastTapTime;
  late Directory galleryDir;

  Future<void> _deleteSelected() async {
    if (selected == null) return;
    try {
      await selected!.delete();
    } catch (_) {}
    selected = null;
    await loadGallery();
  }

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  Future<void> loadGallery() async {
    Directory baseDir;
    if (kIsWeb) {
      return;
    } else if (Platform.isWindows) {
      final pictures = Directory(
        '${Platform.environment['USERPROFILE']}\\Pictures',
      );
      baseDir = Directory('${pictures.path}\\gallery');
    } else {
      baseDir = await getApplicationDocumentsDirectory();
      baseDir = Directory('${baseDir.path}/RobotGallery');
    }

    galleryDir = baseDir;
    if (!await galleryDir.exists()) {
      await galleryDir.create(recursive: true);
    }

    final files = galleryDir.listSync();
    mediaFiles = files
        .whereType<File>()
        .where((f) => f.isImage || f.isVideo)
        .toList();
    setState(() {});
  }

  void handleTap(File file) {
    final now = DateTime.now();
    if (lastTapTime != null &&
        now.difference(lastTapTime!) < const Duration(milliseconds: 300)) {
      openFile(file);
    } else {
      setState(() => selected = file);
      widget.onSelect(file);
    }
    lastTapTime = now;
  }

  void openFile(File file) {
    if (file.isImage) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FullImageScreen(imageFile: file)),
      );
    } else if (file.isVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoFile: file)),
      );
    }
  }

  Widget _buildActionRow() {
    return SizedBox(
      height: 21,
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onCameraTap,
            child: Image.asset(
              'assets/icons/GimbalCamera.png',
              width: 23,
              height: 21,
            ),
          ),
          const SizedBox(width: 12),
          Image.asset('assets/icons/Images.png', width: 23, height: 21),
          const Icon(
            Icons.folder_special_outlined,
            color: Colors.white,
            size: 21,
          ),

          const Spacer(),
          GestureDetector(
            onTap: _deleteSelected,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),
          Image.asset('assets/icons/setting.png', width: 23, height: 21),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) {
      return const Center(
        child: Text(
          "There are no images or videos",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mediaFiles.map((file) {
                return GestureDetector(
                  onTap: () => handleTap(file),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: file == selected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: file.isImage
                        ? Image.file(file, fit: BoxFit.cover)
                        : const Icon(Icons.videocam, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          _buildActionRow(),
        ],
      ),
    );
  }
}

// ---------------- Full Image ----------------
class FullImageScreen extends StatelessWidget {
  final File imageFile;
  const FullImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image")),
      body: Center(child: Image.file(imageFile)),
    );
  }
}

// ---------------- Video Player ----------------
class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;
  const VideoPlayerScreen({super.key, required this.videoFile});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video")),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
