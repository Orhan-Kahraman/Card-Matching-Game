import 'dart:math';

import 'package:fair_app/i_coklu_oyuncu/coklu_basla.dart';
import 'package:fair_app/i_tekli_oyuncu/tekli_basla.dart';
import 'package:fair_app/models/coklumod_puanlayici.dart';
import 'package:fair_app/models/gerisayim_cubit.dart';
import 'package:fair_app/models/kart_destesi_cubit.dart';
import 'package:fair_app/models/oyun_modu.dart';
import 'package:fair_app/models/puanlayici_cubit.dart';
import 'package:fair_app/shared/const.dart';
import 'package:fair_app/shared/helpers.widget.dart';
import 'package:fair_app/templates/card.dart';
import 'package:fair_app/widgets/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grock/grock.dart';

class GameScreenSingle extends StatelessWidget {
  const GameScreenSingle({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<OyunModuCubit, OyunModuState>(
      builder: (modcontext, modstate) {
        return Scaffold(
            floatingActionButton: myfloatingActionButton(
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                Grock.to(modstate is TekliBasla
                    ? const SinglePlayerStarts()
                    : const MultiPlayerStarts());
              },
            ),
            body: SafeArea(
                child: Stack(
              children: [
                BlocBuilder<SingleCubit, SingleState>(
                  builder: (context, state) {
                    return SizedBox(
                      child: Center(
                          child: state is SingleInitial
                              ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: width /
                                              sqrt(state.anaKartListesi.length),
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 20),
                                  itemCount: state.anaKartListesi.length,
                                  itemBuilder: (context, index) {
                                    return Kart(
                                        image: state.anaKartListesi[index][4],
                                        index: index);
                                  },
                                )
                              : state is Loading
                                  ? Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                          const CircularProgressIndicator(
                                            color: kcPrimaryCascadeTwilight,
                                          ),
                                          verticalSpaceTiny,
                                          Text("OYUN BAŞLIYOR!",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color:
                                                          kcPrimaryCascadeTwilight,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ]))
                                  : null),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20),
                    child: BlocBuilder<CountDownCubit, int>(
                      builder: (context, state) {
                        return Text(
                          state.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: kcblack54),
                        );
                      },
                    ),
                  ),
                ),
                modstate is TekliBasla
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: BlocBuilder<PuanlaCubit, double>(
                            builder: (context, state) {
                              return Text(
                                "${state.round()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: kcblack54),
                              );
                            },
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: BlocBuilder<CoklumodPuanCubit, List>(
                            builder: (context, coklustate) {
                              return Text(
                                "${coklustate[0].round()} vs${coklustate[1].round()} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: kcblack54),
                              );
                            },
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<SingleCubit, SingleState>(
                    builder: (singlecontext, singlestate) {
                      return BlocBuilder<PuanlaCubit, double>(
                        builder: (puanContext, puanState) {
                          return BlocBuilder<CountDownCubit, int>(
                            builder: (context, state) {
                              return state == 0 || singlestate is GameOver
                                  ? Container(
                                      width: width,
                                      color: const Color.fromARGB(
                                          186, 253, 147, 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Oyun Bitti",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor:
                                                        kcPrimaryCascadeTwilight,
                                                    color: kcwhite),
                                          ),
                                          Text(
                                            "Puanınız : ${puanState.round()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor:
                                                        kcPrimaryCascadeTwilight,
                                                    color: kcwhite),
                                          ),
                                          verticalSpaceTiny,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              myfloatingActionButton(
                                                icon:
                                                    Icons.restart_alt_outlined,
                                                onPressed: () {
                                                  puanContext
                                                      .read<PuanlaCubit>()
                                                      .puansifirla();
                                                  if ((singlestate
                                                              is SingleInitial &&
                                                          singlestate
                                                                  .anaKartListesi
                                                                  .length ==
                                                              4) ||
                                                      (singlestate
                                                              is GameOver &&
                                                          singlestate
                                                                  .desteboyutu ==
                                                              4)) {
                                                    context
                                                        .read<SingleCubit>()
                                                        .ikilikOyun(
                                                            context: context,
                                                            sayi: 45);
                                                  } else if ((singlestate
                                                              is SingleInitial &&
                                                          singlestate
                                                                  .anaKartListesi
                                                                  .length ==
                                                              16) ||
                                                      (singlestate
                                                              is GameOver &&
                                                          singlestate
                                                                  .desteboyutu ==
                                                              16)) {
                                                    context
                                                        .read<SingleCubit>()
                                                        .dortlukOyun(
                                                            context: context,
                                                            sayi: 45);
                                                  } else if ((singlestate
                                                              is SingleInitial &&
                                                          singlestate
                                                                  .anaKartListesi
                                                                  .length ==
                                                              64) ||
                                                      (singlestate
                                                              is GameOver &&
                                                          singlestate
                                                                  .desteboyutu ==
                                                              64)) {
                                                    context
                                                        .read<SingleCubit>()
                                                        .sekizlikOyun(
                                                            context: context,
                                                            sayi: 45);
                                                  }
                                                },
                                              ),
                                              horizontalSpaceTiny,
                                              myfloatingActionButton(
                                                icon:
                                                    Icons.exit_to_app_outlined,
                                                onPressed: () {
                                                  context
                                                      .read<CountDownCubit>()
                                                      .gerisayimidurdur();

                                                  context
                                                      .read<CountDownCubit>()
                                                      .gerisayimbaslasin(45);

                                                  context
                                                      .read<PuanlaCubit>()
                                                      .puansifirla();
                                                  Grock.to(
                                                      const SinglePlayerStarts());
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )));
      },
    );
  }
}
