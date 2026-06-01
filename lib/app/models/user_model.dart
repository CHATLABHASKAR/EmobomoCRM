class UserModel {
  final String? email;
  final String? name;
  final String? role;
  final String? token;

  UserModel({
    this.email,
    this.name,
    this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = (json['user'] is Map<String, dynamic>) ? json['user'] as Map<String, dynamic> : <String, dynamic>{};
    return UserModel(
      email: user['email'],
      name: user['name'],
      role: user['role'],
      token: json['token'],
    );
  }

  @override
  String toString() {
    return 'UserModel(email: '
        ' [32m$email [0m, name: $name, role: $role, token: $token)';
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'role': role,
        'token': token,
      };
}
