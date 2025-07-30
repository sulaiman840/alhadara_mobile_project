
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/notification_model.dart';
import '../data/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repo;
  NotificationsCubit(this._repo) : super(NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final list = await _repo.getNotifications();
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(const NotificationsError('Could not load notifications'));
    }
  }
}
