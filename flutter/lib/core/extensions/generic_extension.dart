extension GenericExtension<T> on T? {

  K? whenNotNull<K>(K Function(T value) function) {
    if (this == null) return null;
    return function.call(this as T);
  }
}