// lib/features/notifications/data/datasources/notifications_remote_data_source.dart

import 'package:dio/dio.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio _dio;
  NotificationsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _dio.get('api/notifications/indexNotifications');
    if (response.statusCode == 200) {
      final rawList = response.data['notifications'] as List<dynamic>;
      return rawList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load notifications');
  }
}
