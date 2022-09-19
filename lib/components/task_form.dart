import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameFormFieldKey = GlobalKey<FormFieldState<String>>();
  final _intervalDaysFormFieldKey = GlobalKey<FormFieldState<int>>();
  String _taskName = '';
  int _intervalDays = 0;
  DateTime _lastDoneDate = DateTime.now();

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TODO: 編集時の削除ボタンを作成
                _buildSubmitButton(context),
              ],
            ),
            TextFormField(
              key: _taskNameFormFieldKey,
              decoration: const InputDecoration(
                hintText: '新しいタスク名を入力（必須/20文字まで）',
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
                  const Text('間隔(必須/1~999日)', style: TextStyle(fontSize: 16)),
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
                  const Text('前回やった日(任意)', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text('${_lastDoneDate.year}年${_lastDoneDate.month}月${_lastDoneDate.day}日'),
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

  Widget _buildSubmitButton(final BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.blue, size: 32),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存します')),
          );
          Navigator.pop(context);
        }
      },
    );
  }
}
