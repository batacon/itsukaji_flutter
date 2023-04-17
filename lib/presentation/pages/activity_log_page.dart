import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/presentation/components/activity_logs_by_date_section.dart';
import 'package:itsukaji_flutter/presentation/providers/activity_logs_provider.dart';

class ActivityLogPage extends ConsumerWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.watch(activityLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('家事記録'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: _buildActivityLogList(ref),
        ),
      ),
    );
  }

  Widget _buildActivityLogList(final WidgetRef ref) {
    final activityLogsByDate = ref.watch(activityLogsProvider.notifier).activityLogsByDate;
    if (activityLogsByDate.isEmpty) return const Center(child: Text('家事を記録しよう'));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: activityLogsByDate.length,
      itemBuilder: (BuildContext context, int index) {
        final activityLogEntry = activityLogsByDate.entries.elementAt(index);
        return ActivityLogsByDateSection(activityLogEntry.key, activityLogEntry.value);
      },
    );
  }
}
