import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/administration/models/guard_requests_model.dart';
import 'package:gate_guard/features/administration/models/resident_requests_model.dart';
import 'package:gate_guard/features/administration/models/society_guard.dart';
import 'package:gate_guard/features/administration/models/society_member.dart';
import 'package:gate_guard/features/administration/repository/administration_repository.dart';

import '../../../utils/api_error.dart';

part 'administration_event.dart';
part 'administration_state.dart';

class AdministrationBloc extends Bloc<AdministrationEvent, AdministrationState>{
  final AdministrationRepository _administrationRepository;
  AdministrationBloc({required AdministrationRepository administrationRepository}) : _administrationRepository=administrationRepository, super (AdministrationInitial()){

    on<AdminGetPendingResidentReq>((event, emit) async {
      emit(AdminGetPendingResidentReqLoading());
      try{
        final List<ResidentRequestsModel> response = await _administrationRepository.getPendingResidentRequest();
        emit(AdminGetPendingResidentReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingResidentReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingResidentReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetPendingGuardReq>((event, emit) async {
      emit(AdminGetPendingGuardReqLoading());
      try{
        final List<GuardRequestsModel> response = await _administrationRepository.getPendingGuardRequest();
        emit(AdminGetPendingGuardReqSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetPendingGuardReqFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetPendingGuardReqFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyResident>((event, emit) async {
      emit(AdminVerifyResidentLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyResidentRequest(requestId: event.requestId, user: event.user, residentStatus: event.residentStatus, );
        emit(AdminVerifyResidentSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyResidentFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyResidentFailure(message: e.toString()));
        }
      }
    });

    on<AdminVerifyGuard>((event, emit) async {
      emit(AdminVerifyGuardLoading());
      try{
        final Map<String, dynamic> response = await _administrationRepository.verifyGuardRequest(requestId: event.requestId, user: event.user, guardStatus: event.guardStatus);
        emit(AdminVerifyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminVerifyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminVerifyGuardFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyMember>((event, emit) async {
      emit(AdminGetSocietyMemberLoading());
      try{
        final List<SocietyMember> response = await _administrationRepository.getAllResidents();
        emit(AdminGetSocietyMemberSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyMemberFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyMemberFailure(message: e.toString()));
        }
      }
    });

    on<AdminGetSocietyGuard>((event, emit) async {
      emit(AdminGetSocietyGuardLoading());
      try{
        final List<SocietyGuard> response = await _administrationRepository.getAllGuards();
        emit(AdminGetSocietyGuardSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(AdminGetSocietyGuardFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(AdminGetSocietyGuardFailure(message: e.toString()));
        }
      }
    });

  }
}