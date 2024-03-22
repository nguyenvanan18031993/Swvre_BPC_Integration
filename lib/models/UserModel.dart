class UserModel {
  UserModel(
      this.first_name,
      this.last_name,
      this.balance,
      this.plan,
      this.profile_status,
      this.language,
      this.wallet_size,
      this.phone_number,
      this.remittance_opt_in);

  final String first_name;
  final String last_name;
  final double balance;
  final String plan;
  final String profile_status;
  final String language;
  final String wallet_size;
  final String phone_number;
  final String remittance_opt_in;

  static UserModel fromJson(Map<String, Object?> json) {
    return UserModel(
      json['first_name']! as String,
      json['last_name']! as String,
      json['balance']! as double,
      json['plan']! as String,
      json['profile_status']! as String,
      json['language']! as String,
      json['wallet_size']! as String,
      json['phone_number']! as String,
      json['remittance_opt_in']! as String,
    );
  }
}
