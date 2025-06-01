
import 'dart:io';
import '../datasources/complaints_remote_data_source.dart';
import '../models/complaint_model.dart';

abstract class ComplaintsRepository {
  Future<ComplaintResponse> submitComplaint({
    required String description,
    File? file,
  });
}

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final ComplaintsRemoteDataSource _remoteDataSource;
  ComplaintsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ComplaintResponse> submitComplaint({
    required String description,
    File? file,
  }) {
    return _remoteDataSource.submitComplaint(description: description, file: file);
  }
}
