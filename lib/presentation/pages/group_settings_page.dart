import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GroupSettingsPage extends StatelessWidget {
  const GroupSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: GroupsRepository().getCurrentGroup(),
        builder: (context, AsyncSnapshot<Group> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final group = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text('招待を受けた人が下記のQRコードを'),
                  const Text('スキャンするとグループに参加できます。'),
                  const SizedBox(height: 32),
                  QrImage(
                    data: group.invitationCode,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('更新する'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
