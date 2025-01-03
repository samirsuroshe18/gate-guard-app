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

final class AdminGetSocietyMember extends AdministrationEvent{}

final class AdminGetSocietyGuard extends AdministrationEvent{}

final class AdminGetSocietyAdmin extends AdministrationEvent{}

final class AdminCreateAdmin extends AdministrationEvent{
  final String email;

  AdminCreateAdmin({required this.email});
}

final class AdminRemoveAdmin extends AdministrationEvent{
  final String email;

  AdminRemoveAdmin({required this.email});
}

final class AdminRemoveResident extends AdministrationEvent{
  final String id;

  AdminRemoveResident({required this.id});
}

final class AdminRemoveGuard extends AdministrationEvent{
  final String id;

  AdminRemoveGuard({required this.id});
}
