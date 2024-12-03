part of 'guard_profile_bloc.dart';

@immutable
sealed class GuardProfileEvent{}

final class GuardUpdateDetails extends GuardProfileEvent{
  final String? userName;
  final File? profile;

  GuardUpdateDetails({this.userName, this.profile});
}

final class GetCheckoutHistory extends GuardProfileEvent{}