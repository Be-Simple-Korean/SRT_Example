import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/network/srt_repository.dart';
import 'package:srt_ljh/ui/login/login.dart';
import 'package:srt_ljh/ui/login/login_viewmodel.dart';
import 'package:srt_ljh/ui/main/select_station.dart';
import 'package:srt_ljh/ui/main/main.dart';
import 'package:srt_ljh/ui/register/register_input.dart';
import 'package:srt_ljh/ui/register/register_auth.dart';
import 'package:srt_ljh/ui/register/register_providers.dart';

void main() {
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: _router,
  ));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: ROUTER_ROOT_PATH,
        builder: (BuildContext context, GoRouterState state) {
          return ChangeNotifierProvider(
            create: (context) => LoginViewModel(SrtRepositroy()),
            child: const LoginScreen(),
          );
        },
        routes: [
          GoRoute(
              path: ROUTER_REGISTER_AUTH_PATH,
              builder: (context, state) {
                return ChangeNotifierProvider(
                  create: (context) => AuthController(),
                  child: const RegisterAuth(),
                );
              },
              routes: [
                GoRoute(
                  path: ROUTER_REGISTER_PATH,
                  builder: (context, state) {
                    String email = (state.extra ?? "") as String;
                    return Register(email: email);
                  },
                )
              ]),
          GoRoute(
            path: ROUTER_SELECT_STATION_PATH,
            builder: (context, state) {
              var extras = state.extra as Map<String, dynamic>;
              return SelectStation(extras: extras);
            },
          ),
          GoRoute(
            path: ROUTER_MAIN_PATH,
            builder: (context, state) {
              return MainScreen();
            },
          )
        ]),
  ],
);
