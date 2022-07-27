enum Status {
  initial,
  request,
  success,
  failure;

  bool get isInitial => this == initial;

  bool get isRequest => this == request;

  bool get isSuccess => this == success;

  bool get isFailure => this == failure;
}
