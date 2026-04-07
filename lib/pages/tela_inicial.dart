import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../controllers/imc_controller.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../widgets/neon_widgets.dart';
import 'tela_lista_imc.dart';

class TelaInicial extends StatelessWidget {
  final ImcController controller;

  const TelaInicial({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FundoNeon(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  FadeInDown(
                    duration: const Duration(milliseconds: 900),
                    child: const _NeonPulseIcon(),
                  ),
                  const SizedBox(height: 36),
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 150),
                    child: const _NeonProntuario(),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Controle digital para calculo de IMC e acompanhamento nutricional.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 280),
                    child: SizedBox(
                      width: 250,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            criarRotaNeon(
                              pagina: TelaListaImc(controller: controller),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.neonGreen,
                            width: 1.6,
                          ),
                          foregroundColor: AppColors.neonGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shadowColor: AppColors.neonGreen,
                        ),
                        child: const Text(
                          'ACESSAR',
                          style: TextStyle(
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NeonPulseIcon extends StatelessWidget {
  const _NeonPulseIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.panel.withAlpha(90),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Icon(
        Icons.monitor_heart_outlined,
        size: 118,
        color: AppColors.neonGreen,
        shadows: const [Shadow(color: AppColors.neonGreen, blurRadius: 24)],
      ),
    );
  }
}

class _NeonProntuario extends StatelessWidget {
  const _NeonProntuario();

  Widget _cartao(double deslocamento, double opacidade) {
    // Desloquei cada cartao levemente para criar a sensacao de pilha de
    // prontuarios sem usar imagens.
    // (Doc: Stack, Transform.translate e BoxDecoration flutter)
    return Transform.translate(
      offset: Offset(deslocamento, deslocamento * -0.2),
      child: Container(
        height: 122,
        width: 96,
        decoration: BoxDecoration(
          color: AppColors.panel.withAlpha((90 + opacidade * 60).round()),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.neonGreen.withAlpha(
              (90 + opacidade * 100).round(),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withAlpha(
                (20 + opacidade * 30).round(),
              ),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _cartao(26, 0.2),
          _cartao(12, 0.45),
          Container(
            height: 128,
            width: 98,
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.neonGreen),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonGreen.withAlpha(60),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.badge_outlined,
              size: 52,
              color: AppColors.neonGreen,
              shadows: [Shadow(color: AppColors.neonGreen, blurRadius: 22)],
            ),
          ),
        ],
      ),
    );
  }
}
