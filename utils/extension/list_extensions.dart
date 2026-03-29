extension SafeList<T> on List<T> {
  T? getOrNull(int index) =>
      (index >= 0 && index < length) ? this[index] : null;

  bool get isValidIndexZeroBased => isNotEmpty;

  bool isValidIndex(int index) => index >= 0 && index < length;

  T? firstWhereOrNull(bool Function(T e) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
