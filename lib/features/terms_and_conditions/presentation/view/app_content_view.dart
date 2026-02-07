import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/widgets/nuntium_app_bar.dart';

/// Used in (Terms & Conditions) View and (Privacy Policy) View 
class AppContentView extends StatelessWidget {
  final String title;
  final String content;

  const AppContentView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NuntiumAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Text(
          content,
          style: context.body1.copyWith(height: 1.6),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
