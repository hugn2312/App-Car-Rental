import 'package:flutter/material.dart';

class GiaiQuyetTranhChapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giải quyết tranh chấp'),
      ),
      body: Center(
        child: Text(
          'Đây là trang giải quyết tranh chấp.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}