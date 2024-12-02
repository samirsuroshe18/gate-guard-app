part of 'guard_profile_bloc.dart';

@immutable
sealed class GuardProfileState{}

final class GuardProfileInitial extends GuardProfileState{}

/// Exit entries
final class GuardUpdateDetailsLoading extends GuardProfileState{}

final class GuardUpdateDetailsSuccess extends GuardProfileState{
  final Map<String, dynamic> response;
  GuardUpdateDetailsSuccess({required this.response});
}

final class GuardUpdateDetailsFailure extends GuardProfileState{
  final String message;
  final int? status;

  GuardUpdateDetailsFailure( {required this.message, this.status});
}