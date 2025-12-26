import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/src/splash/presentation/animations/prism_engine.dart';

/// A self-contained widget that handles the Shader loading and Painting
class MoltenPrism extends StatefulWidget {
  const MoltenPrism({required this.engine, super.key});

  final PrismEngine engine;

  @override
  State<MoltenPrism> createState() => _MoltenPrismState();
}

class _MoltenPrismState extends State<MoltenPrism> {
  ui.FragmentProgram? _program;

  @override
  void initState() {
    super.initState();
    unawaited(_loadShader());
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'shaders/molten_prism.frag',
      );
      if (mounted) {
        setState(() => _program = program);
      }
    } on Exception catch (e) {
      debugPrint('Error loading shader: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: widget.engine,
      builder: (context, child) {
        return CustomPaint(
          size: context.screenSize,
          painter: _PrismPainter(
            shader: _program!.fragmentShader(),
            engine: widget.engine,
            time: DateTime.now().millisecondsSinceEpoch / 1000.0,
          ),
        );
      },
    );
  }
}

class _PrismPainter extends CustomPainter {
  _PrismPainter({
    required this.shader,
    required this.engine,
    required this.time,
  });

  final ui.FragmentShader shader;
  final PrismEngine engine;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Pass Uniforms to GPU (Strict Order Match with GLSL)
    // 0: uResolution (vec2)
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      // 1: uTime (float)
      ..setFloat(2, time)
      // 2: uBlob1 (vec2)
      ..setFloat(3, engine.blob1Pos.dx)
      ..setFloat(4, engine.blob1Pos.dy)
      // 3: uBlob2 (vec2)
      ..setFloat(5, engine.blob2Pos.dx)
      ..setFloat(6, engine.blob2Pos.dy)
      // 4: uBlob3 (vec2)
      ..setFloat(7, engine.blob3Pos.dx)
      ..setFloat(8, engine.blob3Pos.dy)
      // 5: uMorph (float)
      ..setFloat(9, engine.morphFactor)
      // 6: uDistortion (float)
      ..setFloat(10, engine.distortion)
      // 7: uScale (float)
      ..setFloat(11, engine.scale);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _PrismPainter oldDelegate) {
    return true;
  }
}
