import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:rxdart/rxdart.dart';

class GetPOLoadMoreBloc {
  final PoRepository _poRepository = PoRepository();
  final BehaviorSubject<POList> _subject = BehaviorSubject<POList>();

  getallPOrx(String loadmore) async {
    print('getallPO');
    POList response = await _poRepository.getPOLoadMore(loadmore.trim());
    _subject.sink.add(response);
    _result = _subject;
  }

  dispose() async {
    _subject.close();
  }

  BehaviorSubject<POList> get subject => _subject;
  Stream<POList>? _result;
  Stream<POList>? get result => _result;
}

final getPOLoadmoreBloc = GetPOLoadMoreBloc();
