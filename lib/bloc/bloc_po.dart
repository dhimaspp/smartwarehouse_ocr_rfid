import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:rxdart/rxdart.dart';

class GetAllPOBloc {
  final PoRepository _poRepository = PoRepository();
  final BehaviorSubject<POList> _subject = BehaviorSubject<POList>();

  getallPOrx() async {
    print('getallPO');
    POList response = await _poRepository.getAllPO();
    _subject.sink.add(response);
  }

  dispose() async {
    _subject.close();
  }

  BehaviorSubject<POList> get subject => _subject;
}

final getAllPOBloc = GetAllPOBloc();
