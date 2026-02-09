// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScaffoldWithHeader extends StatelessWidget {
  const ScaffoldWithHeader({
    super.key,
    required this.header,
    required this.body,
    this.padding,
    this.scrollable = true,

    // required this.title,
    // required this.subTitle,
  });

  final Widget body;
  final Widget header;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  // final String title;
  // final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
          child: scrollable
              ? SingleChildScrollView(child: Column(children: [header, body]))
              : Column(children: [header, body]),
        ),
      ),
    );
  }
}
