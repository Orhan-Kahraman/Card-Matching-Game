import 'package:fair_app/auth/screens/my_auth_layout.dart';
import 'package:fair_app/models/coklumod_puanlayici.dart';
import 'package:fair_app/models/gerisayim_cubit.dart';
import 'package:fair_app/models/kart_destesi_cubit.dart';
import 'package:fair_app/models/oyun_modu.dart';
import 'package:fair_app/models/puanlayici_cubit.dart';
import 'package:fair_app/starts_view/starts_view.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:fair_app/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grock/grock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SingleCubit()),
        BlocProvider(create: (context) => PuanlaCubit()),
        BlocProvider(create: (context) => CountDownCubit()),
        BlocProvider(create: (context) => OyunModuCubit()),
        BlocProvider(create: (context) => CoklumodPuanCubit()),
      ],
      child: MaterialApp(
          navigatorKey: Grock.navigationKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const MyAuthLayout()),
    );
  }
}
