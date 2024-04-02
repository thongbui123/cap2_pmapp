// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String userId;
  String userFirstName;
  String userLastName;
  String userEmail;
  String userRole;
  String profileImage;
  String userPhone;
  String dt;
  UserModel({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userRole,
    required this.profileImage,
    required this.userPhone,
    required this.dt,
  });

  UserModel copyWith({
    String? userId,
    String? userFirstName,
    String? userLastName,
    String? userEmail,
    String? userRole,
    String? profileImage,
    String? userPhone,
    String? dt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userFirstName: userFirstName ?? this.userFirstName,
      userLastName: userLastName ?? this.userLastName,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
      profileImage: profileImage ?? this.profileImage,
      userPhone: userPhone ?? this.userPhone,
      dt: dt ?? this.dt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userEmail': userEmail,
      'userRole': userRole,
      'profileImage': profileImage,
      'userPhone': userPhone,
      'dt': dt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      userFirstName: map['userFirstName'] as String,
      userLastName: map['userLastName'] as String,
      userEmail: map['userEmail'] as String,
      userRole: map['userRole'] as String,
      profileImage: map['profileImage'] as String,
      userPhone: map['userPhone'] as String,
      dt: map['dt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, userFirstName: $userFirstName, userLastName: $userLastName, userEmail: $userEmail, userRole: $userRole, profileImage: $profileImage, userPhone: $userPhone, dt: $dt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userFirstName == userFirstName &&
        other.userLastName == userLastName &&
        other.userEmail == userEmail &&
        other.userRole == userRole &&
        other.profileImage == profileImage &&
        other.userPhone == userPhone &&
        other.dt == dt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userFirstName.hashCode ^
        userLastName.hashCode ^
        userEmail.hashCode ^
        userRole.hashCode ^
        profileImage.hashCode ^
        userPhone.hashCode ^
        dt.hashCode;
  }
}
