import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPopup extends StatefulWidget {
  final String path;

  const VideoPlayerPopup({super.key, required this.path});

  @override
  State<VideoPlayerPopup> createState() => _VideoPlayerPopupState();
}

class _VideoPlayerPopupState extends State<VideoPlayerPopup> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: AspectRatio(
        aspectRatio: _initialized ? _controller.value.aspectRatio : 16 / 9,
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }
}