import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/watch_my_requests.dart';
import 'my_requests_event.dart';
import 'my_requests_state.dart';

class MyRequestsBloc extends Bloc<MyRequestsEvent, MyRequestsState> {
  MyRequestsBloc({required WatchMyRequests watchMyRequests})
      : _watchMyRequests = watchMyRequests,
        super(MyRequestsLoading()) {
    on<MyRequestsStarted>(_onStarted);
  }

  final WatchMyRequests _watchMyRequests;

  Future<void> _onStarted(
      MyRequestsStarted event,
      Emitter<MyRequestsState> emit,
      ) async {
    await emit.forEach(
      _watchMyRequests(),
      onData: (requests) => MyRequestsLoaded(requests),
      onError: (error, stackTrace) =>
          MyRequestsFailure('Could not load your requests.'),
    );
  }
}