import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/best_score_cubit.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HatrickApp());
}

class HatrickApp extends StatelessWidget {
  const HatrickApp({super.key});

  @override
  Widget build(BuildContext context) {
    // App-wide cubit: the best score is needed by Home and Quiz flow.
    return BlocProvider(
      create: (_) => BestScoreCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hatrick',
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}
