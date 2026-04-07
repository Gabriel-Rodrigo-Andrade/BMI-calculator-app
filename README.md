# Nutri IMC

Aplicativo Flutter para cálculo e acompanhamento de IMC com interface neon, animações leves e fluxo completo de cadastro, edição, consulta e exclusão de pacientes.

## Visão geral

O projeto foi desenvolvido para simular um painel digital de acompanhamento nutricional. A aplicação permite registrar pacientes, calcular automaticamente o IMC, visualizar a classificação de saúde e acessar detalhes individuais com ações de edição e remoção.

## Funcionalidades

- Cálculo automático do IMC com base em peso e altura.
- Classificação visual do resultado por faixa de IMC.
- Cadastro, edição e exclusão de pacientes.
- Busca por nome na lista de registros.
- Tela de detalhes com métricas e observações.
- Tema escuro com visual neon e transições animadas.
- Lista inicial com registros de exemplo para facilitar a demonstração.

## Tecnologias utilizadas

- Flutter
- Dart
- Material 3
- animate_do

## Regra de cálculo do IMC

O IMC é calculado pela fórmula:

$$
IMC = \frac{peso}{altura^2}
$$

Faixas utilizadas no app:

- Menor que 18,5: abaixo do peso
- De 18,5 até 24,9: peso normal
- De 25,0 até 29,9: sobrepeso
- De 30,0 até 34,9: obesidade grau I
- De 35,0 até 39,9: obesidade grau II
- Maior ou igual a 40,0: obesidade grau III

## Estrutura principal

- lib/main.dart: ponto de entrada da aplicação.
- lib/controllers/: controle de estado dos registros.
- lib/core/: tema, rotas e cores do app.
- lib/models/: modelos de dados e cálculo do IMC.
- lib/pages/: telas principais do fluxo.
- lib/widgets/: componentes visuais reutilizáveis.

## Pré-requisitos

- Flutter instalado na máquina.
- Dart SDK compatível com a versão do projeto.
- Ambiente configurado para Android, iOS, web, macOS, Linux ou Windows, conforme a plataforma desejada.

## Como executar

1. Instale as dependências:

   flutter pub get

2. Execute o projeto:

   flutter run

3. Se houver mais de um dispositivo disponível, escolha o alvo desejado na lista do Flutter.

## Observações

- Os dados iniciais exibidos na aplicação são apenas exemplos.
- O projeto não persiste dados em banco local ou remoto.
- O foco atual está na experiência visual e no fluxo de acompanhamento de IMC.

## Licença

Projeto acadêmico sem licença definida.
