import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../controllers/imc_controller.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../models/registro_imc.dart';
import '../models/resultado_detalhes.dart';
import '../widgets/neon_widgets.dart';
import 'formulario_imc.dart';
import 'tela_detalhes_imc.dart';

class TelaListaImc extends StatefulWidget {
  final ImcController controller;

  const TelaListaImc({
    super.key,
    required this.controller,
  });

  @override
  State<TelaListaImc> createState() => _TelaListaImcState();
}

class _TelaListaImcState extends State<TelaListaImc> {
  final TextEditingController _buscaController = TextEditingController();
  String _textoBusca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<RegistroImc> _filtrarRegistros() {
    // Deixei a lista exibida derivada do texto digitado, sem alterar a
    // colecao original do controller.
    // (Doc: Iterable.where, String.contains e toList dart)
    if (_textoBusca.trim().isEmpty) {
      return widget.controller.registros;
    }

    return widget.controller.registros.where((registro) {
      return registro.nomePaciente.toLowerCase().contains(
        _textoBusca.toLowerCase(),
      );
    }).toList();
  }

  Future<void> _abrirCadastro() async {
    // Abri o formulario e esperei um registro de volta para inserir na lista
    // quando o usuario terminar.
    // (Doc: Navigator.push e Future flutter)
    final RegistroImc? novoRegistro = await Navigator.push(
      context,
      criarRotaNeon(
        pagina: FormularioImc(idRegistro: widget.controller.proximoId),
        deslocamento: const Offset(0, 0.08),
      ),
    );

    if (novoRegistro != null) {
      widget.controller.adicionarRegistro(novoRegistro);
    }
  }

  Future<void> _abrirDetalhes(RegistroImc registro) async {
    // Fiz a tela de detalhes devolver uma acao para manter a regra de editar
    // ou excluir concentrada aqui.
    // (Doc: Navigator.push e Navigator.pop result flutter)
    final ResultadoDetalhes? resultado = await Navigator.push(
      context,
      criarRotaNeon(
        pagina: TelaDetalhesImc(registro: registro),
      ),
    );

    if (resultado == null) {
      return;
    }

    if (resultado.tipo == TipoAcao.excluir) {
      widget.controller.excluirRegistro(registro.id);
      return;
    }

    if (resultado.tipo == TipoAcao.editar && resultado.registro != null) {
      widget.controller.editarRegistro(resultado.registro!);
    }
  }

  Future<void> _mostrarClassificacaoImc() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Classificacao do IMC',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: RegistroImc.faixasClassificacao.map((faixa) {
              return LinhaClassificacao(
                faixa: faixa.faixa,
                classificacao: faixa.classificacao,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Fechar',
                style: TextStyle(color: AppColors.neonGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FundoNeon(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          // Usei o AnimatedBuilder para escutar o controller e reconstruir a
          // interface sempre que os registros mudam, sem setState() global.
          // (Doc: AnimatedBuilder e Listenable flutter)
          final List<RegistroImc> registros = _filtrarRegistros();

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleButtonNeon(
                        icone: Icons.arrow_back_ios_new_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _CampoBusca(
                            controller: _buscaController,
                            onChanged: (value) {
                              setState(() {
                                _textoBusca = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        const _AvatarPerfil(),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LISTA DE PACIENTES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: registros.isEmpty
                          ? const _PainelVazioNeon()
                          : ListView.separated(
                              itemCount: registros.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 14);
                              },
                              itemBuilder: (context, index) {
                                final RegistroImc registro = registros[index];

                                return FadeInUp(
                                  // Usei um delay proporcional ao indice para
                                  // criar uma entrada em cascata para os cards.
                                  // (Doc: FadeInUp animate_do e Duration flutter)
                                  duration: const Duration(milliseconds: 500),
                                  delay: Duration(milliseconds: 70 * index),
                                  child: _CardPaciente(
                                    registro: registro,
                                    onTap: () {
                                      _abrirDetalhes(registro);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: 'ajudaImc',
                    onPressed: _mostrarClassificacaoImc,
                    backgroundColor: AppColors.panel,
                    child: const Icon(
                      Icons.question_mark,
                      color: AppColors.neonBlue,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'adicionarRegistro',
                    onPressed: _abrirCadastro,
                    backgroundColor: AppColors.panel,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.neonGreen,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CampoBusca extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _CampoBusca({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.panelSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Buscar paciente',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPerfil extends StatelessWidget {
  const _AvatarPerfil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neonGreen),
        boxShadow: const [
          BoxShadow(
            color: Color(0x557dff8e),
            blurRadius: 18,
          ),
        ],
      ),
      child: const CircleAvatar(
        backgroundColor: AppColors.panel,
        child: Text(
          'G',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _CardPaciente extends StatelessWidget {
  final RegistroImc registro;
  final VoidCallback onTap;

  const _CardPaciente({
    required this.registro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.panelSoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: registro.corStatus.withAlpha(120)),
          boxShadow: [
            BoxShadow(
              color: registro.corStatus.withAlpha(26),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            _AvatarPaciente(
              nome: registro.nomePaciente,
              cor: registro.corStatus,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    registro.nomePaciente,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'IMC: ${registro.imc.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          registro.statusVisual,
                          style: TextStyle(
                            fontSize: 16,
                            color: registro.corStatus,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: registro.corStatus,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: registro.corStatus.withAlpha(130),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPaciente extends StatelessWidget {
  final String nome;
  final Color cor;

  const _AvatarPaciente({
    required this.nome,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> partes = nome.split(' ');
    // Gerei um avatar textual com a inicial do nome ou com as iniciais do
    // primeiro e do ultimo sobrenome.
    // (Doc: String.split, substring e interpolacao dart)
    final String iniciais = partes.length == 1
        ? partes.first.substring(0, 1).toUpperCase()
        : '${partes.first[0]}${partes.last[0]}'.toUpperCase();

    return Container(
      height: 62,
      width: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [cor.withAlpha(220), Colors.white24],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: cor.withAlpha(80),
            blurRadius: 18,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.panel,
        child: Text(
          iniciais,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _PainelVazioNeon extends StatelessWidget {
  const _PainelVazioNeon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PainelNeon(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_search_outlined,
              size: 56,
              color: AppColors.neonBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum paciente encontrado.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cadastre um novo paciente ou ajuste a busca.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.6,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
