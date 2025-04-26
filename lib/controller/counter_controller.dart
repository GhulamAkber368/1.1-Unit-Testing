class Counter {
  int _count = 0;
  int get count => _count;

  void incrementCounter() {
    _count++;
  }

  void decrementCounter() {
    _count--;
  }

  void reset() {
    _count = 0;
  }
}
