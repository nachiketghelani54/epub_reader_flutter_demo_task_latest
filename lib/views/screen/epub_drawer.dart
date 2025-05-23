import 'package:epub_reader_flutter_demo_task/utils/app_strings.dart';
import 'package:epub_reader_flutter_demo_task/views/components/drawer_tab.dart';
import 'package:epub_reader_flutter_demo_task/views/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class EPubDrawer extends GetView<HomeController> {
  const EPubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width - 30,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            10.height,
            _tabs(),
            Obx(
              () => Expanded(
                child: controller.isTableOfContentVisible.value == 1
                    ? _viewTableOfContents()
                    : controller.isTableOfContentVisible.value == 2
                        ? _viewBookmarks()
                        : _viewNotes(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: DrawerTab(
                onTap: () {
                  controller.isTableOfContentVisible.value = 1;
                },
                text: AppStrings.tableOfContents,
                isSelected: controller.isTableOfContentVisible.value == 1,
              ),
            ),
            Expanded(
              flex: 4,
              child: DrawerTab(
                onTap: () {
                  controller.isTableOfContentVisible.value = 2;
                },
                text: AppStrings.bookmarks,
                isSelected: controller.isTableOfContentVisible.value == 2,
              ),
            ),
            Expanded(
              flex: 4,
              child: DrawerTab(
                onTap: () {
                  controller.isTableOfContentVisible.value = 3;
                },
                text: AppStrings.notes,
                isSelected: controller.isTableOfContentVisible.value == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewTableOfContents() {
    return ListView.builder(
      itemCount: controller.contents.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.epubController.display(cfi: controller.contents[index].href);
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                controller.contents[index].title,
                style: TextStyle(color: Colors.blue),
              )),
        );
      },
    );
  }

  Widget _viewBookmarks() {
    return ListView.builder(
      itemCount: controller.bookMarkList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.epubController.display(cfi: controller.bookMarkList[index].cfiRange ?? '');
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                controller.bookMarkList[index].text ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue),
              )),
        );
      },
    );
  }

  Widget _viewNotes() {
    return ListView.builder(
      itemCount: controller.noteList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.epubController.display(cfi: controller.noteList[index].cfi ?? '');
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                controller.noteList[index].text ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blue),
              )),
        );
      },
    );
  }
}
