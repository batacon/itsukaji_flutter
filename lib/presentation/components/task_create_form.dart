import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/common/date_format.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({super.key});

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

// TODO: createとeditでフォームを使い回す。viewmodelを用意し、riverpodを利用してformの状態を管理する。
class _TaskCreateFormState extends State<TaskCreateForm> {
  final _tasksRepository = TasksRepository();
  final _formKey = GlobalKey<FormState>();
  final _taskNameFormFieldKey = GlobalKey<FormFieldState<String>>();
  final _intervalDaysFormFieldKey = GlobalKey<FormFieldState<int>>();
  String _taskName = '';
  int _intervalDays = 0;
  DateTime _lastDoneDate = DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSubmitButton(context),
              ],
            ),
            TextFormField(
              key: _taskNameFormFieldKey,
              decoration: const InputDecoration(
                hintText: '新しいタスク名を入力（30文字まで）',
              ),
              validator: (final value) {
                if (value == null || value.isEmpty || value.trim() == '') {
                  return 'タスク名を入力してください';
                }
                if (value.length > 30) {
                  return 'タスク名は30文字以内で入力してください';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (final value) {
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
                  Text('間隔(1~999日)', style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          key: _intervalDaysFormFieldKey,
                          decoration: const InputDecoration(
                            hintText: '1~999',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (final value) {
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
                          onChanged: (final value) {
                            _intervalDays = int.parse(value);
                          },
                        ),
                      ),
                      Text('日ごと', style: Theme.of(context).textTheme.bodyMedium),
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
                  Text('前回やった日', style: Theme.of(context).textTheme.bodyMedium),
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

  Future<dynamic> _buildDatePicker(final BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (final context) {
        return SafeArea(
          child: SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (final value) {
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

  Widget _buildSubmitButton(final BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check, color: CustomColor.primary, size: 32),
      onPressed: () {
        if (!_formKey.currentState!.validate()) return;

        try {
          showSnackBarWithText(context, '保存中...');
          final form = {
            'name': _taskName,
            'intervalDays': _intervalDays,
            'lastDoneDate': _lastDoneDate,
            'createdAt': DateTime.now(),
          };
          _tasksRepository.addTask(form).then((final value) {
            Navigator.of(context).pop();
          });
        } catch (e) {
          print(e.toString());
          showSnackBarWithText(context, e.toString());
          // showSnackBarWithText(context, '保存に失敗しました');
        }
      },
    );
  }
}
