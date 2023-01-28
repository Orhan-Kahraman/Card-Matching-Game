import 'package:fair_app/i_coklu_oyuncu/oyun_ekrani_coklu.dart';
import 'package:fair_app/i_tekli_oyuncu/oyun_ekrani.dart';
import 'package:fair_app/models/kart_destesi_cubit.dart';
import 'package:fair_app/shared/const.dart';
import 'package:fair_app/shared/helpers.widget.dart';
import 'package:fair_app/starts_view/starts_view.dart';
import 'package:fair_app/widgets/custom_buttons.dart';
import 'package:fair_app/widgets/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grock/grock.dart';

class MultiPlayerStarts extends StatelessWidget {
  const MultiPlayerStarts({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "Çoklu Oyuncu Modu",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: kcblack54),
              ))),
      BlocBuilder<SingleCubit, SingleState>(
        builder: (context, state) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                CustomElevatedButton(
                    title: Text(
                      "2x2 Kolay Mod",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: kcwhite),
                    ),
                    height: height,
                    width: width,
                    ontap: () {
                      Grock.to(const GameScreenSingle());
                      context
                          .read<SingleCubit>()
                          .ikilikOyun(context: context, sayi: 60);
                    }),
                verticalSpaceTiny,
                CustomElevatedButton(
                    title: Text(
                      "4x4 Orta Mod",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: kcwhite),
                    ),
                    height: height,
                    width: width,
                    ontap: () {
                      Grock.to(const GameScreenSingle());
                      context
                          .read<SingleCubit>()
                          .dortlukOyun(context: context, sayi: 60);
                    }),
                verticalSpaceTiny,
                CustomElevatedButton(
                    title: Text(
                      "10x10 Zor Mod",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: kcwhite),
                    ),
                    height: height,
                    width: width,
                    ontap: () {
                      Grock.to(const GameScreenSingle());
                      context
                          .read<SingleCubit>()
                          .sekizlikOyun(context: context, sayi: 60);
                    })
              ]));
        },
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 25),
          child: myfloatingActionButton(
            icon: Icons.arrow_back_ios_outlined,
            onPressed: () {
              Grock.to(const StartView(username: ""));
            },
          ),
        ),
      )
    ])));
  }
}
