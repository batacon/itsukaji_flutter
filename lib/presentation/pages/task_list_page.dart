import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card.dart';
import 'package:itsukaji_flutter/presentation/pages/create_task_page.dart';
import 'package:itsukaji_flutter/presentation/pages/settings_page.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _tasksRepository = TasksRepository();
  String _searchWord = '';
  final _searchWordController = TextEditingController();
  final _searchWordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('itsukaji'),
        centerTitle: true,
        elevation: 0,
        // TODO: ハンバーガーメニュー
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: _buildCreateTaskButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, bottom: 52, left: 16),
      child: FutureBuilder(
        future: MembersRepository().getCurrentMember(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final currentMember = snapshot.data as Member;
            return StreamBuilder<List<Task>>(
              stream: _tasksRepository.getTasks(currentMember),
              builder: (context, AsyncSnapshot<List<Task>> taskListSnapshot) {
                if (taskListSnapshot.hasData && taskListSnapshot.data!.isNotEmpty) {
                  return _buildTaskList(taskListSnapshot.data!);
                } else {
                  return const Center(child: Text('家事を作ろう'));
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTaskList(List<Task> taskList) {
    final filteredTaskList =
        _searchWord.isEmpty ? taskList : taskList.where((task) => task.name.contains(_searchWord)).toList();
    final sortedTaskList = _sortTasksByDaysUntilNext(filteredTaskList);
    return ListView(
      shrinkWrap: true,
      children: [
        _buildSearchField(),
        const SizedBox(height: 20),
        ..._buildCardList(sortedTaskList),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchWordController,
      focusNode: _searchWordFocusNode,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 60),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        suffix: IconButton(
          onPressed: () {
            setState(() {
              _searchWord = '';
              _searchWordController.clear();
              _searchWordFocusNode.unfocus();
            });
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      onChanged: (value) => setState(() => _searchWord = value),
    );
  }

  List<Widget> _buildCardList(List<Task> taskList) {
    return taskList.map((task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: TaskCard(task: task),
      );
    }).toList();
  }

  List<Task> _sortTasksByDaysUntilNext(List<Task> taskList) {
    taskList.sort((taskA, taskB) => taskA.daysUntilNext().compareTo(taskB.daysUntilNext()));
    return taskList;
  }

  FloatingActionButton _buildCreateTaskButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const CreateTaskPage();
        }));
      },
      tooltip: 'Create New Task',
      child: const Icon(Icons.add),
    );
  }
}
