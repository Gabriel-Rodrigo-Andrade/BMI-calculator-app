import 'package:flutter/material.dart';

PageRouteBuilder<T> criarRotaNeon<T>({
  required Widget pagina,
  Offset deslocamento = const Offset(0.12, 0),
}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, animation, secondaryAnimation) {
      return pagina;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Combinei fade, slide e uma leve escala para dar mais identidade
      // visual a navegacao.
      // (Doc: PageRouteBuilder, CurvedAnimation, Tween e transitions flutter)
      final Animation<double> fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final Animation<Offset> slideAnimation = Tween<Offset>(
        begin: deslocamento,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );

      final Animation<double> scaleAnimation = Tween<double>(
        begin: 0.98,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}
