import 'dart:async';

class SessionObserver {
  final _controller = StreamController<void>.broadcast();
  Stream<void> get onSessionExpired => _controller.stream;

  void invalidate() {
    _controller.add(null);
  }
}
