// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MemberModel {
  String memberId;
  MemberModel({
    required this.memberId,
  });

  MemberModel copyWith({
    String? memberId,
  }) {
    return MemberModel(
      memberId: memberId ?? this.memberId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'memberId': memberId,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      memberId: map['memberId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MemberModel(memberId: $memberId)';

  @override
  bool operator ==(covariant MemberModel other) {
    if (identical(this, other)) return true;

    return other.memberId == memberId;
  }

  @override
  int get hashCode => memberId.hashCode;
}
