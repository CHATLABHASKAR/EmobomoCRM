class OnboardingModel {
  String? employeeId;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? joiningDate;
  String? terminationDate;
  String? employeeAddress;
  String? officeAddress;
  String? password;
  String? personalEmail;
  String? professionalEmail;
  String? phoneNumber;
  String? roleName;
  String? companyPk;

  OnboardingModel({
    this.employeeId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.joiningDate,
    this.terminationDate,
    this.employeeAddress,
    this.officeAddress = 'Manjeera Trinity Corporate, ARV Work Space, 613, JNTU Rd, Kukatpally Housing Board Colony, Kukatpally, Hyderabad, Telangana 500072',
    this.password,
    this.personalEmail,
    this.professionalEmail,
    this.phoneNumber,
    this.roleName,
    this.companyPk,
  });

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "firstName": firstName,
    "lastName": lastName,
    "dateOfBirth": dateOfBirth,
    "joiningDate": joiningDate,
    "terminationDate": terminationDate,
    "employeeAddress": employeeAddress,
    "officeAddress": officeAddress,
    "password": password,
    "personalEmail": personalEmail,
    "professionalEmail": professionalEmail,
    "phoneNumber": phoneNumber,
    "roleName": roleName,
    "companyPk": companyPk,
  };
} 