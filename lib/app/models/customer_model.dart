// lib/app/models/customer_model.dart

class CustomerModel {
  final String id;
  final String name;
  final String? companyName;
  final String phone;
  final String email;
  final String? gst;
  final String contactName;
  final String? alternativePhone;
  final String salesContact;
  final String source;
  final String? followUpDate;
  final String demo;
  final String city;
  final String state;
  final String? companyDescription;
  final String? notes;
  final String addressLine1;
  final String? addressLine2;
  final String? profileImage;

  CustomerModel({
    required this.id,
    required this.name,
    this.companyName,
    required this.phone,
    required this.email,
    this.gst,
    required this.contactName,
    this.alternativePhone,
    required this.salesContact,
    required this.source,
    this.followUpDate,
    required this.demo,
    required this.city,
    required this.state,
    this.companyDescription,
    this.notes,
    required this.addressLine1,
    this.addressLine2,
    this.profileImage,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? json['PK']?.toString() ?? '',
      name: json['name'] ?? json['Name'] ?? '',
      companyName: json['companyName'] ?? json['company'] ?? json['Name'],
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gst: json['gst'],
      contactName: json['contactName'] ?? '',
      alternativePhone: json['alternativePhone'] ?? json['altPhone'],
      salesContact: json['salesContact'] ?? json['CreatedBy'] ?? '',
      source: json['source'] ?? '',
      followUpDate: json['followUpDate'],
      demo: json['demo'] ?? json['status'] ?? json['Status'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      companyDescription: json['companyDescription'] ?? json['leadDescription'],
      notes: json['notes'] ?? json['remark'],
      addressLine1: json['addressLine1'] ?? json['address'] ?? '',
      addressLine2: json['addressLine2'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (companyName != null) 'companyName': companyName,
    'phone': phone,
    'email': email,
    if (gst != null) 'gst': gst,
    'contactName': contactName,
    if (alternativePhone != null) 'alternativePhone': alternativePhone,
    'salesContact': salesContact,
    'source': source,
    if (followUpDate != null) 'followUpDate': followUpDate,
    'demo': demo,
    'city': city,
    'state': state,
    if (companyDescription != null) 'companyDescription': companyDescription,
    if (notes != null) 'notes': notes,
    'addressLine1': addressLine1,
    if (addressLine2 != null) 'addressLine2': addressLine2,
    if (profileImage != null) 'profileImage': profileImage,
  };

  CustomerModel copyWith({
    String? id,
    String? name,
    String? companyName,
    String? phone,
    String? email,
    String? gst,
    String? contactName,
    String? alternativePhone,
    String? salesContact,
    String? source,
    String? followUpDate,
    String? demo,
    String? city,
    String? state,
    String? companyDescription,
    String? notes,
    String? addressLine1,
    String? addressLine2,
    String? profileImage,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gst: gst ?? this.gst,
      contactName: contactName ?? this.contactName,
      alternativePhone: alternativePhone ?? this.alternativePhone,
      salesContact: salesContact ?? this.salesContact,
      source: source ?? this.source,
      followUpDate: followUpDate ?? this.followUpDate,
      demo: demo ?? this.demo,
      city: city ?? this.city,
      state: state ?? this.state,
      companyDescription: companyDescription ?? this.companyDescription,
      notes: notes ?? this.notes,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      profileImage: profileImage ?? this.profileImage,
    );
  }
} 