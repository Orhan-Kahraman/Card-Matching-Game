import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_app/models/gerisayim_cubit.dart';
import 'package:fair_app/models/puanlayici_cubit.dart';
import 'package:fair_app/shared/const.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCubit extends Cubit<SingleState> {
  SingleCubit() : super(Loading());
  Random random = Random();
  SingleInitial instance = SingleInitial(anaKartListesi: []);
  List kontrol = [];
  List<List> evler = [
    ["Gryffindor", 2],
    ["Hufflepuff", 1],
    ["Ravenclaw", 1],
    ["Slytherin", 2]
  ];

  List<List> kahramanlar = kahramanlarListesi;
  final db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  void kontrolFonk() {
    if (kontrol.length == 2) {}
  }

  // 2X2 LİK OYUN İÇİN KART LİSTESİ HAZIRLAR
  Future<void> ikilikOyun(
      {required BuildContext context, required int sayi}) async {
    emit(Loading());
    int birinciEv = random.nextInt(4);
    int ikinciEv = random.nextInt(4);
    if (birinciEv == ikinciEv) {
      return ikilikOyun(context: context, sayi: sayi);
    }
    instance.anaKartListesi.clear();
    List<List> ikilikKartListesi = [];
    String birinciKart = kahramanlar[birinciEv][random.nextInt(11)];
    String ikinciKart = kahramanlar[ikinciEv][random.nextInt(11)];

    final birinciKartBilgisi =
        await db.collection(evler[birinciEv][0]).doc(birinciKart).get();
    final birinciPuan = birinciKartBilgisi.data()?.values.first;

    final ikinciKartBilgisi =
        await db.collection(evler[ikinciEv][0]).doc(ikinciKart).get();
    final ikinciPuan = ikinciKartBilgisi.data()?.values.first;

    final birinciResimYolu =
        await storageRef.child("$birinciKart.jpg").getDownloadURL();
    final ikinciResimYolu =
        await storageRef.child("$ikinciKart.jpg").getDownloadURL();

    final Widget birinciResim = Image.network(
      birinciResimYolu,
      fit: BoxFit.contain,
    );

    final Widget ikinciResim = Image.network(
      ikinciResimYolu,
      fit: BoxFit.contain,
    );
    ikilikKartListesi = [
      [
        birinciKart,
        birinciPuan,
        evler[birinciEv][0],
        evler[birinciEv][1],
        birinciResim,
        false,
        true
      ],
      [
        ikinciKart,
        ikinciPuan,
        evler[ikinciEv][0],
        evler[ikinciEv][1],
        ikinciResim,
        false,
        true
      ]
    ];
    for (var i = 0; i < 2; i++) {
      ikilikKartListesi.add(ikilikKartListesi[i].toList());
    }
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimidurdur();
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimbaslasin(sayi);
    // ignore: use_build_context_synchronously
    context.read<PuanlaCubit>().puansifirla();
    kartlariKaristir(liste: ikilikKartListesi);
  }

  // 4X4 LÜK OYUN İÇİN KART LİSTESİ HAZIRLAR
  Future<void> dortlukOyun(
      {required BuildContext context, required int sayi}) async {
    emit(Loading());
    instance.anaKartListesi.clear();
    List<List> dortluKartListesi = [];
    dortluKartListesi = await listeYapici(listeBoyutu: 2);
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimidurdur();
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimbaslasin(sayi);
    // ignore: use_build_context_synchronously
    context.read<PuanlaCubit>().puansifirla();

    kartlariKaristir(liste: dortluKartListesi);
  }

  // 8x8 LİK OYUN İÇİN KART LİSTESİ HAZIRLAR
  Future<void> sekizlikOyun(
      {required BuildContext context, required int sayi}) async {
    emit(Loading());
    instance.anaKartListesi.clear();
    List<List> sekizlikKartListesi = [];
    sekizlikKartListesi = await listeYapici(listeBoyutu: 8);
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimidurdur();
    // ignore: use_build_context_synchronously
    context.read<CountDownCubit>().gerisayimbaslasin(sayi);
    // ignore: use_build_context_synchronously
    context.read<PuanlaCubit>().puansifirla();
    kartlariKaristir(liste: sekizlikKartListesi);
  }

  // Liste Yapıcı Fonksiyon
  Future<List<List>> listeYapici({required int listeBoyutu}) async {
    List<List> instance = [];
    for (int i = 0; i < 4; i++) {
      for (int x = 0; x < listeBoyutu; x++) {
        String kartAdi = kahramanlar[i][random.nextInt(11)];
        final kartBilgisi = await db.collection(evler[i][0]).doc(kartAdi).get();
        final kartinPuani = kartBilgisi.data()?.values.first;
        final kartinResimYolu =
            await storageRef.child("$kartAdi.jpg").getDownloadURL();
        final Widget kartinResmi = Image.network(
          kartinResimYolu,
          fit: BoxFit.contain,
        );
        instance.add([
          kartAdi,
          kartinPuani,
          evler[i][0],
          evler[i][1],
          kartinResmi,
          false,
          true
        ]);
      }
    }
    for (var i = 0; i < (listeBoyutu * 4); i++) {
      instance.add(instance[i].toList());
    }
    return instance;
  }

  // Kartları karıştıran Fonksiyon
  void kartlariKaristir({required List liste}) {
    if (liste.isNotEmpty) {
      int boyut = liste.length;
      int randomSayi = random.nextInt(boyut);
      instance.anaKartListesi.add(liste[randomSayi]);
      liste.removeAt(randomSayi);
      return kartlariKaristir(liste: liste);
    }
    emit(SingleInitial(anaKartListesi: instance.anaKartListesi));
  }

  void kartiTersCevir({required int index}) {
    instance.anaKartListesi[index][5] = !instance.anaKartListesi[index][5];
    emit(SingleInitial(anaKartListesi: instance.anaKartListesi));
  }

  void kartiAc({required int index}) {
    instance.anaKartListesi[index][5] = true;
    emit(SingleInitial(anaKartListesi: instance.anaKartListesi));
  }

  void kartiKapat({required int index}) {
    instance.anaKartListesi[index][5] = false;
    emit(SingleInitial(anaKartListesi: instance.anaKartListesi));
  }

  void kartacikkalsin({required int index}) {
    instance.anaKartListesi[index][6] = false;
    emit(SingleInitial(anaKartListesi: instance.anaKartListesi));
  }

  void hepsiacikmi() {
    bool kapalivar = false;
    for (var i = 0; i < instance.anaKartListesi.length; i++) {
      if (!instance.anaKartListesi[i][5]) {
        kapalivar = true;
        break;
      }
    }
    if (!kapalivar) {
      emit(GameOver(desteboyutu: instance.anaKartListesi.length));
    }
  }
}

abstract class SingleState {}

class SingleInitial extends SingleState {
  final List<List> anaKartListesi;

  SingleInitial({required this.anaKartListesi});
}

class Loading extends SingleState {}

class GameOver extends SingleState {
  final int desteboyutu;

  GameOver({required this.desteboyutu});
}
