import 'dart:async';
import 'dart:math';

import 'package:esense_flutter/esense.dart';

class HeadMovementDetector {

  final int threshold;
  Function? onNodLeft, onNodRight;
  StreamSubscription? _subscription;

  HeadMovementDetector({required this.threshold, this.onNodLeft, this.onNodRight});

  bool calm = true;
  final CircularArray<int> _lastValues = CircularArray(5);
  void update(int x) {
      //Standardabweichung
      _lastValues.add(x);
      double mean = 0;
      for (int element in _lastValues) {
        mean += element;
      }
      mean /= _lastValues.length;
      double variance = 0;
      for (int element in _lastValues) {
          variance += pow(element - mean, 2);
      }
      variance = sqrt(variance);
      //Entscheidung
      if (variance > threshold) {
          if (calm) {
              x > 0 ? onNodLeft?.call() : onNodRight?.call();
              calm = false;
          }
      } else {
          calm = true;
      }
  }

  cancel() => _subscription?.cancel();

  _handleSensorEvent(SensorEvent event) {
    update(event.gyro![1]);
  }

  initStreamSubscription() => _subscription = ESenseManager().sensorEvents.listen(_handleSensorEvent);
}

class CircularArray<T> extends Iterable with Iterator {
  final List<T> _list = [];
  int cap;
  CircularArray(this.cap);

  void add(T t) {
    _list.add(t);
    if (_list.length > cap) {
      _list.removeAt(0);
    }
  }

  @override
  get current => _list.iterator.current;

  @override
  Iterator get iterator => _list.iterator;

  @override
  bool moveNext() => _list.iterator.moveNext();
}