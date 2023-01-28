import 'package:flutter_bloc/flutter_bloc.dart';

class OyunModuCubit extends Cubit<OyunModuState> {
  OyunModuCubit() : super(TekliBasla());

  void teklibasla() => emit(TekliBasla());
  void coklubasla() => emit(CokluBasla());
}

abstract class OyunModuState {}

class TekliBasla extends OyunModuState {}

class CokluBasla extends OyunModuState {}
