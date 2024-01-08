// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ManagerModel {
  String managerId;
  String managerName;
  String managerEmail;
  String role;
  ManagerModel({
    required this.managerId,
    required this.managerName,
    required this.managerEmail,
    required this.role,
  });

  ManagerModel copyWith({
    String? managerId,
    String? managerName,
    String? managerEmail,
    String? role,
  }) {
    return ManagerModel(
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      managerEmail: managerEmail ?? this.managerEmail,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'managerId': managerId,
      'managerName': managerName,
      'managerEmail': managerEmail,
      'role': role,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      managerId: map['managerId'] as String,
      managerName: map['managerName'] as String,
      managerEmail: map['managerEmail'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) =>
      ManagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Manager(managerId: $managerId, managerName: $managerName, managerEmail: $managerEmail, role: $role)';
  }

  @override
  bool operator ==(covariant ManagerModel other) {
    if (identical(this, other)) return true;

    return other.managerId == managerId &&
        other.managerName == managerName &&
        other.managerEmail == managerEmail &&
        other.role == role;
  }

  @override
  int get hashCode {
    return managerId.hashCode ^
        managerName.hashCode ^
        managerEmail.hashCode ^
        role.hashCode;
  }
}
