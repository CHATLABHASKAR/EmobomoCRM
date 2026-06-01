class EmployeeModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? roleId;
  final String? roleName;
  final String? department;
  final String? designation;
  final String? joiningDate;
  final String? location;
  final String? profileImage;

  EmployeeModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.roleId,
    this.roleName,
    this.department,
    this.designation,
    this.joiningDate,
    this.location,
    this.profileImage,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    print("Parsing employee: $json");
    return EmployeeModel(
      firstName: json['firstName'] ?? json['FirstName'] ?? '',
      lastName: json['lastName'] ?? json['LastName'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['PhoneNumber'] ?? '',
      roleId: json['roleId']?.toString() ?? json['RoleId']?.toString(),
      roleName: json['roleName'] ?? json['RoleName'],
      department: json['department'] ?? json['Department'],
      designation: json['designation'] ?? json['Designation'],
      joiningDate: json['joiningDate'] ?? json['JoiningDate'],
      location: json['location'] ?? json['Location'],
      profileImage: json['profileImage'] ?? json['ProfileImage'],
    );
  }

  String get fullName => "$firstName $lastName";
}
