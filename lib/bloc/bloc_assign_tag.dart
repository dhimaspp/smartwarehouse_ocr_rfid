import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/tag_model.dart';

class AssignTagCubit extends Cubit<AssignTagState> {
  AssignTagCubit() : super(AssignTagInitial());

  Future<void> assignTag(String recID, String uid) async {
    final PoRepository poRepository = PoRepository();
    final result = await poRepository.postAssignTag(recID, uid);

    print(result);
    if (result is TagModel) {
      print('-----> AssignTag success');
      emit(AssignTagLoaded(result));
    } else if (result is String) {
      print('loading AssignTag failed');
      emit(AssignTagLoadingFailed(result.message));
    }
  }
}

abstract class AssignTagState extends Equatable {
  const AssignTagState();

  @override
  List<Object> get props => [];
}

class AssignTagInitial extends AssignTagState {}

class AssignTagLoaded extends AssignTagState {
  final TagModel tagModel;

  AssignTagLoaded(this.tagModel);

  @override
  List<Object> get props => [tagModel];
}

class AssignTagLoadingFailed extends AssignTagState {
  final String message;

  AssignTagLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}
