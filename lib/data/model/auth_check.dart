import 'dart:convert';

class AuthCheck {
  AuthCheck({
    required this.message,
  });

  String message;

  factory AuthCheck.fromJson(String str) => AuthCheck.fromMap(json.decode(str));

  factory AuthCheck.fromMap(Map<String, dynamic> json) => AuthCheck(
        message: json["message"],
      );
}
