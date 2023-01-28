import 'package:fair_app/i_coklu_oyuncu/coklu_basla.dart';
import 'package:fair_app/i_tekli_oyuncu/tekli_basla.dart';
import 'package:fair_app/models/oyun_modu.dart';
import 'package:fair_app/shared/const.dart';
import 'package:fair_app/shared/helpers.widget.dart';
import 'package:fair_app/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grock/grock.dart';

class StartView extends StatelessWidget {
  const StartView({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Center(child: BlocBuilder<OyunModuCubit, OyunModuState>(
        builder: (context, state) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  title: Text(
                    "Tek Oyuncu",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: kcwhite),
                  ),
                  height: height,
                  width: width,
                  ontap: () {
                    Grock.to(const SinglePlayerStarts());
                    context.read<OyunModuCubit>().teklibasla();
                  },
                ),
                verticalSpaceTiny,
                CustomElevatedButton(
                    title: Text(
                      "Çoklu Oyuncu",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: kcwhite),
                    ),
                    height: height,
                    width: width,
                    ontap: () {
                      Grock.to(const MultiPlayerStarts());
                      context.read<OyunModuCubit>().coklubasla();
                    })
              ]);
        },
      )),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "Hoşgeldiniz $username",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: kcblack54),
              )))
    ])));
  }
}
