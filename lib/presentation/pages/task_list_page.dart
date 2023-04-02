import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card.dart';
import 'package:itsukaji_flutter/presentation/pages/create_task_page.dart';
import 'package:itsukaji_flutter/presentation/pages/settings_page.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _tasksRepository = TasksRepository();
  String _searchWord = '';
  final _searchWordController = TextEditingController();
  final _searchWordFocusNode = FocusNode();

  @override
  Widget build(final BuildContext context) {
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

  Widget _buildBody(final BuildContext context) {
    return FutureBuilder(
      future: MembersRepository().getCurrentMember(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentMember = snapshot.data as Member;
          return StreamBuilder<List<Task>>(
            stream: _tasksRepository.getTasks(currentMember),
            builder: (final context, final AsyncSnapshot<List<Task>> taskListSnapshot) {
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
    );
  }

  Widget _buildTaskList(final List<Task> taskList) {
    final filteredTaskList =
        _searchWord.isEmpty ? taskList : taskList.where((task) => task.name.contains(_searchWord)).toList();
    final sortedTaskList = _sortTasksByDaysUntilNext(filteredTaskList);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 52),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 20),
            ..._buildCardList(sortedTaskList),
          ],
        ),
      ),
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

  List<Widget> _buildCardList(final List<Task> taskList) {
    return taskList.map((task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TaskCard(task),
      );
    }).toList();
  }

  List<Task> _sortTasksByDaysUntilNext(final List<Task> taskList) {
    taskList.sort((taskA, taskB) => taskA.daysUntilNext.compareTo(taskB.daysUntilNext));
    return taskList;
  }

  FloatingActionButton _buildCreateTaskButton(final BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const CreateTaskPage();
        }));
      },
      tooltip: 'Create New Task',
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
