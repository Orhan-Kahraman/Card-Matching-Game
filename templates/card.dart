import 'package:fair_app/models/coklumod_puanlayici.dart';
import 'package:fair_app/models/gerisayim_cubit.dart';
import 'package:fair_app/models/kart_destesi_cubit.dart';
import 'package:fair_app/models/oyun_modu.dart';
import 'package:fair_app/models/puanlayici_cubit.dart';
import 'package:fair_app/shared/const.dart';
import 'package:fair_app/widgets/custom_my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Kart extends StatelessWidget {
  const Kart({super.key, required this.image, required this.index});
  final Widget image;
  final int index;
  // bool tiklamaAcik = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(child: BlocBuilder<CountDownCubit, int>(
      builder: (cdcontext, cdstate) {
        return BlocBuilder<PuanlaCubit, double>(
            builder: (puanlaContext, puanlaState) {
          return BlocBuilder<SingleCubit, SingleState>(
              builder: (context, state) {
            return BlocBuilder<OyunModuCubit, OyunModuState>(
              builder: (modcontext, modstate) {
                return BlocBuilder<CoklumodPuanCubit, List>(
                  builder: (coklucontext, coklustate) {
                    return GestureDetector(
                      onTap: state is SingleInitial
                          ? state.anaKartListesi[index][6]
                              ? () async {
                                  context
                                      .read<SingleCubit>()
                                      .kartiTersCevir(index: index);
                                  if (modstate is TekliBasla) {
                                    puanlaContext
                                        .read<PuanlaCubit>()
                                        .teklimodKontrolFonk(
                                            context: context,
                                            kartbilgisi: context
                                                .read<SingleCubit>()
                                                .instance
                                                .anaKartListesi[index],
                                            kalanSure: cdstate,
                                            index: index);
                                  } else if (state is CokluBasla) {
                                    coklucontext
                                        .read<CoklumodPuanCubit>()
                                        .coklumodKontrolFonk(
                                            context: context,
                                            kartbilgisi: context
                                                .read<SingleCubit>()
                                                .instance
                                                .anaKartListesi[index],
                                            kalanSure: cdstate,
                                            index: index);
                                  }

                                  context.read<SingleCubit>().hepsiacikmi();
                                }
                              : () {
                                  myCoolSnackBar(
                                      description: "Bu kart doğru bilindi");
                                }
                          : () {
                              myCoolSnackBar(
                                  description: "Karşılaştırma Sürüyor");
                            },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: kcPrimaryCascadeTwilight, width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        height: height * 0.3,
                        width: width * 0.4,
                        child: state is SingleInitial
                            ? state.anaKartListesi[index][5]
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: image)
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child:
                                        Image.asset("assets/images/Arka.jpg"))
                            : null,
                      ),
                    );
                  },
                );
              },
            );
          });
        });
      },
    ));
  }
}
