import 'dart:async';

import 'package:esense_flutter/esense.dart';

class HeadMovementDetector {

  final int threshold;
  Function? onNodLeft, onNodRight;
  int _last = 0, _cooldown = 0;
  StreamSubscription? _subscription;

  HeadMovementDetector({required this.threshold, this.onNodLeft, this.onNodRight});

  void update(int x) async {
    int diff = x - _last;
    _last = x;
    if (_cooldown == 0) {
      if (diff.abs() > threshold) {
        diff > threshold ? onNodRight?.call() : onNodLeft?.call();
        _cooldown = 5;
      }
    } else {
      _cooldown--;
    }
  }

  cancel() => _subscription?.cancel();

  _handleSensorEvent(SensorEvent event) {
    update(event.gyro![1]);
  }

  initStreamSubscription() => _subscription = ESenseManager().sensorEvents.listen(_handleSensorEvent);
}