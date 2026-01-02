enum ProcessingStatus {
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  failed('FAILED')
  ;

  const ProcessingStatus(this.value);

  final String value;

  static ProcessingStatus fromString(String value) {
    for (final status in ProcessingStatus.values) {
      if (status.value == value) return status;
    }
    throw ArgumentError('Invalid processing status: $value');
  }
}
