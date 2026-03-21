enum VisibilityStatus {
  public('PUBLIC'),
  private('PRIVATE'),
  unlisted('UNLISTED')
  ;

  const VisibilityStatus(this.value);

  final String value;

  static VisibilityStatus fromString(String value) {
    for (final status in VisibilityStatus.values) {
      if (status.value == value) return status;
    }
    throw ArgumentError('Invalid visibility status: $value');
  }
}
