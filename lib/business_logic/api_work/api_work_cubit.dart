import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'api_work_state.dart';

class ApiWorkCubit extends Cubit<ApiWorkState> {
  ApiWorkCubit() : super(ApiWorkState.initial());

  void selectModel(String model) {
   emit( state.copyWith(selectedModel: model));
  }
}
