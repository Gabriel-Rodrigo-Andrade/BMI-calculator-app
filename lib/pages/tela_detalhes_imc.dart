import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../models/registro_imc.dart';
import '../models/resultado_detalhes.dart';
import '../widgets/neon_widgets.dart';
import 'formulario_imc.dart';

class TelaDetalhesImc extends StatelessWidget {
  final RegistroImc registro;

  const TelaDetalhesImc({
    super.key,
    required this.registro,
  });

  Future<void> _editarRegistro(BuildContext context) async {
    // Abri o formulario em modo de edicao e recebi o registro atualizado para
    // devolver esse resultado a tela anterior.
    // (Doc: Navigator.push e Navigator.pop result flutter)
    final RegistroImc? registroEditado = await Navigator.push(
      context,
      criarRotaNeon(
        pagina: FormularioImc(
          idRegistro: registro.id,
          registroAtual: registro,
        ),
        deslocamento: const Offset(0, 0.08),
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (registroEditado != null) {
      Navigator.pop(
        context,
        ResultadoDetalhes(
          tipo: TipoAcao.editar,
          registro: registroEditado,
        ),
      );
    }
  }

  Future<void> _excluirRegistro(BuildContext context) async {
    // Mostrei uma confirmacao modal antes de excluir e so continuei se o
    // contexto ainda estivesse ativo depois do await.
    // (Doc: showDialog, AlertDialog e BuildContext.mounted flutter)
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir registro',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            'Deseja excluir o registro de ${registro.nomePaciente}?',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: AppColors.neonRed),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) {
      return;
    }

    if (confirmar == true) {
      Navigator.pop(
        context,
        const ResultadoDetalhes(tipo: TipoAcao.excluir),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FundoNeon(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              children: [
                const BarraSuperiorTela(titulo: 'PATIENT SINGLE SCREEN'),
                const SizedBox(height: 18),
                PainelNeon(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BMI:',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              registro.imc.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 54,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                color: registro.corStatus,
                                shadows: [
                                  Shadow(
                                    color: registro.corStatus.withAlpha(140),
                                    blurRadius: 26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              registro.statusVisual,
                              style: TextStyle(
                                fontSize: 20,
                                color: registro.corStatus,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              registro.nomePaciente,
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      _FiguraCorpoNeon(cor: registro.corStatus),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PainelNeon(
                  child: Column(
                    children: [
                      IndicadorMetrica(
                        icone: Icons.height,
                        titulo: 'Height',
                        valor: '${registro.altura.toStringAsFixed(2)}m',
                        progresso: registro.progressoAltura,
                        cor: AppColors.neonBlue,
                      ),
                      const SizedBox(height: 18),
                      IndicadorMetrica(
                        icone: Icons.fitness_center_outlined,
                        titulo: 'Weight',
                        valor: '${registro.peso.toStringAsFixed(0)}kg',
                        progresso: registro.progressoPeso,
                        cor: AppColors.neonGreen,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PainelNeon(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observacao',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        registro.observacao.isEmpty
                            ? 'Nenhuma observacao informada.'
                            : registro.observacao,
                        style: const TextStyle(
                          height: 1.6,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _editarRegistro(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.panel,
                          foregroundColor: AppColors.neonGreen,
                          side: const BorderSide(
                            color: AppColors.neonGreen,
                            width: 1,
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _excluirRegistro(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.panel,
                          foregroundColor: AppColors.neonRed,
                          side: const BorderSide(
                            color: AppColors.neonRed,
                            width: 1,
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Excluir'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FiguraCorpoNeon extends StatelessWidget {
  final Color cor;

  const _FiguraCorpoNeon({
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            cor.withAlpha(18),
            AppColors.neonBlue.withAlpha(12),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Icon(
        Icons.accessibility_new_rounded,
        size: 112,
        color: cor,
        shadows: [
          Shadow(
            color: cor.withAlpha(160),
            blurRadius: 26,
          ),
        ],
      ),
    );
  }
}
