import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CountDownCubit extends Cubit<int> {
  CountDownCubit() : super(1);
  Timer? countDown;

  void gerisayimbaslasin(int sayi) {
    countDown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sayi >= 0) {
        emit(sayi--);
      } else {
        timer.cancel();
      }
    });
  }

  void gerisayimidurdur() {
    countDown?.cancel();
  }
}
