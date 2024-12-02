import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/guard_profile/repository/guard_profile_repository.dart';

import '../../../utils/api_error.dart';

part 'guard_profile_event.dart';
part 'guard_profile_state.dart';

class GuardProfileBloc extends Bloc<GuardProfileEvent, GuardProfileState>{
  final GuardProfileRepository _guardProfileRepository;
  GuardProfileBloc({required GuardProfileRepository guardProfileRepository}) : _guardProfileRepository=guardProfileRepository, super (GuardProfileInitial()){

    on<GuardUpdateDetails>((event, emit) async {
      emit(GuardUpdateDetailsLoading());
      try{
        final Map<String, dynamic> response = await _guardProfileRepository.updateDetails(userName: event.userName, profile: event.profile);
        emit(GuardUpdateDetailsSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GuardUpdateDetailsFailure(message:e.message.toString(), status: e.statusCode));
        }else{
          emit(GuardUpdateDetailsFailure(message: e.toString()));
        }
      }
    });

  }
}