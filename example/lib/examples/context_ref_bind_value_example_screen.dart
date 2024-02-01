import 'package:flutter/material.dart';

import '../example.dart';
import 'context_ref_bind_value_example.dart';

class BindValueExampleScreen extends StatelessWidget {
  const BindValueExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ref.bindValue() example'),
      ),
      body: const Example(
        title: 'Ref.bindValue()',
        fileName: 'context_ref_bind_value_example.dart',
        child: BindValueExample(),
      ),
    );
  }
}