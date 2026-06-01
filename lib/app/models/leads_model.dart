class LeadModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status;
  final String source;

  LeadModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.source,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'status': status,
    'source': source,
  };
}
