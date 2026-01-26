import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'realsense_service.dart';

class RealSenseOverlay extends StatefulWidget {
  const RealSenseOverlay({super.key});

  @override
  State<RealSenseOverlay> createState() => _RealSenseOverlayState();
}

class _RealSenseOverlayState extends State<RealSenseOverlay> {
  Uint8List? _frame;

  @override
  void initState() {
    super.initState();
    _startStream();
  }

  void _startStream() {
    RealSenseService.start();

    RealSenseService.onFrame = (Uint8List bytes) {
      if (!mounted) return;
      setState(() {
        _frame = bytes;
      });
    };
  }

  @override
  void dispose() {
    RealSenseService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_frame == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Opacity(
        opacity: 0.6,
        child: Image.memory(
          _frame!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}