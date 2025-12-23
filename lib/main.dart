import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nuntium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(appBar: AppBar(title: Text('Nuntium'))),
    );
  }
}
