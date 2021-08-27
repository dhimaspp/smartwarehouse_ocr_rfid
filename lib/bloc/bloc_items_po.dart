import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/items_model.dart';

class GetItemsPO {
  final PoRepository _diginfoRepository = PoRepository();
  final BehaviorSubject<ItemsPOModel> _subject =
      BehaviorSubject<ItemsPOModel>();

  getItemsPOList(String noPO) async {
    ItemsPOModel response = await _diginfoRepository.getPOItems(noPO);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.close();
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<ItemsPOModel> get subject => _subject;
}

final getPOItems = GetItemsPO();
