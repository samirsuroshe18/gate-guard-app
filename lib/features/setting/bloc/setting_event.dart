part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent{}

final class SettingChangePassword extends SettingEvent{
  final String oldPassword;
  final String newPassword;

  SettingChangePassword({required this.oldPassword, required this.newPassword});
}