import 'package:flutter/material.dart';

class FanpagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fanpage Mioto'),
      ),
      body: Center(
        child: Text(
          'Đây là trang Fanpage.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
