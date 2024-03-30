// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class NotificationModel {
  String notificationId;
  String notificationContent;
  String notificationType;
  String notificationRelatedId;
  String notificationAuth;
  String notificationDate;
  List<String> notificationReceiver;
  NotificationModel({
    required this.notificationId,
    required this.notificationContent,
    required this.notificationType,
    required this.notificationRelatedId,
    required this.notificationAuth,
    required this.notificationDate,
    required this.notificationReceiver,
  });

  NotificationModel copyWith({
    String? notificationId,
    String? notificationContent,
    String? notificationType,
    String? notificationRelatedId,
    String? notificationAuth,
    String? notificationDate,
    List<String>? notificationReceiver,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      notificationContent: notificationContent ?? this.notificationContent,
      notificationType: notificationType ?? this.notificationType,
      notificationRelatedId:
          notificationRelatedId ?? this.notificationRelatedId,
      notificationAuth: notificationAuth ?? this.notificationAuth,
      notificationDate: notificationDate ?? this.notificationDate,
      notificationReceiver: notificationReceiver ?? this.notificationReceiver,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'notificationContent': notificationContent,
      'notificationType': notificationType,
      'notificationRelatedId': notificationRelatedId,
      'notificationAuth': notificationAuth,
      'notificationDate': notificationDate,
      'notificationReceiver': notificationReceiver,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] as String,
      notificationContent: map['notificationContent'] as String,
      notificationType: map['notificationType'] as String,
      notificationRelatedId: map['notificationRelatedId'] as String,
      notificationAuth: map['notificationAuth'] as String,
      notificationDate: map['notificationDate'] as String,
      notificationReceiver: List<String>.from(
        (map['notificationReceiver'] as List<dynamic>?)
                ?.map((notification) => notification as String)
                .toList() ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(notificationId: $notificationId, notificationContent: $notificationContent, notificationType: $notificationType, notificationRelatedId: $notificationRelatedId, notificationAuth: $notificationAuth, notificationDate: $notificationDate, notificationReceiver: $notificationReceiver)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.notificationId == notificationId &&
        other.notificationContent == notificationContent &&
        other.notificationType == notificationType &&
        other.notificationRelatedId == notificationRelatedId &&
        other.notificationAuth == notificationAuth &&
        other.notificationDate == notificationDate &&
        listEquals(other.notificationReceiver, notificationReceiver);
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
        notificationContent.hashCode ^
        notificationType.hashCode ^
        notificationRelatedId.hashCode ^
        notificationAuth.hashCode ^
        notificationDate.hashCode ^
        notificationReceiver.hashCode;
  }
}
