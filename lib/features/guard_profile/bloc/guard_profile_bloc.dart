import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/guard_profile/repository/guard_profile_repository.dart';

part 'guard_profile_event.dart';
part 'guard_profile_state.dart';

class GuardProfileBloc extends Bloc<GuardProfileEvent, GuardProfileState>{
  final GuardProfileRepository _guardProfileRepository;
  GuardProfileBloc({required GuardProfileRepository guardProfileRepository}) : _guardProfileRepository=guardProfileRepository, super (GuardProfileInitial()){

  }
}