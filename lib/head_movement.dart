class HeadMovementDetector {

  final int threshold;

  Function? onNodLeft, onNodRight;

  int _last = 0;

  HeadMovementDetector({required this.threshold, this.onNodLeft, this.onNodRight});

  void update(int x) async {
    int diff = x - _last;
    _last = x;
    if (x.abs() > threshold) {
      x > threshold ? onNodRight?.call() : onNodLeft?.call();
    }
  }
}