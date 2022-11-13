import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itsukaji_flutter/common/date_format.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskEditForm extends StatefulWidget {
  const TaskEditForm({required this.task, Key? key}) : super(key: key);

  final Task task;

  @override
  State<TaskEditForm> createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  final _tasksRepository = TasksRepository();
  final _formKey = GlobalKey<FormState>();
  final _taskNameFormFieldKey = GlobalKey<FormFieldState<String>>();
  final _intervalDaysFormFieldKey = GlobalKey<FormFieldState<int>>();
  late String _taskName;
  late int _intervalDays;
  late DateTime _lastDoneDate;

  @override
  void initState() {
    super.initState();
    _taskName = widget.task.name;
    _intervalDays = widget.task.intervalDays;
    _lastDoneDate = widget.task.lastDoneDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRemoveButton(context),
                _buildSubmitButton(context),
              ],
            ),
            TextFormField(
              key: _taskNameFormFieldKey,
              initialValue: _taskName,
              decoration: const InputDecoration(
                hintText: '新しいタスク名を入力（20文字まで）',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim() == '') {
                  return 'タスク名を入力してください';
                }
                if (value.length > 20) {
                  return 'タスク名は20文字以内で入力してください';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  _taskName = value;
                });
              },
            ),
            SizedBox(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('間隔(1~999日)', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          key: _intervalDaysFormFieldKey,
                          initialValue: _intervalDays.toString(),
                          decoration: const InputDecoration(
                            hintText: '1~999',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '間隔を入力してください';
                            }
                            if (int.tryParse(value) == null) {
                              return '数字を入力してください';
                            }
                            if (int.parse(value) < 1 || int.parse(value) > 999) {
                              return '1~999の間で入力してください';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            _intervalDays = int.parse(value);
                          },
                        ),
                      ),
                      const Text('日ごと', style: TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('前回やった日', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      _buildLastDoneDate(),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _buildDatePicker(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 80.0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text('難易度', style: TextStyle(fontSize: 16)),
            //       Row(
            //         children: const [
            //           Icon(Icons.star, color: Color(0xFFFFC400)),
            //           Icon(Icons.star, color: Color(0xFFFFC400)),
            //           Icon(Icons.star, color: Color(0xFFFFC400)),
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Text _buildLastDoneDate() {
    return Text(dateFormatJpString(_lastDoneDate));
  }

  Future<dynamic> _buildDatePicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _lastDoneDate,
              maximumDate: DateTime.now(),
              onDateTimeChanged: (value) {
                setState(() {
                  _lastDoneDate = value;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemoveButton(final BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.grey, size: 32),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              // TODO: ダイアログのデザインを整える
              return AlertDialog(
                title: const Text('本当に消しますか？'),
                content: Text('削除すると取り消しできません。$_taskNameを本当に消しますか？'),
                actions: [
                  ElevatedButton(
                    child: const Text('やめとく'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('本当に消す'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _tasksRepository.removeTask(widget.task.id).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 1500),
                            content: Text('$_taskNameを削除中...'),
                          ),
                        );
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            });
      },
    );
  }

  Widget _buildSubmitButton(final BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.blue, size: 32),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Text('保存中...'),
            ),
          );
          final task = Task(
            id: widget.task.id,
            name: _taskName,
            intervalDays: _intervalDays,
            lastDoneDate: _lastDoneDate,
            createdAt: DateTime.now(),
          );
          _tasksRepository.updateTask(task).then((value) {
            Navigator.of(context).pop();
          });
        }
      },
    );
  }
}
