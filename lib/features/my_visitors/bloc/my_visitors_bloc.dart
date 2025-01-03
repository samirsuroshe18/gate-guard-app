import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_guard/features/my_visitors/repository/my_visitors_repository.dart';

import '../../../utils/api_error.dart';
import '../../guard_waiting/models/entry.dart';
import '../../invite_visitors/models/pre_approved_banner.dart';

part 'my_visitors_event.dart';
part 'my_visitors_state.dart';

class MyVisitorsBloc extends Bloc<MyVisitorsEvent, MyVisitorsState>{
  final MyVisitorsRepository _myVisitorsRepository;
  MyVisitorsBloc({required MyVisitorsRepository myVisitorsRepository}) : _myVisitorsRepository=myVisitorsRepository, super (MyVisitorsInitial()){

    on<GetExpectedEntries>((event, emit) async {
      emit(GetExpectedEntriesLoading());
      try{
        final response = await _myVisitorsRepository.getExpectedEntries();
        emit(GetExpectedEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetExpectedEntriesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetExpectedEntriesFailure(message: e.toString()));
        }
      }
    });

    on<GetCurrentEntries>((event, emit) async {
      emit(GetCurrentEntriesLoading());
      try{
        final response = await _myVisitorsRepository.getCurrentEntries();
        emit(GetCurrentEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetCurrentEntriesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetCurrentEntriesFailure(message: e.toString()));
        }
      }
    });

    on<GetPastEntries>((event, emit) async {
      emit(GetPastEntriesLoading());
      try{
        final response = await _myVisitorsRepository.getPastEntries();
        emit(GetPastEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetPastEntriesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetPastEntriesFailure(message: e.toString()));
        }
      }
    });

    on<GetDeniedEntries>((event, emit) async {
      emit(GetDeniedEntriesLoading());
      try{
        final List<Entry> response = await _myVisitorsRepository.getDeniedEntries();
        emit(GetDeniedEntriesSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetDeniedEntriesFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetDeniedEntriesFailure(message: e.toString()));
        }
      }
    });

    on<GetServiceRequest>((event, emit) async {
      emit(GetServiceRequestLoading());
      try{
        final Entry response = await _myVisitorsRepository.getServiceRequest();
        emit(GetServiceRequestSuccess(response: response));
      }catch(e){
        if (e is ApiError) {
          emit(GetServiceRequestFailure(message: e.message.toString(), status: e.statusCode));
        }else{
          emit(GetServiceRequestFailure(message: e.toString()));
        }
      }
    });

  }
}