class Option<T> {
  final bool present;
  final T? value;

  const Option(T this.value) : present = true;
  const Option.none() : value = null, present = false;

  const Option.of(this.value) : present = value != null;

  bool get isSome => present;
  bool get isNone => !present;

  @override
  String toString() => present ? "Option($value)" : "Option.none()";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option && present == other.present && value == other.value;

  @override
  int get hashCode => present.hashCode ^ value.hashCode;
}
