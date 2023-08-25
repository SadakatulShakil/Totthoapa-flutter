class User {
  final String status;
  final String token;
  final dynamic user_id;
  final String user_name;
  final String user_image;
  final String full_name;
  final String first_time_logged;


  User(this.status, this.token, this.user_id, this.user_name, this.user_image, this.full_name, this.first_time_logged);

  User.name(this.status, this.token, this.user_id, this.user_name,
      this.user_image, this.full_name, this.first_time_logged);
}
