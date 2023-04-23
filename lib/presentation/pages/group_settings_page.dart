import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/presentation/components/member_list_section.dart';
import 'package:itsukaji_flutter/presentation/pages/qr_code_invitation_page.dart';
import 'package:itsukaji_flutter/presentation/providers/current_group_provider.dart';

class GroupSettingsPage extends ConsumerWidget {
  const GroupSettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final currentGroup = ref.watch(currentGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
        centerTitle: true,
      ),
      body: currentGroup == null
          ? const Center(child: CircularProgressIndicator())
          : _buildGroupSettingsSection(context, ref, currentGroup),
    );
  }

  Widget _buildGroupSettingsSection(final BuildContext context, final WidgetRef ref, final Group currentGroup) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          MemberListSection(currentGroup),
          const SizedBox(height: 40),
          _buildInvitationButton(context, ref, currentGroup),
        ],
      ),
    );
  }

  Widget _buildInvitationButton(final BuildContext context, final WidgetRef ref, final Group currentGroup) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const QRCodeInvitationPage();
          }));
        },
        child: const Text('メンバーを招待する', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
