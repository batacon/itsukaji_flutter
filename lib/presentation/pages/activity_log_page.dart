import 'package:flutter/material.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('家事記録'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('家事記録'),
      ),
    );
  }
}
