import 'package:flutter/material.dart';

class QuyCheHoatDongPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quy chế hoạt động'),
      ),
      body: Center(
        child: Text(
          'Đây là trang Quy chế hoạt động.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}