import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/trial_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:rxdart/rxdart.dart';

class BlocPO {
  final TrialRepository _trialRepository = TrialRepository();
  final BehaviorSubject<POResponse> _subject = BehaviorSubject<POResponse>();

  getPOrx() async {
    POResponse response = await _trialRepository.getJson();
    _subject.sink.add(response);
  }

  dispose() async {
    _subject.close();
  }

  BehaviorSubject<POResponse> get subject => _subject;
}

final blocPO = BlocPO();
