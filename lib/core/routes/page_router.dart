import 'package:flutter/material.dart';
import 'package:paloma/core/routes/app_route.dart';
import 'package:paloma/presentation/screens/auth/sign_up.dart';
import 'package:paloma/presentation/screens/auth_gate.dart';
import 'package:paloma/presentation/screens/profile/profile_screen.dart';

class PageRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.authGate:
        return MaterialPageRoute(builder: (_) => AuthGate());
      case AppRoute.signUp:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, __) => const SignUpPage(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      case AppRoute.profile:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, __) => ProfileScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
    }
    return null;
  }
}
