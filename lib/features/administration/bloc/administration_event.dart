part of 'administration_bloc.dart';

@immutable
sealed class AdministrationEvent{}

final class AdminGetPendingResidentReq extends AdministrationEvent{}

final class AdminGetPendingGuardReq extends AdministrationEvent{}

final class AdminVerifyResident extends AdministrationEvent{
  final String requestId;
  final String user;
  final String residentStatus;

  AdminVerifyResident({required this.requestId, required this.user, required this.residentStatus});
}

final class AdminVerifyGuard extends AdministrationEvent{
  final String requestId;
  final String user;
  final String guardStatus;

  AdminVerifyGuard({required this.requestId, required this.user, required this.guardStatus});
}
