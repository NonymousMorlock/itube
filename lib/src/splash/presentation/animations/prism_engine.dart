import 'dart:async';

import 'package:flutter/material.dart';

enum PrismState {
  coalescence, // Blobs merging
  breathing, // Idle waiting for data
  crystallizing, // Snapping to shape
  expanding, // Zoom transition
}

class PrismEngine extends ChangeNotifier {
  PrismEngine(this.vsync) {
    _initControllers();
  }
  final TickerProvider vsync;

  // -- Controllers --
  late final AnimationController _introController;
  late final AnimationController _idleController;
  late final AnimationController _outroController;
  late final AnimationController _expansionController;

  // -- State --
  PrismState _state = PrismState.coalescence;
  bool _isDataLoaded = false;

  // -- Shader Uniform Outputs --
  Offset blob1Pos = const Offset(-2, -0.5);
  Offset blob2Pos = const Offset(2, -0.5);
  Offset blob3Pos = const Offset(0, 2);
  double morphFactor = 0;
  double distortion = 0;
  double scale = 1;

  void _initControllers() {
    // 1. INTRO: Heavy, elastic slam (1.5s)
    _introController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. IDLE: Slow sine wave breathing (3s loop)
    _idleController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3000),
    );

    // 3. OUTRO: Sharp mechanical snap (0.6s)
    _outroController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );

    // 4. EXPANSION: Fast exit (0.5s)
    _expansionController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    // --- WIRING PHYSICS ---

    // Coalescence Physics
    final introCurve = CurvedAnimation(
      parent: _introController,
      curve: Curves.elasticOut,
    );
    _introController
      ..addListener(() {
        final t = introCurve.value;
        // Move from edges to slightly offset center positions
        blob1Pos = Offset.lerp(
          const Offset(-2, -1),
          const Offset(-0.2, 0.2),
          t,
        )!;
        blob2Pos = Offset.lerp(const Offset(2, -1), const Offset(0.2, 0.2), t)!;
        blob3Pos = Offset.lerp(const Offset(0, 2), const Offset(0, -0.3), t)!;

        // Ramp up liquid distortion as they impact
        distortion = 0.05 * t;
        notifyListeners();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onIntroComplete();
        }
      });

    // Breathing Physics
    _idleController.addListener(() {
      // Gentle sine wave for distortion (0.05 -> 0.08 -> 0.05)
      distortion = 0.05 + 0.03 * _idleController.value;

      // Slight orbit of blobs to keep it alive
      // (We barely move them so they look like they are vibrating)
      final wobble = 0.05 * (0.5 - _idleController.value);
      blob1Pos = Offset(-0.2 + wobble, 0.2);
      blob2Pos = Offset(0.2 - wobble, 0.2);

      notifyListeners();
    });

    // Crystallization Physics
    final outroCurve = CurvedAnimation(
      parent: _outroController,
      curve: Curves.easeInOutBack,
    );
    _outroController
      ..addListener(() {
        morphFactor = outroCurve.value; // Morph 0 -> 1
        distortion =
            (1.0 - outroCurve.value) * 0.05; // Solidify (Distortion -> 0)

        // Force align to center for perfect triangle
        blob1Pos = Offset.lerp(blob1Pos, Offset.zero, outroCurve.value)!;
        blob2Pos = Offset.lerp(blob2Pos, Offset.zero, outroCurve.value)!;
        blob3Pos = Offset.lerp(blob3Pos, Offset.zero, outroCurve.value)!;

        notifyListeners();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _state = PrismState.expanding;
          unawaited(_expansionController.forward());
        }
      });

    // Expansion Physics
    final expandCurve = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInExpo,
    );
    _expansionController.addListener(() {
      // Scale from 1.0 to 30.0 (fills screen)
      scale = 1.0 + (expandCurve.value * 30.0);
      notifyListeners();
    });
  }

  // --- API ---

  void start() {
    _state = PrismState.coalescence;
    unawaited(_introController.forward());
  }

  void onDataLoaded() {
    _isDataLoaded = true;
    // If we are just breathing, we can exit immediately
    if (_state == PrismState.breathing) {
      _triggerOutro();
    }
    // If intro is still playing, the status listener will handle it
  }

  void _onIntroComplete() {
    if (_isDataLoaded) {
      _triggerOutro();
    } else {
      _state = PrismState.breathing;
      unawaited(_idleController.repeat(reverse: true));
    }
  }

  void _triggerOutro() {
    _idleController.stop();
    _state = PrismState.crystallizing;
    unawaited(_outroController.forward());
  }

  bool get isFinished =>
      _expansionController.status == AnimationStatus.completed;

  @override
  void dispose() {
    _introController.dispose();
    _idleController.dispose();
    _outroController.dispose();
    _expansionController.dispose();
    super.dispose();
  }
}
