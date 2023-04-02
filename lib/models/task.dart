import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itsukaji_flutter/common/date_format.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required String id,
    required String name,
    required int intervalDays,
    required DateTime lastDoneDate,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromFirestore(final QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
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

  int get daysUntilNext {
    final nextDate = midnight(lastDoneDate.add(Duration(days: intervalDays)));
    final now = midnight(DateTime.now());
    return nextDate.difference(now).inDays;
  }

  String get lastDoneDateFormatted => dateFormatSlashString(lastDoneDate);

  bool get isOverdue => daysUntilNext < 0;

  int get daysOverdue => -daysUntilNext;

  bool get isDueToday => daysUntilNext <= 0;

  bool get isDueTomorrow => daysUntilNext == 1;
}
