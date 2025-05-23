import 'package:epub_reader_flutter_demo_task/views/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class BottomView extends GetView<HomeController> {
  const BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _progressWidget().paddingLeft(50),
          Row(
            children: [
              Obx(
                () => controller.totalPageIndex.value != 0
                    ? _buildPageIndexWidget()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${controller.currentPageIndex}',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
                        ),
                      ),
              ),
              12.width,
              Obx(() => _buildFontSizeWidget()),
            ],
          ),
        ],
      ).paddingBottom(8),
    );
  }

  Widget _progressWidget() {
    return Transform.scale(
      scale: 0.9,
      child: Transform.translate(
          offset: Offset(-30, -20),
          child: Obx(
            () => Stack(alignment: Alignment.center, children: [
              Transform.scale(
                scale: 1.9,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                ),
              ),
              Transform.scale(
                scale: 1.35,
                child: CircularProgressIndicator(
                  value: controller.progress.value,
                  strokeWidth: 7,
                  backgroundColor: Colors.white,
                ),
              ),
              Text(
                '${(((controller.progress.value * 100) * 10).truncateToDouble() / 10).toString()}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ]),
          )),
    );
  }

  Widget _buildFontSizeWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.white,
          ),
          onPressed: controller.decreaseFontSize,
        ),
        Text(
          '${controller.fontSize.value.toInt()}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: controller.increaseFontSize,
        ),
      ],
    );
  }

  Widget _buildPageIndexWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${controller.currentPageIndex}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            '/${controller.totalPageIndex}',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
