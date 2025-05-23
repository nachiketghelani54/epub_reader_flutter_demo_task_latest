import 'package:epub_reader_flutter_demo_task/utils/app_colors.dart';
import 'package:epub_reader_flutter_demo_task/views/controller/home_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerTab extends GetView<HomeController> {
  final VoidCallback onTap;
  final bool isSelected;
  final String text;
  const DrawerTab({super.key, required this.onTap, this.isSelected = false, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.blackColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12),
        ),
      ),
    );
  }
}
