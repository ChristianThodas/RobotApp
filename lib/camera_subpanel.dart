import 'package:flutter/material.dart';

class CameraSubPanel extends StatelessWidget {
  const CameraSubPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 180, // give enough height so top row is visible
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: back button + Photo / Video
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context); // go back to image panel
                },
                child: Image.asset(
                  'assets/icons/back.png',
                  height: 24,
                  width: 24,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Photo',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Video',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Main content
          Center(
            child: Column(
              children: const [
                Icon(Icons.camera_alt, color: Colors.white, size: 36),
                SizedBox(height: 12),
                Text(
                  "Camera Subpanel",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "This panel appears only when GimbalCamera icon is clicked",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
