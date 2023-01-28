import 'package:fair_app/models/kart_destesi_cubit.dart';
import 'package:fair_app/widgets/custom_my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuanlaCubit extends Cubit<double> {
  PuanlaCubit() : super(0);

  double puan = 0;
  double digerpuan = 0;

  List<List> kontrolmax2 = [];

  void teklimodKontrolFonk(
      {required BuildContext context,
      required List kartbilgisi,
      required int kalanSure,
      required int index}) async {
    if (kontrolmax2.length < 2) {
      kartbilgisi.add(index);
      kontrolmax2.insert(0, kartbilgisi);
    }

    if (kontrolmax2.length == 2) {
      if (kontrolmax2[0].last == kontrolmax2[1].last) {
        myCoolSnackBar(
          title: "",
          description: "Aynı Karta Tıkladın",
        );
      } else {
        if (kontrolmax2[0][0] == kontrolmax2[1][0]) {
          puan = puan +
              ((2 * kontrolmax2[0][1] * kontrolmax2[0][3]) * (kalanSure / 10));
          // ignore: use_build_context_synchronously
          context
              .read<SingleCubit>()
              .kartacikkalsin(index: kontrolmax2[0].last);
          // ignore: use_build_context_synchronously
          context
              .read<SingleCubit>()
              .kartacikkalsin(index: kontrolmax2[1].last);

          context.read<SingleCubit>().kartiAc(index: kontrolmax2[0].last);
          // ignore: use_build_context_synchronously
          context.read<SingleCubit>().kartiAc(index: kontrolmax2[1].last);
        } else {
          if (kontrolmax2[0][2] == kontrolmax2[1][2]) {
            puan = puan -
                ((kontrolmax2[0][1] + kontrolmax2[1][1]) / kontrolmax2[0][3]) *
                    ((45 - kalanSure) / 10);
          } else {
            puan = puan -
                (((kontrolmax2[0][1] + kontrolmax2[1][1]) / 2) *
                    (kontrolmax2[0][3] * kontrolmax2[1][3]) *
                    ((45 - kalanSure) / 10));
          }
          await Future.delayed(const Duration(seconds: 1));

          // ignore: use_build_context_synchronously

          for (var i = 0; i < kontrolmax2.length; i++) {
            // ignore: use_build_context_synchronously
            context.read<SingleCubit>().kartiKapat(index: kontrolmax2[i].last);
          }
        }

        emit(puan);
      }
      kontrolmax2.clear();
    }
  }

  void puansifirla() {
    puan = 0;
    kontrolmax2.clear();
    emit(puan);
  }
}

abstract class PuanlaState {}

class PuanlaInitial extends PuanlaState {
  double puan;
  PuanlaInitial({required this.puan});
}
