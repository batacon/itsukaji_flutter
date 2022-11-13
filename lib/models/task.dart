import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsukaji_flutter/common/date_format.dart';

class Task {
  Task({
    required this.id,
    required this.name,
    required this.intervalDays,
    required this.lastDoneDate,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int intervalDays;
  final DateTime lastDoneDate;
  final DateTime createdAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        intervalDays: json["intervalDays"],
        lastDoneDate: DateTime.parse(json["lastDoneDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  factory Task.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Task(
      id: snapshot.id,
      name: data['name'],
      intervalDays: data['intervalDays'],
      lastDoneDate: data['lastDoneDate'].toDate(),
      createdAt: data['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "intervalDays": intervalDays,
        "lastDoneDate": lastDoneDate,
        "createdAt": createdAt,
      };

  int daysUntilNext() {
    final nextDate = lastDoneDate.add(Duration(days: intervalDays));
    final now = DateTime.now();
    return nextDate.difference(now).inDays + 1;
  }

  String lastDoneDateFormatted() {
    return dateFormatSlashString(lastDoneDate);
  }

  bool isDueToday() {
    return daysUntilNext() <= 0;
  }

  bool isDueTomorrow() {
    return daysUntilNext() == 1;
  }
}
