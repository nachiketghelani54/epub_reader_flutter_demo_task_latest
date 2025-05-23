import 'package:epub_reader_flutter_demo_task/model/note_model.dart';
import 'package:epub_reader_flutter_demo_task/utils/app_strings.dart';
import 'package:epub_reader_flutter_demo_task/utils/assets.dart';
import 'package:epub_reader_flutter_demo_task/views/components/note_floating_button.dart';
import 'package:epub_reader_flutter_demo_task/views/controller/home_controller.dart';
import 'package:epub_reader_flutter_demo_task/views/screen/bottom_view.dart';
import 'package:epub_reader_flutter_demo_task/views/screen/epub_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(controller.currentTheme.value.bgColor),
          surfaceTintColor: Color(controller.currentTheme.value.bgColor),
          elevation: 3,
          title: Text(
            AppStrings.appTitle,
            style: TextStyle(
              color: Color(controller.currentTheme.value.fgColor),
            ),
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: controller.isCurrentPageBookmarked.value
                    ? Icon(Icons.bookmark_add)
                    : Icon(Icons.bookmark_add_outlined),
                color: Color(controller.currentTheme.value.fgColor),
                onPressed: controller.addBookmark,
              ),
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.light_mode,
                color: Color(controller.currentTheme.value.fgColor),
              ),
              itemBuilder: (context) {
                return controller.readerThemes.map(
                  (e) {
                    return PopupMenuItem(
                      value: e,
                      onTap: () {
                        controller.setEpubTheme(e);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(e.bgColor),
                          ),
                          10.width,
                          Text(e.name.validate()),
                        ],
                      ),
                    );
                  },
                ).toList();
              },
            ),
          ],
        ),
        drawer: EPubDrawer(),
        bottomNavigationBar: BottomView(),
        floatingActionButton: NoteFloatingButton(
          onTap: () {
            _showCommentDialog(
                context, controller.selectedText.value, controller.selectedTextCfi.value, '');
          },
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            EpubViewer(
              epubSource: EpubSource.fromAsset(EPUBAssets.accessibleEpub3),
              epubController: controller.epubController,
              displaySettings: EpubDisplaySettings(
                flow: EpubFlow.paginated,
                defaultDirection: EpubDefaultDirection.ltr,
                snap: true,
                spread: EpubSpread.always,
                useSnapAnimationAndroid: true,
                allowScriptedContent: true,
              ),
              onChaptersLoaded: (List<EpubChapter> chapters) {
                controller.fetchChapters(chapters);
                controller.checkForPageBookmark();
              },
              onEpubLoaded: () async {
                await controller.epubController.parseChapters();
                controller.checkForPageBookmark();
                controller.isLoading.value = false;
              },
              onRelocated: (value) {
                controller.updateProgress(value.progress);
                controller.checkForPageBookmark();
                controller.checkForProgress();
              },
              onAnnotationClicked: (value) {
                var note = controller.noteList
                    .where(
                      (note) => note.cfi == value,
                    )
                    .first;
                if (controller.isNoteDialogueOpen.value) {
                  return;
                }
                _showCommentDialog(context, note.text, note.cfi ?? '', note.note);
              },
              onTextSelected: (EpubTextSelection epubTextSelection) {
                controller.selectedTextCfi.value = epubTextSelection.selectionCfi;
                controller.selectedText.value = epubTextSelection.selectedText;
              },
            ),
            controller.isLoading.value
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> _showCommentDialog(
      BuildContext context, String? selectedText, String selectedTextCfi, String? addedNote) async {
    controller.isNoteDialogueOpen.value = true;
    controller.selectedText.value = '';
    controller.selectedTextCfi.value = '';
    if (addedNote?.isNotEmpty ?? false) {
      controller.commentEditingController.text = addedNote ?? '';
    } else {
      controller.commentEditingController.clear();
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF202020),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (addedNote?.isNotEmpty ?? false) ? 'Note' : 'Add a Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border(
                        left: BorderSide(width: 3, color: Colors.white),
                        top: BorderSide(width: .5, color: Colors.white),
                        right: BorderSide(width: .5, color: Colors.white),
                        bottom: BorderSide(width: .5, color: Colors.white))),
                height: 30,
                padding: EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedText ?? "",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.commentEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write a Note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: (addedNote?.isEmpty ?? false)
                      ? GestureDetector(
                          onTap: () {
                            controller.addNote(Note(
                                text: selectedText,
                                cfi: selectedTextCfi,
                                note: controller.commentEditingController.text));
                            controller.epubController
                                .addHighlight(cfi: selectedTextCfi, color: Colors.green);
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Divider(height: 1, color: Colors.grey),
            ],
          ),
        ),
      ),
    ).then(
      (value) {
        controller.isNoteDialogueOpen.value = false;
      },
    );
  }
}
