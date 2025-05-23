import 'package:epub_reader_flutter_demo_task/views/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteFloatingButton extends GetView<HomeController> {
  final VoidCallback onTap;
  const NoteFloatingButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.selectedTextCfi.value.isNotEmpty
          ? FloatingActionButton(
              onPressed: onTap,
              backgroundColor: Color(controller.currentTheme.value.bgColor),
              foregroundColor: Color(controller.currentTheme.value.fgColor),
              child: Icon(
                Icons.add_rounded,
              ),
            )
          : Container(),
    );
  }
}
