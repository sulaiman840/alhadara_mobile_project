
import '../datasources/departments_remote_data_source.dart';
import '../models/department_model.dart';

abstract class DepartmentsRepository {
  Future<List<DepartmentModel>> fetchAllDepartments();
}

class DepartmentsRepositoryImpl implements DepartmentsRepository {
  final DepartmentsRemoteDataSource _remoteDataSource;
  DepartmentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<DepartmentModel>> fetchAllDepartments() {
    return _remoteDataSource.getDepartments();
  }
}
