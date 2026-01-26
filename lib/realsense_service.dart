import 'dart:typed_data';
import 'package:flutter/services.dart';

class RealSenseService {
  static const MethodChannel _channel = MethodChannel('realsense');

  static Function(Uint8List)? onFrame;
  static bool _started = false;

  static Future<void> start() async {
    if (_started) return;
    _started = true;

    await _channel.invokeMethod('start');

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'frame') {
        onFrame?.call(call.arguments as Uint8List);
      }
    });
  }

  static Future<void> stop() async {
    if (!_started) return;
    _started = false;

    await _channel.invokeMethod('stop');
  }
}