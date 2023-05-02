import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'api_work_state.dart';

class ApiWorkCubit extends Cubit<ApiWorkState> {
  ApiWorkCubit() : super(ApiWorkInitial());
}
