part of 'guard_profile_bloc.dart';

@immutable
sealed class GuardProfileState{}

final class GuardProfileInitial extends GuardProfileState{}

/// Update Account details
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

/// Get Checkout history
final class GetCheckoutHistoryLoading extends GuardProfileState{}

final class GetCheckoutHistorySuccess extends GuardProfileState{
  final List<CheckoutHistory> response;
  GetCheckoutHistorySuccess({required this.response});
}

final class GetCheckoutHistoryFailure extends GuardProfileState{
  final String message;
  final int? status;

  GetCheckoutHistoryFailure( {required this.message, this.status});
}