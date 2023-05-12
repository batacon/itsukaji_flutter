import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

class NicknameFormField extends ConsumerStatefulWidget {
  const NicknameFormField({Key? key}) : super(key: key);

  @override
  ConsumerState<NicknameFormField> createState() => _NicknameFormFieldState();
}

class _NicknameFormFieldState extends ConsumerState<NicknameFormField> {
  final TextEditingController _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ref.read(membersRepositoryProvider).getCurrentMember().then((value) {
      _nicknameController.text = value.name;
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ニックネームを変更する', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _buildNicknameFormField(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNicknameFormField() {
    return TextFormField(
      controller: _nicknameController,
      decoration: const InputDecoration(
        labelText: 'ニックネーム',
        labelStyle: TextStyle(color: CustomColor.text),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ニックネームを入力してください';
        }
        if (value.length > 20) {
          return '20文字以内で入力してください';
        }
        return null;
      },
      onFieldSubmitted: (_) => _updateNickname(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => _updateNickname(),
        child: const Text('変更する'),
      ),
    );
  }

  void _updateNickname() {
    if (_formKey.currentState!.validate()) {
      ref.read(membersRepositoryProvider).updateNickname(_nicknameController.text);
      showSnackBarWithText(context, 'ニックネームを変更しました');
      primaryFocus?.unfocus();
    }
  }
}
