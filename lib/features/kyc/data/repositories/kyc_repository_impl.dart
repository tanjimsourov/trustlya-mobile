import 'dart:async';

import '../../../../core/utils/result.dart';
import '../../domain/entities/kyc_status.dart';
import '../../domain/repositories/kyc_repository.dart';

abstract class KycDataSource implements KycRepository {}

class MockKycDataSource implements KycDataSource {
  KycStatus _status =
      KycStatus(status: 'not_started', message: 'KYC not started');

  @override
  Future<Result<void>> startKyc() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _status = KycStatus(status: 'pending', message: 'Please upload documents');
    return const Result.success(null);
  }

  @override
  Future<Result<void>> uploadIdentity(String documentPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _status = KycStatus(
      status: 'pending',
      message: 'Identity uploaded, awaiting document',
    );
    return const Result.success(null);
  }

  @override
  Future<Result<void>> uploadDocument(String documentPath) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _status =
        KycStatus(status: 'under_review', message: 'Documents under review');
    return const Result.success(null);
  }

  @override
  Future<Result<KycStatus>> getStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_status);
  }
}

class KycRepositoryImpl implements KycRepository {
  KycRepositoryImpl({KycDataSource? dataSource})
      : _dataSource = dataSource ?? MockKycDataSource();

  final KycDataSource _dataSource;

  @override
  Future<Result<void>> startKyc() {
    return _dataSource.startKyc();
  }

  @override
  Future<Result<void>> uploadIdentity(String documentPath) {
    return _dataSource.uploadIdentity(documentPath);
  }

  @override
  Future<Result<void>> uploadDocument(String documentPath) {
    return _dataSource.uploadDocument(documentPath);
  }

  @override
  Future<Result<KycStatus>> getStatus() {
    return _dataSource.getStatus();
  }
}
