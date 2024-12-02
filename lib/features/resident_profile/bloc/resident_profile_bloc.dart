import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/resident_profile/repository/resident_profile_repository.dart';

part 'resident_profile_event.dart';
part 'resident_profile_state.dart';

class ResidentProfileBloc extends Bloc<ResidentProfileEvent, ResidentProfileState>{
  final ResidentProfileRepository _residentProfileRepository;
  ResidentProfileBloc({required ResidentProfileRepository residentProfileRepository}) : _residentProfileRepository=residentProfileRepository, super (ResidentProfileInitial()){

  }
}