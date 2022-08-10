/// Common optional type.
class Optional<T> {
  const Optional(this.value);

  const Optional.empty() : this(null);

  final T? value;
}
