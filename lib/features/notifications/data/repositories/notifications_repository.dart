
import '../datasources/notifications_remote_data_source.dart';
import '../models/notification_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remote;
  NotificationsRepositoryImpl(this._remote);

  @override
  Future<List<NotificationModel>> getNotifications() {
    return _remote.fetchNotifications();
  }
}
