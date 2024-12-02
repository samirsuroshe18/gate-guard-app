part of 'administration_bloc.dart';

@immutable
sealed class AdministrationState{}

final class AdministrationInitial extends AdministrationState{}

///Get pending resident requests
final class AdminGetPendingResidentReqLoading extends AdministrationState{}

final class AdminGetPendingResidentReqSuccess extends AdministrationState{
  final List<ResidentRequestsModel> response;
  AdminGetPendingResidentReqSuccess({required this.response});
}

final class AdminGetPendingResidentReqFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetPendingResidentReqFailure( {required this.message, this.status});
}

///Get pending guard requests
final class AdminGetPendingGuardReqLoading extends AdministrationState{}

final class AdminGetPendingGuardReqSuccess extends AdministrationState{
  final List<GuardRequestsModel> response;
  AdminGetPendingGuardReqSuccess({required this.response});
}

final class AdminGetPendingGuardReqFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminGetPendingGuardReqFailure( {required this.message, this.status});
}

///Verify guard requests
final class AdminVerifyGuardLoading extends AdministrationState{}

final class AdminVerifyGuardSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminVerifyGuardSuccess({required this.response});
}

final class AdminVerifyGuardFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminVerifyGuardFailure( {required this.message, this.status});
}

///Verify resident requests
final class AdminVerifyResidentLoading extends AdministrationState{}

final class AdminVerifyResidentSuccess extends AdministrationState{
  final Map<String, dynamic> response;
  AdminVerifyResidentSuccess({required this.response});
}

final class AdminVerifyResidentFailure extends AdministrationState{
  final String message;
  final int? status;

  AdminVerifyResidentFailure( {required this.message, this.status});
}