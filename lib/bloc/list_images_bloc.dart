import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagesPath {
  // final BehaviorSubject<List<String>> _subject =
  //     BehaviorSubject<List<String>>();
  List<String> prefList = <String>[];

  addImagePath(String imagePath) async {
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();
    prefList.add(imagePath);
    sharedLocal.setStringList('ListImagePath', prefList);
  }

  dispose() async {
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();
    sharedLocal.clear();
  }

  // void drainStream() {
  //   _subject.close();
  // }

  // @mustCallSuper
  // void dispose() async {
  //   await _subject.drain();
  //   _subject.close();
  // }

  // BehaviorSubject<ArtikelResponse> get subject => _subject;
}

final imagePathBloc = ImagesPath();

// class ImagePath {
//   ImagePath(this.imagePath);
//   String imagePath;
// }
