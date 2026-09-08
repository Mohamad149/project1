import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/submit_request.dart';
import 'submit_request_event.dart';
import 'submit_request_state.dart';

class SubmitRequestBloc extends Bloc<SubmitRequestEvent, SubmitRequestState> {
  SubmitRequestBloc({required SubmitRequest submitRequest})
      : _submitRequest = submitRequest,
        super(SubmitRequestInitial()) {
    on<SubmitRequestPressed>(_onPressed);
  }

  final SubmitRequest _submitRequest;

  Future<void> _onPressed(
      SubmitRequestPressed event,
      Emitter<SubmitRequestState> emit,
      ) async {
    emit(SubmitRequestLoading());

    try {
      await _submitRequest(
        title: event.title,
        description: event.description,
        category: event.category,
      );
      emit(SubmitRequestSuccess());
    } on Failure catch (error) {
      emit(SubmitRequestFailure(error.message));
    } catch (_) {
      emit(SubmitRequestFailure('Could not submit your request.'));
    }
  }
}