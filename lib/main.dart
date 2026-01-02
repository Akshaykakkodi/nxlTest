import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/application/auth/auth_bloc.dart';
import 'package:test/application/core/theme/app_theme.dart';
import 'package:test/application/core/utils/app_details.dart';
import 'package:test/domain/auth/i_auth_facade.dart';
import 'package:test/domain/core/di/injection.dart';
import 'package:test/firebase_options.dart';
import 'package:test/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependency();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    SafeArea(
      bottom: true,
      right: false,
      left: false,
      top: false,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(sl<IAuthFacade>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test App',
        theme: AppTheme.lightTheme,
        navigatorKey: AppDetails.globalNavigatorKey,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: SplashScreen(),
      ),
    );
  }
}
