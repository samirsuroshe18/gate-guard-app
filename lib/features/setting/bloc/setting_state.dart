part of 'setting_bloc.dart';

@immutable
sealed class SettingState{}

final class SettingInitial extends SettingState{}

/// For Change password
final class SettingChangePassLoading extends SettingState{}

final class SettingChangePassSuccess extends SettingState{
  final Map<String, dynamic> response;
  SettingChangePassSuccess({required this.response});
}

final class SettingChangePassFailure extends SettingState{
  final String message;
  final int? status;

  SettingChangePassFailure( {required this.message, this.status});
}