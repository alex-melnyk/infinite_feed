class AuthCheck {
  const AuthCheck({
    required this.message,
  });

  factory AuthCheck.fromMap(Map<String, dynamic> map) {
    return AuthCheck(
      message: map['message'],
    );
  }

  final String message;
}
