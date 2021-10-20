import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/model/tag_model.dart';

class DeletePOCubit extends Cubit<DeletePOState> {
  DeletePOCubit() : super(DeletePOInitial());

  Future<void> deletePO(String poNo) async {
    final PoRepository poRepository = PoRepository();
    final result = await poRepository.deletePO(poNo);

    print(result);
    if (result is TagModel) {
      print('-----> DeletePO success');
      emit(DeletePOLoaded(result));
    } else {
      print('loading DeletePO failed');
      emit(DeletePOLoadingFailed(result.message));
    }
  }
}

abstract class DeletePOState extends Equatable {
  const DeletePOState();

  @override
  List<Object?> get props => [];
}

class DeletePOInitial extends DeletePOState {}

class DeletePOLoaded extends DeletePOState {
  final TagModel tagModel;

  DeletePOLoaded(this.tagModel);

  @override
  List<Object> get props => [tagModel];
}

class DeletePOLoadingFailed extends DeletePOState {
  final String? message;

  DeletePOLoadingFailed(this.message);

  @override
  List<Object?> get props => [message];
}
