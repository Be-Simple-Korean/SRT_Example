import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/network/srt_repository.dart';
import 'package:srt_ljh/ui/login/login.dart';
import 'package:srt_ljh/ui/login/login_viewmodel.dart';
import 'package:srt_ljh/ui/main/main_viewmodel.dart';
import 'package:srt_ljh/ui/main/select_station.dart';
import 'package:srt_ljh/ui/main/main.dart';
import 'package:srt_ljh/ui/register/register_auth_viewmodel.dart';
import 'package:srt_ljh/ui/register/register_input.dart';
import 'package:srt_ljh/ui/register/register_auth.dart';
import 'package:srt_ljh/ui/register/reigster_input_viewmodel.dart';

void main() {
  runApp(const InitApp());
}

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, child) {
          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.lightThemeData,
              darkTheme: themeProvider.darkThemeData,
              themeMode: themeProvider.currentThemeMode,
              routerConfig: _router,
            );
          });
        });
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: ROUTER_ROOT_PATH,
        builder: (BuildContext context, GoRouterState state) {
          return ChangeNotifierProvider(
            create: (context) => LoginViewModel(SrtRepositroy()),
            child: const PopScope(canPop: false, child: LoginScreen()),
          );
        },
        routes: [
          GoRoute(
              path: ROUTER_REGISTER_AUTH_PATH,
              builder: (context, state) {
                return PopScope(
                  canPop: false,
                  child: ChangeNotifierProvider(
                    create: (context) => RegisterAuthViewModel(SrtRepositroy()),
                    child: const RegisterAuth(),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: ROUTER_REGISTER_PATH,
                  builder: (context, state) {
                    String email = (state.extra ?? "") as String;
                    return PopScope(
                      canPop: false,
                      child: ChangeNotifierProvider(
                          create: (context) =>
                              RegisterInputViewModel(SrtRepositroy()),
                          child: RegisterInput(email: email)),
                    );
                  },
                )
              ]),
        ]),
    GoRoute(
        path: ROUTER_MAIN_PATH,
        builder: (context, state) {
         return PopScope(
                      canPop: false,
                      child: ChangeNotifierProvider(
                          create: (context) =>
                              MainViewModel(SrtRepositroy()),
                          child: const MainScreen())
                    );
        },
        routes: [
          GoRoute(
            path: ROUTER_SELECT_STATION_PATH,
            builder: (context, state) {
              var extras = state.extra as Map<String, dynamic>;
              return PopScope(
                  canPop: false, child: SelectStation(extras: extras));
            },
          ),
        ])
  ],
);
