class DoneDatetime {
  final DateTime? value;

  DoneDatetime([this.value]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoneDatetime &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}