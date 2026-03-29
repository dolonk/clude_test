/// GLobal Null Safety Extensions
extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ListUtils<T> on List<T> {
  void removeAtOrNull(int index) {
    if (index >= 0 && index < length) {
      removeAt(index);
    }
  }
}
