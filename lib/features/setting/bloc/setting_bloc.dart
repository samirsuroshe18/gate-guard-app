import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/setting/repository/setting_repository.dart';

import '../../../utils/api_error.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState>{
  final SettingRepository _settingRepository;
  SettingBloc({required SettingRepository settingRepository}) : _settingRepository=settingRepository, super (SettingInitial()){

    on<SettingChangePassword>((event, emit) async {
      emit(SettingChangePassLoading());
      try{
        final Map<String, dynamic> response = await _settingRepository.changePassword(oldPassword: event.oldPassword, newPassword: event.newPassword);
        emit(SettingChangePassSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(SettingChangePassFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(SettingChangePassFailure(message: e.toString()));
        }
      }
    });



  }
}