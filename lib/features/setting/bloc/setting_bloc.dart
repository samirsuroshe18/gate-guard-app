import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/setting/repository/setting_repository.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState>{
  final SettingRepository _settingRepository;
  SettingBloc({required SettingRepository settingRepository}) : _settingRepository=settingRepository, super (SettingInitial()){

  }
}