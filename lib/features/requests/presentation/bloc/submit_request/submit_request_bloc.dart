import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/submit_request.dart';
import '../../../domain/usecase/update_request.dart';
import 'submit_request_event.dart';
import 'submit_request_state.dart';

class SubmitRequestBloc extends Bloc<SubmitRequestEvent, SubmitRequestState> {
  SubmitRequestBloc({
    required SubmitRequest submitRequest,
    required UpdateRequest updateRequest,
  }) : _submitRequest = submitRequest,
        _updateRequest = updateRequest,
        super(SubmitRequestInitial()) {
    on<SubmitRequestPressed>(_onPressed);
    on<UpdateRequestPressed>(_onUpdatePressed);
  }

  final SubmitRequest _submitRequest;
  final UpdateRequest _updateRequest;

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

  Future<void> _onUpdatePressed(
      UpdateRequestPressed event,
      Emitter<SubmitRequestState> emit,
      ) async {
    emit(SubmitRequestLoading());

    try {
      await _updateRequest(
        requestId: event.requestId,
        title: event.title,
        description: event.description,
        category: event.category,
      );
      emit(SubmitRequestSuccess());
    } on Failure catch (error) {
      emit(SubmitRequestFailure(error.message));
    } catch (_) {
      emit(SubmitRequestFailure('Could not update your request.'));
    }
  }
}