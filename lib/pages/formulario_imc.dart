import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/registro_imc.dart';
import '../widgets/neon_widgets.dart';

class FormularioImc extends StatefulWidget {
  final int idRegistro;
  final RegistroImc? registroAtual;

  const FormularioImc({
    super.key,
    required this.idRegistro,
    this.registroAtual,
  });

  @override
  State<FormularioImc> createState() => _FormularioImcState();
}

class _FormularioImcState extends State<FormularioImc> {
  // Usei controllers para ler os campos e uma chave global para validar tudo
  // antes de salvar.
  // (Doc: Form, GlobalKey<FormState>, TextEditingController e validator flutter)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenchi os controllers com os valores iniciais quando existe um
    // registro em edicao, antes da tela ser desenhada.
    // (Doc: initState e TextEditingController.text flutter)
    if (widget.registroAtual != null) {
      _nomeController.text = widget.registroAtual!.nomePaciente;
      _pesoController.text = widget.registroAtual!.peso.toString();
      _alturaController.text = widget.registroAtual!.altura.toString();
      _observacaoController.text = widget.registroAtual!.observacao;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  double _converterValor(String valor) {
    return double.parse(valor.replaceAll(',', '.'));
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      // Devolvi a rota pronta para a pagina anterior decidir como
      // atualizar a lista depois da validacao.
      // (Doc: Navigator.pop result flutter)
      final RegistroImc registro = RegistroImc(
        id: widget.idRegistro,
        nomePaciente: _nomeController.text.trim(),
        peso: _converterValor(_pesoController.text),
        altura: _converterValor(_alturaController.text),
        observacao: _observacaoController.text.trim(),
      );

      Navigator.pop(context, registro);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool estaEditando = widget.registroAtual != null;

    return FundoNeon(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              children: [
                BarraSuperiorTela(
                  titulo: estaEditando ? 'EDITAR PACIENTE' : 'NOVO PACIENTE',
                ),
                const SizedBox(height: 18),
                PainelNeon(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preencha os dados do paciente',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cadastre nome, peso, altura e observacao para gerar o novo calculo de IMC.',
                          style: TextStyle(
                            height: 1.6,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do paciente',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o nome do paciente';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pesoController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Peso em kg',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o peso';
                            }
                            final double? peso = double.tryParse(
                              value.replaceAll(',', '.'),
                            );
                            if (peso == null || peso <= 0) {
                              return 'Informe um peso valido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _alturaController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Altura em metros',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe a altura';
                            }
                            final double? altura = double.tryParse(
                              value.replaceAll(',', '.'),
                            );
                            if (altura == null || altura <= 0) {
                              return 'Informe uma altura valida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _observacaoController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Observacao',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _salvar,
                            icon: const Icon(Icons.save_outlined),
                            label: Text(
                              estaEditando
                                  ? 'Salvar alteracoes'
                                  : 'Cadastrar paciente',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
