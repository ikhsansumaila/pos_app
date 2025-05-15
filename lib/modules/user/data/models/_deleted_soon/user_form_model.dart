// class UserFormModel {
//   int cacheId;
//   String nama;
//   String email;
//   String password;
//   int roleId;
//   String roleName;
//   int storeId;
//   String storeName;
//   int status;
//   int userid;

//   UserFormModel({
//     required this.cacheId,
//     required this.nama,
//     required this.email,
//     required this.password,
//     required this.roleId,
//     required this.roleName,
//     required this.storeId,
//     this.storeName = '',
//     required this.status,
//     required this.userid,
//   });

//   factory UserFormModel.fromJson(Map<String, dynamic> json) {
//     return UserFormModel(
//       cacheId: json['cache_id'],
//       nama: json['nama'],
//       email: json['email'],
//       password: json['password'],
//       roleId: json['role_id'],
//       roleName: json['role_name'],
//       storeId: json['store_id'],
//       storeName: json['store_name'],
//       status: json['status'],
//       userid: json['userid'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'cache_id': cacheId,
//     'nama': nama,
//     'email': email,
//     'password': password,
//     'role_id': roleId,
//     'role_name': roleName,
//     'store_id': storeId,
//     'store_name': storeName,
//     'status': status,
//     'userid': userid,
//   };

//   // Map<String, dynamic> toJsonCreate() => {
//   //   'cache_id': cacheId,
//   //   'nama': nama,
//   //   'email': email,
//   //   'password': password,
//   //   'role_id': roleId,
//   //   'store_id': storeId,
//   //   'userid': userid,
//   // };
// }
