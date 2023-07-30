import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/presentation/providers/current_group_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeInvitationPage extends ConsumerWidget {
  const QRCodeInvitationPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final currentGroup = ref.watch(currentGroupProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('招待コード'),
        centerTitle: true,
      ),
      body: currentGroup == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text('招待を受けた人が下記のQRコードを'),
                  const Text('スキャンするとグループに参加できます。'),
                  const SizedBox(height: 32),
                  QrImageView(
                    data: currentGroup.invitationCode,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 32),
                  _buildRegenerateInvitationCodeButton(context, ref),
                ],
              ),
            ),
    );
  }

  Widget _buildRegenerateInvitationCodeButton(final BuildContext context, final WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.refresh),
      onPressed: () {
        ref.watch(currentGroupProvider.notifier).regenerateInvitationCode();
        showSnackBarWithText(context, '招待コードを更新しました。');
      },
      label: const Text('更新する'),
    );
  }
}
