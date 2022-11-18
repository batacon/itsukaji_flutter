import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _groupsRepository = GroupsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _groupsRepository.getCurrentGroup(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final group = snapshot.data as Group;
              return Column(
                children: [
                  Text('招待コード: ${group.invitationCode}'),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
