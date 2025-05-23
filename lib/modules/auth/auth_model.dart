class UserLoginModel {
  final int id;
  final int? storeId;
  final String? storeName;
  final String nama;
  final String email;
  final int roleId;
  final String role;
  final int status;
  final int userid;
  final String token;
  final String tokenExpiredAt;

  UserLoginModel({
    required this.id,
    this.storeId,
    this.storeName,
    required this.nama,
    required this.email,
    required this.roleId,
    required this.role,
    required this.status,
    required this.userid,
    required this.token,
    required this.tokenExpiredAt,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      id: json['id'],
      storeId: json['store_id'],
      storeName: json['store_name'] == "null" ? null : json['store_name'],
      nama: json['nama'],
      email: json['email'],
      roleId: json['role_id'],
      role: json['role'],
      status: json['status'],
      userid: json['userid'],
      token: json['token'],
      tokenExpiredAt: json['token_expired_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'nama': nama,
      'email': email,
      'role_id': roleId,
      'role': role,
      'status': status,
      'userid': userid,
      'token': token,
      'token_expired_at': tokenExpiredAt,
    };
  }
}
