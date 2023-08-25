class Merchant {
  final int? id;
  final String? name;
  final String? username;
  final String? userAddress;
  final String? storeName;
  final int? memberOfJoita;
  final int? isTraineeOfMs;
  final int? trainingOfMs;
  final int? district;
  final String? districtName;
  final int? upazila;
  final String? upazilaName;
  final String? phone;
  final String? phone2;
  final String? profileImage;
  final String? password;
  final String? longitude;
  final String? latitude;
  final String? email;
  final String? created;
  final String? modified;
  final String? paymentMethod;
  final String? accountName;
  final String? bankName;
  final String? accountNumber;

  Merchant({
    this.id,
    this.name,
    this.username,
    this.userAddress,
    this.storeName,
    this.memberOfJoita,
    this.isTraineeOfMs,
    this.trainingOfMs,
    this.district,
    this.districtName,
    this.upazila,
    this.upazilaName,
    this.phone,
    this.phone2,
    this.profileImage,
    this.password,
    this.longitude,
    this.latitude,
    this.email,
    this.created,
    this.modified,
    this.paymentMethod,
    this.accountName,
    this.bankName,
    this.accountNumber,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      userAddress: json['user_address'],
      storeName: json['store_name'],
      memberOfJoita: json['memberofjoita'],
      isTraineeOfMs: json['istraineeofms'],
      trainingOfMs: json['trainingofms'],
      district: json['district'],
      districtName: json['district_name'],
      upazila: json['upazila'],
      upazilaName: json['upazila_name'],
      phone: json['phone'],
      phone2: json['phone2'],
      profileImage: json['profile_image'],
      password: json['password'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      email: json['email'],
      created: json['created'],
      modified: json['modified'],
      paymentMethod: json['payment_method'],
      accountName: json['account_name'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
    );
  }
}
