import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

class MemberListSection extends ConsumerStatefulWidget {
  final Group _currentGroup;

  const MemberListSection(this._currentGroup, {super.key});

  @override
  ConsumerState<MemberListSection> createState() => _MemberListSectionState();
}

class _MemberListSectionState extends ConsumerState<MemberListSection> {
  bool isAccordionExpanded = false;

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
      future: ref.watch(membersRepositoryProvider).getMembersOf(widget._currentGroup.id),
      builder: (context, AsyncSnapshot<List<Member>> snapshot) {
        if (snapshot.hasData) {
          final members = snapshot.data!;
          return _buildMemberListAccordion(members);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMemberListAccordion(final List<Member> members) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isAccordionExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              leading: Icon(Icons.groups, color: CustomColor.text),
              title: Text('グループのメンバーを見る'),
            );
          },
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members.elementAt(index);
              return ListTile(
                title: Text(member.name),
                shape: const Border(bottom: BorderSide(color: CustomColor.text)),
              );
            },
          ),
          isExpanded: isAccordionExpanded,
        ),
      ],
    );
  }
}
