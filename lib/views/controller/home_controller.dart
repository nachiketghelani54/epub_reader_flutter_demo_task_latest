import 'dart:convert';
import 'dart:io';

import 'package:epub_reader_flutter_demo_task/model/reder_theme.dart';
import 'package:epub_reader_flutter_demo_task/utils/prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epub_reader_flutter_demo_task/model/note_model.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  EpubController epubController = EpubController();
  TextEditingController commentEditingController = TextEditingController();

  RxString selectedText = ''.obs;
  RxString selectedTextCfi = ''.obs;

  RxDouble progress = 0.0.obs;

  // Theme, font size, and font family state
  RxBool isDarkTheme = false.obs;
  RxBool isNoteDialogueOpen = false.obs;
  RxInt isTableOfContentVisible = 1.obs;
  RxBool isCurrentPageBookmarked = false.obs;
  RxDouble fontSize = 16.0.obs;
  RxString fontFamily = 'Roboto'.obs;

  Rx<ReaderTheme> currentTheme =
      ReaderTheme(bgColor: 0xffFFFFFF, fgColor: 0xff000000, name: "Light").obs;

  final List<ReaderTheme> readerThemes = [
    ReaderTheme(bgColor: 0xffFFFFFF, fgColor: 0xff000000, name: "Light"),
    ReaderTheme(bgColor: 0xff303030, fgColor: 0xffFFFFFF, name: "Dark"),
    ReaderTheme(bgColor: 0xffcfeefa, fgColor: 0xff000000, name: "Light Blue"),
    ReaderTheme(bgColor: 0xfff5cbec, fgColor: 0xff000000, name: "Light Pink"),
    ReaderTheme(bgColor: 0xff94735d, fgColor: 0xffFFFFFF, name: "Brown"),
  ];

  RxList<EpubChapter> contents = <EpubChapter>[].obs;
  RxInt currentPageIndex = 1.obs;
  RxInt totalPageIndex = 0.obs;
  RxDouble progressDifference = 0.0.obs;

  RxList<EpubTextExtractRes> bookMarkList = <EpubTextExtractRes>[].obs;
  RxList<Note> noteList = <Note>[].obs;

  List<EpubTextExtractRes> bookMarkListFromJson(String str) =>
      List<EpubTextExtractRes>.from(json.decode(str).map((x) => EpubTextExtractRes.fromJson(x)));

  String bookMarkListToJson(List<EpubTextExtractRes> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  @override
  onInit() {
    super.onInit();
    isLoading.value = true;
    if (getStringAsync(PrefsKey.bookmarkData) != "") {
      bookMarkList = bookMarkListFromJson(getStringAsync(PrefsKey.bookmarkData)).obs;
    } else {
      bookMarkList = <EpubTextExtractRes>[].obs;
    }
    if (getStringAsync(PrefsKey.notes) != "") {
      noteList = noteFromJson(getStringAsync(PrefsKey.notes)).obs;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
          Duration(seconds: 5),
          () {
            noteList.forEach(
              (element) {
                epubController.addHighlight(cfi: element.cfi ?? "", color: Colors.green);
              },
            );
          },
        );
      });
    } else {
      noteList = <Note>[].obs;
    }
  }

  /// Function that read a progress
  updateProgress(double value) {
    progress.value = value;
  }

  /// To Update a app book theme
  setEpubTheme(ReaderTheme theme) {
    currentTheme.value = theme;
    epubController.updateTheme(
        theme: EpubTheme.custom(
            backgroundColor: Color(theme.bgColor), foregroundColor: Color(theme.fgColor)));
  }

  /// To Increase a font size
  void increaseFontSize() {
    fontSize.value += 2;
    epubController.setFontSize(fontSize: fontSize.value);
  }

  /// To Decrease a font size
  void decreaseFontSize() {
    if (fontSize.value > 10) fontSize.value -= 2;
    epubController.setFontSize(fontSize: fontSize.value);
  }

  /// Function that add a bookmark or remove if it's already bookmarked
  void addBookmark() async {
    var data = await epubController.extractCurrentPageText();
    for (int i = 0; i < bookMarkList.length; i++) {
      if (bookMarkList[i].cfiRange == data.cfiRange) {
        bookMarkList.removeAt(i);
        await setValue(PrefsKey.bookmarkData, bookMarkListToJson(bookMarkList));
        checkForPageBookmark();
        return;
      }
    }
    bookMarkList.add(data);

    await setValue(PrefsKey.bookmarkData, bookMarkListToJson(bookMarkList));
    checkForPageBookmark();
  }

  /// Function that add a note
  Future<void> addNote(Note note) async {
    noteList.add(note);
    await setValue(PrefsKey.notes, noteToJson(noteList));
  }

  /// Function that check that page is bookmarked or not
  void checkForPageBookmark() async {
    var data = await epubController.extractCurrentPageText();
    for (int i = 0; i < bookMarkList.length; i++) {
      if (bookMarkList[i].cfiRange == data.cfiRange) {
        isCurrentPageBookmarked.value = true;
        return;
      }
    }
    isCurrentPageBookmarked.value = false;
  }

  /// Function that check the reading progress
  void checkForProgress() async {
    var data = await epubController.getCurrentLocation();
    if (progressDifference.value == 0.0) {
      progressDifference.value = data.progress;
    } else {
      totalPageIndex.value = (1 / progressDifference.value).toInt();
      currentPageIndex.value = (data.progress / progressDifference.value).toInt();
    }
  }

  /// Function that fetch the all chapter available in eBook
  fetchChapters(List<EpubChapter> chapters) {
    for (var element in chapters) {
      contents.add(element);
      if (element.subitems.isNotEmpty) {
        fetchChapters(element.subitems);
      }
    }
  }

  /// Function that set font size in eBook
  void setFontFamily(String family) {
    fontFamily.value = family;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
