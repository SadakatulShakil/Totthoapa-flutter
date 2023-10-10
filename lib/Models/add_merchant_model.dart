class merchantDataModel {
  String first_name;
  String phone_no;
  String phone_one;
  String nid;
  String email;
  String password;
  String shop_name;
  String user_address;
  String profile_image;
  String latitude;
  String longitude;
  String district;
  String upazila;
  String payment_method;
  String account_name;
  String bank_name;
  String account_number;
  String memberofjoita;
  String istraineeofms;
  String trainingofms;

  merchantDataModel({
    required this.first_name,
    required this.phone_no,
    required this.phone_one,
    required this.nid,
    required this.email,
    required this.password,
    required this.shop_name,
    required this.user_address,
    required this.profile_image,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.upazila,
    required this.payment_method,
    required this.account_name,
    required this.bank_name,
    required this.account_number,
    required this.memberofjoita,
    required this.istraineeofms,
    required this.trainingofms,
  });

  // Named constructor for null initialization
  merchantDataModel.nullConstructor()
      :first_name = '',
        phone_no = '',
        phone_one = '',
        nid = '',
        email = '',
        password = '',
        shop_name = '',
        user_address = '',
        profile_image = '',
        latitude = '',
        longitude = '',
        district = '',
        upazila = '',
        payment_method = '',
        account_name = '',
        bank_name = '',
        account_number = '',
        memberofjoita = '',
        istraineeofms = '',
        trainingofms = '';

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'first_name': first_name,
      'phone_no': phone_no,
      'phone_one': phone_one,
      'nid': nid,
      'email': email,
      'password': password,
      'shop_name': shop_name,
      'user_address': user_address,
      'profile_image': profile_image,
      'latitude': latitude,
      'longitude': longitude,
      'district': district,
      'upazila': upazila,
      'payment_method': payment_method,
      'account_name': account_name,
      'bank_name': bank_name,
      'account_number': account_number,
      'memberofjoita': memberofjoita,
      'istraineeofms': istraineeofms,
      'trainingofms': trainingofms,
    };
  }

  // Create a User Data Model from a Map
  factory merchantDataModel.fromMap(Map<String, dynamic> map) {
    return merchantDataModel(
      first_name: map['first_name'],
      phone_no: map['phone_no'],
      phone_one: map['phone_one'],
      nid: map['nid'],
      email: map['email'],
      password: map['password'],
      shop_name: map['shop_name'],
      user_address: map['user_address'],
      profile_image: map['profile_image'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      district: map['district'],
      upazila: map['upazila'],
      payment_method: map['payment_method'],
      account_name: map['account_name'],
      bank_name: map['bank_name'],
      account_number: map['account_number'],
      memberofjoita: map['memberofjoita'],
      istraineeofms: map['istraineeofms'],
      trainingofms: map['trainingofms'],
    );
  }

}
