# Nutri IMC

Flutter app for BMI calculation and tracking with a neon interface, subtle animations, and a complete flow for creating, editing, viewing, and deleting patients.

## Overview

This project was built to simulate a digital nutrition tracking dashboard. The application lets users register patients, automatically calculate BMI, view health classification, and open individual details with edit and delete actions.

## Features

- Automatic BMI calculation based on weight and height.
- Visual classification by BMI range.
- Create, edit, and delete patients.
- Search records by name.
- Detail screen with metrics and observations.
- Dark theme with neon styling and animated transitions.
- Seeded sample records to make the demo easier to explore.

## Technologies used

- Flutter
- Dart
- Material 3
- animate_do

## BMI calculation rule

BMI is calculated using the formula:

$$
BMI = \frac{weight}{height^2}
$$

Ranges used in the app:

- Less than 18.5: underweight
- From 18.5 to 24.9: normal weight
- From 25.0 to 29.9: overweight
- From 30.0 to 34.9: obesity class I
- From 35.0 to 39.9: obesity class II
- Greater than or equal to 40.0: obesity class III

## Main structure

- lib/main.dart: application entry point.
- lib/controllers/: record state management.
- lib/core/: app theme, routes, and colors.
- lib/models/: data models and BMI calculation.
- lib/pages/: main flow screens.
- lib/widgets/: reusable visual components.

## Prerequisites

- Flutter installed on your machine.
- A Dart SDK version compatible with the project.
- A configured environment for Android, iOS, web, macOS, Linux, or Windows, depending on your target platform.

## How to run

1. Install dependencies:

   flutter pub get

2. Run the project:

   flutter run

3. If multiple devices are available, select the desired target from the Flutter device list.

## Notes

- The initial records shown in the app are sample data only.
- The project does not persist data in a local or remote database.
- The current focus is the visual experience and BMI tracking flow.

## License

Academic project with no defined license.
