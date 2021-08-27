import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/items_model.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/item_tagging.dart';

class GetSearchBloc {
  GetSearchBloc({this.apiWrapper}) {
    _result = _subject
        .debounce((_) => TimerStream(true, Duration(seconds: 1)))
        .switchMap((query) async* {
      print("Searching: $query");
      yield await apiWrapper.search(query);
    });
  }
  final PoRepository apiWrapper;
  final _subject = BehaviorSubject<String>();
  void search(String query) => _subject.add(query);

  Stream<POList> _result;
  Stream<POList> get result => _result;

  void dispose() {
    _subject.close();
  }
}

class GetSearchItemsBloc {
  GetSearchItemsBloc({this.apiWrapper}) {
    // _result = Rx.combineLatest2(_poNumber, p, (a, b) => null)
    _result = _subject
        .debounce((_) => TimerStream(true, Duration(seconds: 1)))
        .switchMap((query) async* {
      print("Searching: $query");
      yield await apiWrapper.searchItems(query);
    });
  }
  final PoRepository apiWrapper;
  final _subject = BehaviorSubject<String>();
  void searchItems(String query) => _subject.add(query);

  Stream<ItemsPOModel> _result;
  Stream<ItemsPOModel> get result => _result;

  void dispose() {
    _subject.close();
  }
}

final getSearchBloc = GetSearchBloc(apiWrapper: PoRepository());
final getSearchItemBloc = GetSearchItemsBloc(apiWrapper: PoRepository());
